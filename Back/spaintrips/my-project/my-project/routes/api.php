<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UsuarioController;
use App\Http\Controllers\DestinoController;
use App\Http\Controllers\ReservaController;
use App\Http\Controllers\RecompensaController;
use App\Http\Controllers\OpinionController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\VueloController;
use App\Http\Controllers\MensajeContactoController;
use App\Http\Controllers\FavoritoController;

Route::apiResource('usuarios', UsuarioController::class);
Route::apiResource('destinos', DestinoController::class);
Route::apiResource('reservas', ReservaController::class);
Route::apiResource('recompensas', RecompensaController::class);
Route::apiResource('opiniones', OpinionController::class);

Route::get('/usuarios/{id}/opiniones', [App\Http\Controllers\UsuarioController::class, 'opinionesDeUsuario']);
Route::get('/usuarios/{id}/recompensas', [App\Http\Controllers\UsuarioController::class, 'recompensasDeUsuario']);
Route::get('/destinos/{id}/opiniones', [App\Http\Controllers\DestinoController::class, 'opinionesDeDestino']);
Route::get('/usuarios/{id}/reservas', [App\Http\Controllers\UsuarioController::class, 'reservasDeUsuario']);
Route::delete('/usuarios/{id}', [UsuarioController::class, 'destroy']);
Route::put('/recompensas/{id}/canjear', [App\Http\Controllers\RecompensaController::class, 'canjearRecompensa']);
Route::get('/opiniones', [OpinionController::class, 'index']);
Route::get('/destinos/vuelohotel', [DestinoController::class, 'vueloHotel']);
Route::get('/vuelos/destino/{id}', [VueloController::class, 'porDestino']);
Route::get('/ofertas-especiales', [DestinoController::class, 'ofertasEspeciales']);
Route::get('/favoritos/{id}', [FavoritoController::class, 'index']);
Route::delete('/favoritos/{id}', [FavoritoController::class, 'destroy']);
Route::get('/mis-reservas/{id}', [ReservaController::class, 'misReservas']);
Route::get('/destinos/destacados', [DestinoController::class, 'destacados']);
Route::get('/reserva/confirmar/{id}', [ReservaController::class, 'confirmar']);
Route::get('/favoritos', [FavoritoController::class, 'index']);

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/opiniones', [OpinionController::class, 'store']);
Route::post('/reservas', [ReservaController::class, 'store']);
Route::post('/contacto', [MensajeContactoController::class, 'store']);
Route::post('/recompensas', [RecompensaController::class, 'store']);
Route::post('/favoritos', [FavoritoController::class, 'store']);

Route::get('/recompensas', [RecompensaController::class, 'index']);
Route::put('/recompensas/{id}/canjear', [RecompensaController::class, 'canjearRecompensa']);
Route::delete('/favoritos/{id}', [FavoritoController::class, 'destroy']);

Route::middleware('auth:sanctum', 'is_admin')->group(function () {
    Route::get('/admin/usuarios', [UsuarioController::class, 'index']);
});

Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

Route::middleware('auth:sanctum')->get('/perfil', [UsuarioController::class, 'perfil']);

