<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Favorito extends Model
{
    protected $table = 'favoritos';

    protected $primaryKey = 'ID_favorito';

    protected $fillable = ['ID_usuario', 'ID_destino'];

    public function destino()
    {
        return $this->belongsTo(Destino::class, 'ID_destino', 'ID_destino');
    }
}
