<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recompensa extends Model
{
    protected $table = 'recompensas';
    protected $primaryKey = 'ID_recompensa';
    public $timestamps = false;

    protected $fillable = [
        'Descuento_aplicado',
        'Puntos_necesarios',
        'ID_usuario'
    ];

    public function usuario() {
        return $this->belongsTo(Usuario::class, 'ID_usuario');
    }
}
