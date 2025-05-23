<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vuelo extends Model
{
    protected $table = 'vuelos';

    protected $primaryKey = 'ID_vuelo';

    protected $fillable = [
        'ID_destino',
        'Compania',
        'Numero_vuelo',
        'Origen',
        'Hora_salida',
        'Hora_llegada',
        'Precio_vuelo',
    ];

    public $timestamps = false;
}
