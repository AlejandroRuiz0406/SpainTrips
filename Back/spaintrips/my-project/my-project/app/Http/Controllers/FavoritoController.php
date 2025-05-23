<?php

namespace App\Http\Controllers;

use App\Models\Favorito;
use Illuminate\Http\Request;

class FavoritoController extends Controller
{
    // public function index($id)
    // {
    //     return Favorito::where('ID_usuario', $id)
    //         ->with('destino')
    //         ->get();
    // }

    public function index(Request $request)
    {
        $userId = $request->query('usuario');

        //return Favorito::where('ID_usuario', $userId)->get();
        return Favorito::where('ID_usuario', $userId)
            ->with('destino') // <- incluye los datos del destino
            ->get();
    }

    public function store(Request $request)
    {
        $favorito = new Favorito();
        $favorito->id = $request->input('id');
        $favorito->ID_usuario = $request->input('ID_usuario');
        $favorito->ID_destino = $request->input('ID_destino');
        $favorito->save();

        return response()->json(['mensaje' => 'Añadido a favoritos'], 201);
    }

    public function destroy(Request $request, $id)
    {
        $idUsuario = $request->input('ID_usuario');

        Favorito::where('ID_destino', $id)
            ->where('ID_usuario', $idUsuario)
            ->delete();

        return response()->json(['mensaje' => 'Eliminado de favoritos']);
    }

    // public function destroy($id)
    // {
    //     Favorito::destroy($id);
    //     return response()->json(['message' => 'Favorito eliminado']);
    // }
}
