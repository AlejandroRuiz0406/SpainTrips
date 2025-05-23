<?php

namespace App\Http\Controllers;

use App\Models\Opinion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class OpinionController extends Controller
{
    // public function index()
    // {
    //     return Opinion::with(['usuario', 'destino'])->get();
    // }

    public function index()
    {
        try {
            $opiniones = Opinion::with('usuario')->latest()->get();
            return response()->json($opiniones);
        } catch (\Exception $e) {
            Log::error('🔥 Error al obtener opiniones: ' . $e->getMessage());
            return response()->json(['error' => 'Error al obtener opiniones'], 500);
        }
    }

    // public function store(Request $request) {
    //     return Opinion::create($request->all());
    // }

    public function store(Request $request)
    {
        try {
            // Validación de datos entrantes
            $validated = $request->validate([
                'ID_usuario' => 'required|integer|exists:usuarios,ID_usuario',
                'Comentario' => 'required|string|max:1000',
                'Puntuacion' => 'required|integer|min:1|max:5',
            ]);

            // Crear y guardar nueva opinión
            $opinion = new Opinion();
            $opinion->ID_usuario = $validated['ID_usuario'];
            $opinion->Comentario = $validated['Comentario'];
            $opinion->Puntuacion = $validated['Puntuacion'];
            $opinion->save();

            return response()->json(['message' => 'Opinión guardada con éxito'], 201);
        } catch (\Exception $e) {
            Log::error('🔥 Error al guardar la opinión: ' . $e->getMessage());
            return response()->json(['error' => 'Error interno del servidor.'], 500);
        }
    }

    public function show($id)
    {
        return Opinion::with(['usuario', 'destino'])->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $opinion = Opinion::findOrFail($id);
        $opinion->update($request->all());
        return $opinion;
    }

    public function destroy($id)
    {
        return Opinion::destroy($id);
    }
}
