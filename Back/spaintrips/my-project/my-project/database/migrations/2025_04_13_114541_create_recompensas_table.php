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
        Schema::create('recompensas', function (Blueprint $table) {
            $table->id('ID_recompensa');
            $table->string('Descripcion');
            $table->integer('Puntos_necesarios');
            $table->foreignId('ID_usuario')->constrained('usuarios', 'ID_usuario')->onDelete('cascade');
            //$table->unsignedBigInteger('ID_usuario');
            //$table->foreign('ID_usuario')->references('ID_usuario')->on('usuarios')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('recompensas');
    }
};
