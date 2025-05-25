<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'

const nombre = ref('')
const correo = ref('')
const contrasena = ref('')
const confirmar = ref('')
const error = ref('')
const exito = ref('')
const router = useRouter()

const registrar = async () => {
    error.value = ''
    exito.value = ''

    if (contrasena.value !== confirmar.value) {
        error.value = 'Las contraseñas no coinciden'
        return
    }

    try {
        const response = await axios.post('http://localhost:8000/api/register', {
            Nombre: nombre.value,
            Correo: correo.value,
            Contraseña: contrasena.value,
            Contraseña_confirmation: confirmar.value
        })

        setTimeout(() => router.push('/login'), 2000)
        exito.value = '¡Bienvenido a SpainTrips!'
    } catch (err) {
        if (err.response && err.response.data) {
            error.value = Object.values(err.response.data).join(' ')
        } else {
            error.value = 'Error al registrar usuario.'
        }
    }
}
</script>

<template>
    <div class="container mt-5">
        <div class="card shadow-sm p-4 mx-auto" style="max-width: 600px; border-radius: 16px;">
            <h1 class="mb-3" style="color: #0053A0; font-weight: 700;">Registro</h1>
            <p>Crea tu cuenta para disfrutar de todos los beneficios.</p>

            <div v-if="error" class="alert alert-danger">{{ error }}</div>
            <div v-if="exito" class="alert alert-success">{{ exito }}</div>

            <form @submit.prevent="registrar">
                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input v-model="nombre" type="text" id="nombre" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="correo" class="form-label">Correo</label>
                    <input v-model="correo" type="email" id="correo" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="contrasena" class="form-label">Contraseña</label>
                    <input v-model="contrasena" type="password" id="contrasena" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="confirmar" class="form-label">Confirmar contraseña</label>
                    <input v-model="confirmar" type="password" id="confirmar" class="form-control" required />
                </div>

                <button type="submit" class="btn text-white w-100" style="background-color: #D62828;">
                    Registrarse
                </button>
            </form>
        </div>
    </div>
</template>

<style>
.btn {
    border-radius: 999px;
    font-weight: 600;
}
</style>