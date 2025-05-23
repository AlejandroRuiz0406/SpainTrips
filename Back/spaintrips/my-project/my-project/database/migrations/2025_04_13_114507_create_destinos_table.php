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
        Schema::create('destinos', function (Blueprint $table) {
            $table->id('ID_destino');
            $table->string('Nombre', 100);
            $table->string('Ubicacion', 150)->unique();
            $table->decimal('Precio', 8, 2);
            $table->string('Tipo_experiencia', 50);
            $table->string('Accesibilidad', 50);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('destinos');
    }
};
