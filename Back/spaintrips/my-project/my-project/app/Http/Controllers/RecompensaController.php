<?php

namespace App\Http\Controllers;

use App\Models\Recompensa;
use App\Models\Usuario;
use Illuminate\Http\Request;

class RecompensaController extends Controller
{
    public function index()
    {
        return Recompensa::all();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'ID_usuario' => 'required|integer|exists:usuarios,ID_usuario',
            'Puntos_necesarios' => 'required|integer|min:1',
            'Descuento_aplicado' => 'required|numeric|min:0'
        ]);

        $usuario = \App\Models\Usuario::find($data['ID_usuario']);

        if ($usuario->puntos < $data['Puntos_necesarios']) {
            return response()->json(['message' => 'No tienes puntos suficientes'], 400);
        }

        $usuario->puntos -= $data['Puntos_necesarios'];
        $usuario->save();

        $recompensa = \App\Models\Recompensa::create($data);

        return response()->json(['message' => 'Recompensa canjeada', 'recompensa' => $recompensa]);
    }


    public function show($id)
    {
        return Recompensa::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $recompensa = Recompensa::findOrFail($id);
        $recompensa->update($request->all());
        return $recompensa;
    }

    public function destroy($id)
    {
        return Recompensa::destroy($id);
    }

    public function canjearRecompensa($id)
    {
        $recompensa = Recompensa::find($id);

        if (!$recompensa) {
            return response()->json(['error' => 'Recompensa no encontrada'], 404);
        }

        $usuario = Usuario::find($recompensa->ID_usuario);

        if (!$usuario) {
            return response()->json(['error' => 'Usuario no encontrado'], 404);
        }

        if ($usuario->Puntos < $recompensa->Puntos_necesarios) {
            return response()->json(['error' => 'Puntos insuficientes'], 400);
        }

        // Restar los puntos al usuario
        $usuario->Puntos -= $recompensa->Puntos_necesarios;
        $usuario->save();

        // Marcar la recompensa como canjeada (opcional)
        $recompensa->Descuento_aplicado = true;
        $recompensa->save();

        //return response()->json(['message' => 'Recompensa canjeada con éxito', 'usuario' => $usuario, 'recompensa' => $recompensa]);
        return response()->json([
            'mensaje' => 'Recompensa canjeada con éxito',
            'puntos' => $usuario->Puntos
        ]);
    }
}
