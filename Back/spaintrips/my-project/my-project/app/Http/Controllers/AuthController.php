<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Usuario;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // Registro de usuario
    public function register(Request $request)
    {
        // Validación de los datos
        $validator = Validator::make($request->all(), [
            'Nombre' => 'required|string|max:255',
            'Correo' => 'required|string|email|max:255|unique:usuarios', // Verifica si el correo ya está registrado
            'Contraseña' => 'required|string|min:8|confirmed', // Confirmación de contraseña
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        // Crear el usuario
        $usuario = Usuario::create([
            'Nombre' => $request->Nombre,
            'Correo' => $request->Correo,
            'Contraseña' => Hash::make($request->Contraseña), // Encriptar la contraseña
        ]);

        return response()->json(['message' => 'Usuario registrado con éxito'], 201);
    }

    // Login de usuario
    public function login(Request $request)
    {
        // Validación del login
        $validator = Validator::make($request->all(), [
            'Correo' => 'required|string|email',
            'Contraseña' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        // Buscar al usuario con el correo
        $usuario = Usuario::where('Correo', $request->Correo)->first();

        if (!$usuario) {
            return response()->json(['error' => 'Correo no encontrado'], 404);
        }

        // Verificar la contraseña
        if (!Hash::check($request->Contraseña, $usuario->Contraseña)) {
            return response()->json(['error' => 'Contraseña incorrecta'], 401);
        }

        //return response()->json(['message' => 'Usuario autenticado con éxito']);

        //Generar token Sanctum
        $token = $usuario->createToken('spaintrips_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'usuario' => $usuario,
            'correo' => $usuario->Correo,
            'rol' => $usuario->rol
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Sesión cerrada con éxito']);
    }
}
