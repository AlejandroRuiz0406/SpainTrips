<script setup>
import { ref } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

const form = ref({
    nombre: '',
    email: '',
    mensaje: ''
})

const mensajeExito = ref('')
const mensajeError = ref('')

const enviarFormulario = async () => {
    if (!form.value.nombre || !form.value.email || !form.value.mensaje) {
        Swal.fire({
            icon: 'warning',
            title: 'Campos incompletos',
            text: 'Por favor, completa todos los campos.',
        });
        return;
    }

    try {
        await axios.post('http://localhost:8000/api/contacto', form.value);
        Swal.fire({
            icon: 'success',
            title: 'Mensaje enviado',
            text: 'Tu mensaje ha sido enviado correctamente.',
        });
        form.value = { nombre: '', email: '', mensaje: '' };
    } catch (error) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Ocurrió un error al enviar tu mensaje.',
        });
        console.error(error);
    }
}

const abrirChat = () => {
    if (window.Tawk_API?.maximize) {
        window.Tawk_API.maximize();
    }
}

const toggleAccesibilidad = () => {
    document.body.classList.toggle('modo-accesible');
}
</script>

<template>
    <div class="container py-4">
        <h2 class="text-center mb-4">Contacto</h2>
        <div class="d-flex justify-content-end mb-3">
            <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                ♿ Accesibilidad visual
            </button>
        </div>

        <!-- Formulario de dudas -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title mb-3">Formulario de dudas</h5>
                <form @submit.prevent="enviarFormulario">
                    <div class="mb-3">
                        <label class="form-label">Nombre</label>
                        <input v-model="form.nombre" type="text" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Correo electrónico</label>
                        <input v-model="form.email" type="email" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mensaje</label>
                        <textarea v-model="form.mensaje" class="form-control" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn text-white" style="background-color: #D62828;">Enviar</button>
                </form>
                <div v-if="mensajeExito" class="alert alert-success mt-3">{{ mensajeExito }}</div>
                <div v-if="mensajeError" class="alert alert-danger mt-3">{{ mensajeError }}</div>
            </div>
        </div>

        <!-- Información de contacto alternativa -->
        <div class="row shadow-sm border p-4 bg-white rounded mt-4">
            <div class="col-md-6">
                <h5 class="mb-3">¿Necesitas ayuda?</h5>
                <p>
                    Puedes iniciar un chat directo con nuestro equipo.
                </p>
            </div>

            <div class="col-md-6 d-flex justify-content-center align-items-center">
                <button @click="abrirChat" class="btn text-dark fw-semibold btn-lg"
                    style="background-color: #F7B801; border-radius: 999px;">
                    💬 Chatear ahora
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Oculta completamente el botón flotante de Tawk.to */
iframe[title="chat_widget"] {
    display: none !important;
}

h2,
h5 {
    color: #0053A0;
    font-weight: 700;
}

.card,
.border {
    border-radius: 16px;
    transition: box-shadow 0.2s ease;
}

.card:hover,
.border:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.btn {
    font-weight: 600;
}
</style>