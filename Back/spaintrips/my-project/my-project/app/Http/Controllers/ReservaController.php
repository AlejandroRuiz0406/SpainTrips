<?php

namespace App\Http\Controllers;

use App\Models\Reserva;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Destino;
use App\Models\Vuelo;

class ReservaController extends Controller
{
    public function index()
    {
        return Reserva::with(['usuario', 'destino'])->get();
    }

    public function confirmar($id)
    {
        $reserva = Reserva::findOrFail($id);

        if ($reserva->Estado !== 'confirmada') {
            $reserva->Estado = 'confirmada';
            $reserva->save();

            /** @var \\App\\Models\\Usuario $usuario */
            $usuario = Usuario::findOrFail($reserva->ID_usuario);

            $puntosGanados = floor($reserva->total / 150); // 1 punto cada 150 €
            $usuario->puntos += $puntosGanados;
            $usuario->save();

            return response()->json([
                'mensaje' => "Reserva confirmada. Has ganado $puntosGanados puntos."
            ]);
        }

        return response()->json(['mensaje' => 'La reserva ya estaba confirmada.'], 200);
    }

    // public function store(Request $request)
    // {
    //     //return Reserva::create($request->all());

    //     $request->validate([
    //         'ID_usuario' => 'required|exists:usuarios,ID_usuario',
    //         'ID_destino' => 'required|exists:destinos,ID_destino',
    //     ]);

    //     try {
    //         $usuario = Usuario::findOrFail($request->ID_usuario);
    //         $destino = Destino::findOrFail($request->ID_destino);

    //         $puntosUsar = intval($request->puntos_usados ?? 0);
    //         $descuento = min($puntosUsar, $usuario->puntos);
    //         $precioBase = floatval($request->total ?? $destino->Precio);
    //         $precioFinal = max(0, $precioBase - $descuento);

    //         $reserva = new Reserva();
    //         $reserva->ID_usuario = $request->ID_usuario;
    //         $reserva->ID_destino = $request->ID_destino;
    //         $reserva->ID_vuelo = $request->ID_vuelo; // si se seleccionó vuelo
    //         $reserva->fecha_inicio = $request->fecha_inicio;
    //         $reserva->fecha_fin = $request->fecha_fin;
    //         $reserva->adultos = $request->adultos;
    //         $reserva->ninos = $request->ninos;
    //         $reserva->habitaciones = $request->habitaciones;
    //         $reserva->total = $request->total;
    //         $reserva->puntos_usados = $descuento;

    //         $usuario->puntos -= $descuento;
    //         $puntosGanados = floor($precioFinal / 150);
    //         $usuario->puntos += $puntosGanados;

    //         $reserva->save();
    //         $usuario->save();

    //         return response()->json(['message' => 'Reserva realizada con éxito'], 201);
    //     } catch (\Exception $e) {
    //         return response()->json(['error' => 'Error al guardar la reserva'], 500);
    //     }
    // }

    public function store(Request $request)
    {
        $request->validate([
            'ID_usuario' => 'required|exists:usuarios,ID_usuario',
            'ID_destino' => 'required|exists:destinos,ID_destino',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'adultos' => 'required|integer|min:0',
            'ninos' => 'required|integer|min:0',
            'habitaciones' => 'required|integer|min:1',
            'puntos_usados' => 'nullable|integer|min:0',
            'Estado' => 'nullable|string',
            'ID_vuelo' => 'nullable|integer',
            'Asistencia_movilidad' => 'nullable|boolean',
            'Comentario_accesibilidad' => 'nullable|string|max:1000',
            'Tipo_asistencia' => 'nullable|string|max:1000',
            'Nombre_hotel' => 'nullable|string|max:255',
        ]);

        try {
            $usuario = Usuario::findOrFail($request->ID_usuario);
            $destino = Destino::findOrFail($request->ID_destino);

            // Cálculo de noches
            $inicio = new \DateTime($request->fecha_inicio);
            $fin = new \DateTime($request->fecha_fin);
            $noches = $inicio->diff($fin)->days;

            if ($noches <= 0) {
                return response()->json(['error' => 'Fechas no válidas'], 400);
            }

            $totalPersonas = $request->adultos + $request->ninos;

            // Precio base por hotel
            $precioHotel = $noches * $totalPersonas * $destino->Precio;

            // Precio vuelo si hay
            $precioVuelo = 0;
            if (!empty($request->ID_vuelo)) {
                $vuelo = Vuelo::find($request->ID_vuelo);
                if ($vuelo) {
                    $precioVuelo = $totalPersonas * $vuelo->Precio_vuelo;
                }
            }

            $precioBase = $precioHotel + $precioVuelo;

            // Aplicar puntos
            $puntosUsar = intval($request->puntos_usados ?? 0);
            $descuento = min($puntosUsar, $usuario->puntos);
            $precioFinal = max(0, $precioBase - $descuento);

            // Guardar reserva
            $reserva = new Reserva();
            $reserva->ID_usuario = $usuario->ID_usuario;
            $reserva->ID_destino = $destino->ID_destino;
            $reserva->ID_vuelo = $request->ID_vuelo ?? null;
            $reserva->Estado = $request->Estado ?? 'pendiente';
            $reserva->fecha_inicio = $request->fecha_inicio;
            $reserva->fecha_fin = $request->fecha_fin;
            $reserva->adultos = $request->adultos;
            $reserva->ninos = $request->ninos;
            $reserva->habitaciones = $request->habitaciones;
            $reserva->total = $precioFinal;
            $reserva->puntos_usados = $descuento;
            $reserva->Asistencia_movilidad = $request->Asistencia_movilidad ?? false;
            $reserva->Comentario_accesibilidad = $request->Comentario_accesibilidad ?? null;
            $reserva->Tipo_asistencia = $request->Tipo_asistencia ?? null;
            $reserva->Nombre_hotel = $request->Nombre_hotel ?? null;

            $reserva->save();

            // Actualizar puntos del usuario
            $usuario->puntos -= $descuento;
            $puntosGanados = floor($precioFinal / 150);
            $usuario->puntos += $puntosGanados;
            $usuario->save();

            return response()->json([
                'message' => 'Reserva realizada con éxito',
                'precio_final' => $precioFinal,
                'puntos_ganados' => $puntosGanados
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al guardar la reserva',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        return Reserva::with(['usuario', 'destino'])->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $reserva = Reserva::findOrFail($id);
        $reserva->update($request->all());
        return $reserva;
    }

    public function destroy($id)
    {
        return Reserva::destroy($id);
    }

    public function misReservas($id)
    {
        return \App\Models\Reserva::with('destino')
            ->where('ID_usuario', $id)
            ->get();
    }
}
