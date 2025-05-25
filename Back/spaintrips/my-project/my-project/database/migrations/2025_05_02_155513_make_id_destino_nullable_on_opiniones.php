<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        // Schema::table('opiniones', function (Blueprint $table) {
        //     $table->unsignedBigInteger('ID_destino')->nullable()->change();
        // });
        if (Schema::getConnection()->getDriverName() === 'mysql') {
            DB::statement('ALTER TABLE opiniones MODIFY ID_destino INT NULL');
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::getConnection()->getDriverName() === 'mysql') {
            DB::statement('ALTER TABLE opiniones MODIFY ID_destino INT NOT NULL');
        }
    }
};
