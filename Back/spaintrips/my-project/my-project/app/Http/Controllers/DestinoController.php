<?php

namespace App\Http\Controllers;

use App\Models\Destino;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;

class DestinoController extends Controller
{
    // public function index()
    // {
    //     return Destino::all();
    // }

    public function index(Request $request)
    {
        $query = Destino::query();

        if ($request->has('busqueda')) {
            $busqueda = strtolower($request->input('busqueda'));

            $query->where(function ($q) use ($busqueda) {
                $q->whereRaw('LOWER(Nombre) LIKE ?', ["%$busqueda%"])
                    ->orWhereRaw('LOWER(Ubicacion) LIKE ?', ["%$busqueda%"]);
            });
        }

        return response()->json($query->get());
    }

    public function store(Request $request)
    {
        return Destino::create($request->all());
    }

    public function show($id)
    {
        return Destino::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $destino = Destino::findOrFail($id);
        $destino->update($request->all());
        return $destino;
    }

    public function destroy($id)
    {
        return Destino::destroy($id);
    }

    public function opinionesDeDestino($id)
    {
        $destino = Destino::with('opiniones')->find($id);

        if (!$destino) {
            return response()->json(['error' => 'Destino no encontrado'], 404);
        }

        return response()->json($destino->opiniones);
    }

    public function vueloHotel()
    {
        return Destino::where('Tipo_experiencia', 'vuelo + hotel')->get();
    }

    public function ofertasEspeciales(Request $request)
    {
        $perfil = $request->query('perfil');
        $query = Destino::query();

        switch ($perfil) {
            case 'joven':
                $query->where('Precio', '<=', 220); // 215.50 pasa, 275 no
                break;
            case 'jubilado':
            case 'movilidad':
                $query->where('Accesibilidad', 'Sí');
                break;
            case 'puntos':
                $query->where('Precio', '<=', 200);
                break;
            default:
                return response()->json([], 200);
        }

        $resultados = $query->get()->map(function ($destino) {
            $destino->Precio = (float) $destino->Precio;
            return $destino;
        });

        return response()->json($resultados);
    }

    public function destacados()
    {
        return \App\Models\Destino::whereIn('Ubicacion', ['Valencia Cultura', 'Granada Aventura', 'Barcelona'])->get();
    }
}
