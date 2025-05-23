<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Usuario;

class AuthTest extends TestCase
{
    use RefreshDatabase; // Limpia la base de datos entre tests

    /** @test */
    public function un_usuario_puede_registrarse()
    {
        $response = $this->postJson('/api/register', [
            'Nombre' => 'Juan Perez',
            'Correo' => 'juan@example.com',
            'Contraseña' => 'password123',
            'Contraseña_confirmation' => 'password123'
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('usuarios', [
            'Correo' => 'juan@example.com'
        ]);
    }

    /** @test */
    public function un_usuario_puede_loguearse_y_recibir_token()
    {
        // Crear usuario manualmente
        $usuario = Usuario::create([
            'Nombre' => 'Ana Garcia',
            'Correo' => 'ana@example.com',
            'Contraseña' => bcrypt('password123')
        ]);

        $response = $this->postJson('/api/login', [
            'Correo' => 'ana@example.com',
            'Contraseña' => 'password123'
        ]);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'access_token',
            'token_type',
            'usuario',
            'rol'
        ]);
    }
}
