<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('opinions', function (Blueprint $table) {
            $table->id('ID_opinion');
            $table->unsignedBigInteger('ID_usuario');
            $table->unsignedBigInteger('ID_destino');
            $table->text('Comentario');
            $table->tinyInteger('Puntuacion');
            $table->timestamps();

            $table->foreign('ID_usuario')->references('ID_usuario')->on('usuarios')->onDelete('cascade');
            $table->foreign('ID_destino')->references('ID_destino')->on('destinos')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('opinions');
    }
};
