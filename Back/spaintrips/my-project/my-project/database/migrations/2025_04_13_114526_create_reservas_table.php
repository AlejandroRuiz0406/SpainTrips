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
        Schema::create('reservas', function (Blueprint $table) {
            $table->id('ID_reserva');
            $table->unsignedBigInteger('ID_usuario');
            $table->unsignedBigInteger('ID_destino');
            $table->dateTime('Fecha')->useCurrent();
            $table->string('Tipo_experiencia', 50);
            $table->string('Estado', 20)->default('pendiente');
            $table->integer('puntos_usados')->default(0);
            $table->boolean('Asistencia_movilidad')->default(false);
            $table->text('Comentario_accesibilidad')->nullable();
            $table->text('Tipo_asistencia')->nullable();
            $table->timestamps();

            $table->foreign('ID_usuario')->references('ID_usuario')->on('usuarios')->onDelete('cascade');
            //$table->unsignedBigInteger('ID_usuario');
            $table->foreign('ID_destino')->references('ID_destino')->on('destinos')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reservas');
    }
};
