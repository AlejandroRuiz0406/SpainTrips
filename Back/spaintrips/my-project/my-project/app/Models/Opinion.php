<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Opinion extends Model
{
    protected $table = 'opiniones';
    protected $primaryKey = 'ID_opinion';
    public $timestamps = false;

    protected $fillable = [
        'ID_usuario',
        'Puntuacion',
        'Comentario'
    ];

    public function usuario() {
        return $this->belongsTo(Usuario::class, 'ID_usuario');
    }

    public function destino() {
        return $this->belongsTo(Destino::class, 'ID_destino');
    }
}
