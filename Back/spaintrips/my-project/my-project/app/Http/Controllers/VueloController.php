<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Vuelo;

class VueloController extends Controller
{
    public function porDestino($id)
    {
        $vuelos = Vuelo::where('ID_destino', $id)->get();

        if ($vuelos->isEmpty()) {
            return response()->json(['message' => 'No hay vuelos disponibles para este destino.'], 404);
        }

        return response()->json($vuelos);
    }
}
