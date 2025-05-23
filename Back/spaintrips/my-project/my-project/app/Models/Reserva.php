<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Reserva extends Model
{
    protected $table = 'reservas';
    protected $primaryKey = 'ID_reserva';
    public $timestamps = false;

    protected $fillable = [
        'ID_usuario',
        'ID_destino',
        'ID_vuelo',
        'fecha_inicio',
        'fecha_fin',
        'adultos',
        'ninos',
        'habitaciones',
        'total',
        'puntos_usados',
        'Estado',
        'Tipo_asistencia',
        'Asistencia_movilidad',
        'Comentario_accesibilidad',
        'Nombre_hotel'
    ];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'ID_usuario');
    }

    public function destino()
    {
        return $this->belongsTo(\App\Models\Destino::class, 'ID_destino', 'ID_destino');
    }
}
