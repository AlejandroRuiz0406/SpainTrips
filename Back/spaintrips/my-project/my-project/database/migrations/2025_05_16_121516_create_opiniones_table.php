<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('opiniones', function (Blueprint $table) {
            $table->id('ID_opinion');
            $table->unsignedBigInteger('ID_usuario');
            $table->unsignedBigInteger('ID_destino');
            $table->tinyInteger('Valoracion')->unsigned();
            $table->text('Comentario');
            $table->timestamps();

            $table->foreign('ID_usuario')->references('ID_usuario')->on('usuarios')->onDelete('cascade');
            $table->foreign('ID_destino')->references('ID_destino')->on('destinos')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('opiniones');
    }
};

