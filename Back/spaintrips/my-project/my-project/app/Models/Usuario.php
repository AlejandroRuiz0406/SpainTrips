<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Usuario extends Authenticatable
{
    use HasApiTokens;

    protected $table = 'usuarios';
    protected $primaryKey = 'ID_usuario';
    public $timestamps = false;

    protected $fillable = [
        'Nombre',
        'Correo',
        'Contraseña',
        'Rol',
        'Puntos'
    ];

    public function reservas()
    {
        return $this->hasMany(Reserva::class, 'ID_usuario');
    }

    public function recompensas()
    {
        return $this->hasMany(Recompensa::class, 'ID_usuario');
    }

    public function opiniones()
    {
        return $this->hasMany(Opinion::class, 'ID_usuario');
    }

    public function favoritos()
    {
        return $this->hasMany(Favorito::class, 'ID_usuario');
    }
}
