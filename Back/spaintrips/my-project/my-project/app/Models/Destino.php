<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Destino extends Model
{
    protected $table = 'destinos';
    protected $primaryKey = 'ID_destino';
    public $timestamps = false;

    protected $fillable = [
        'Nombre',
        'Ubicacion',
        'Precio',
        'Tipo_experiencia',
        'Accesibilidad',
        'Temporada'
    ];

    public function reservas()
    {
        return $this->hasMany(Reserva::class, 'ID_destino');
    }

    public function opiniones()
    {
        return $this->hasMany(Opinion::class, 'ID_destino');
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class, 'ID_usuario');
    }

    public function destino()
    {
        return $this->belongsTo(Destino::class, 'ID_destino');
    }

    public function favoritos() {
        return $this->hasMany(Favorito::class, 'ID_destino');
    }    
}
