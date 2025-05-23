<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UsuarioController extends Controller
{
    public function index()
    {
        return Usuario::all();
    }

    public function store(Request $request)
    {
        return Usuario::create($request->all());
    }

    public function show($id)
    {
        return Usuario::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $usuario = Usuario::findOrFail($id);

        $data = $request->all();

        if (!empty($data['password'])) {
            $data['Contraseña'] = Hash::make($data['password']);
            unset($data['password']);
        }        

        $usuario->update($data);
        return $usuario;
    }

    public function destroy($id)
    {
        return Usuario::destroy($id);
    }

    public function opinionesDeUsuario($id)
    {
        $usuario = Usuario::with('opiniones')->find($id);

        if (!$usuario) {
            return response()->json(['error' => 'Usuario no encontrado'], 404);
        }

        return response()->json($usuario->opiniones);
    }

    public function recompensasDeUsuario($id)
    {
        $usuario = Usuario::with('recompensas')->find($id);

        if (!$usuario) {
            return response()->json(['error' => 'Usuario no encontrado'], 404);
        }

        return response()->json($usuario->recompensas);
    }

    public function reservasDeUsuario($id)
    {
        $usuario = Usuario::with('reservas')->find($id);

        if (!$usuario) {
            return response()->json(['error' => 'Usuario no encontrado'], 404);
        }

        return response()->json($usuario->reservas);
    }

    public function perfil(Request $request)
    {
        return response()->json($request->user());
    }
}
