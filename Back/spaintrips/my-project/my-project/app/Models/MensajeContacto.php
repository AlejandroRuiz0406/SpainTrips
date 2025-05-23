<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MensajeContacto extends Model
{
    protected $table = 'mensajes_contacto';
    protected $primaryKey = 'ID_mensaje';
    public $timestamps = false;

    protected $fillable = [
        'nombre',
        'email',
        'mensaje'
    ];
}
