<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\MensajeContacto;

class MensajeContactoController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nombre' => 'required|string|max:100',
            'email' => 'required|email|max:150',
            'mensaje' => 'required|string'
        ]);

        MensajeContacto::create($validated);

        return response()->json(['mensaje' => 'Mensaje enviado correctamente.'], 201);
    }
}
