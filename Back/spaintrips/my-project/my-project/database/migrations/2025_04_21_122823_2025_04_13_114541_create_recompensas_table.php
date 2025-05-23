<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::table('recompensas', function (Blueprint $table) {
            $table->unsignedBigInteger('ID_usuario')->after('Puntos_necesarios');
            $table->foreign('ID_usuario')->references('ID_usuario')->on('usuarios')->onDelete('cascade');
        });
    }

    public function down(): void {
        Schema::table('recompensas', function (Blueprint $table) {
            $table->dropForeign(['ID_usuario']);
            $table->dropColumn('ID_usuario');
        });
    }
};

