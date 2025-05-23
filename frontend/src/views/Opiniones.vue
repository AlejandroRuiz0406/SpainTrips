<script>
import axios from 'axios'
import { ref, onMounted, computed } from 'vue'
import api from '../services/api'
import { usuario } from '../authBus'
import 'bootstrap-icons/font/bootstrap-icons.css'
import Swal from 'sweetalert2'

export default {
    name: 'Opiniones',
    setup() {
        const opiniones = ref([])
        const errorMensaje = ref('')

        const nuevaOpinion = ref({
            Comentario: '',
            Puntuacion: 0
        })

        const obtenerOpiniones = async () => {
            const res = await axios.get('http://localhost:8000/api/opiniones')
            console.log(res.data);
            opiniones.value = Array.isArray(res.data) ? res.data : []
        }

        const toggleAccesibilidad = () => {
            document.body.classList.toggle('modo-accesible');
        }

        //console.log('usuario:', usuario.value)
        const enviarOpinion = async () => {
            if (!usuario.value) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Inicia sesión',
                    text: 'Debes iniciar sesión para dejar tu opinión.',
                });
                return;
            }

            const payload = {
                ID_usuario: usuario.value.ID_usuario,
                Comentario: nuevaOpinion.value.Comentario,
                Puntuacion: nuevaOpinion.value.Puntuacion
            }

            try {
                await api.post('/opiniones', payload);

                Swal.fire({
                    icon: 'success',
                    title: 'Opinión enviada',
                    text: 'Gracias por tu comentario.',
                });

                nuevaOpinion.value = { Comentario: '', Puntuacion: 0 };
                obtenerOpiniones();
            } catch (e) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Error al enviar la opinión. Intenta más tarde.',
                });
                console.error(e);
            }
        }

        const opinionesUnicas = computed(() => {
            const vistas = new Set()
            return opiniones.value.filter(op => {
                const hash = op.ID_usuario + '-' + op.Comentario.trim()
                if (vistas.has(hash)) return false
                vistas.add(hash)
                return true
            })
        })

        onMounted(() => {
            obtenerOpiniones()
        })

        const setValoracion = (n) => {
            nuevaOpinion.value.Puntuacion = n
        }

        return { opiniones, opinionesUnicas, nuevaOpinion, enviarOpinion, setValoracion, errorMensaje, toggleAccesibilidad }
    }
}
</script>

<template>
    <div class="container py-4">
        <div class="container py-4">
            <div v-if="opiniones.length > 0">
                <h3 class="text-white mb-4">Opiniones de otros usuarios</h3>
                <div class="d-flex justify-content-end mb-3">
                    <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                        ♿ Accesibilidad visual
                    </button>
                </div>

                <div v-for="op in opiniones" :key="op.ID_opinion" class="card shadow-sm p-3 mb-3 border-0 rounded">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="mb-0" style="color: #0053A0;">
                            {{ op.usuario?.Nombre || 'Usuario desconocido' }}
                        </h5>
                        <div>
                            <span v-for="i in 5" :key="i"
                                :class="i <= op.Puntuacion ? 'text-warning' : 'text-secondary'">
                                <i :class="i <= op.Puntuacion ? 'bi-star-fill' : 'bi-star'"></i>
                            </span>
                        </div>
                    </div>
                    <p class="mb-0">{{ op.Comentario }}</p>
                </div>
            </div>

            <div v-else class="mt-4 text-center text-white text-muted">
                <p>No hay opiniones disponibles aún.</p>
            </div>
        </div>


        <!-- Formulario para enviar nueva opinión -->
        <div class="card mx-auto" style="max-width: 600px">
            <div class="card-header">Deja tu opinión sobre la agencia</div>
            <div class="card-body">
                <form @submit.prevent="enviarOpinion">
                    <div class="mb-3">
                        <label for="comentario" class="form-label">Comentario</label>
                        <textarea id="comentario" v-model="nuevaOpinion.Comentario" class="form-control" rows="3"
                            required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Valoración</label>
                        <div>
                            <span v-for="n in 5" :key="n" @click="setValoracion(n)"
                                style="cursor: pointer; font-size: 1.4rem;">
                                {{ n <= nuevaOpinion.Puntuacion ? '★' : '☆' }} </span>
                        </div>
                    </div>

                    <button type="submit" class="btn text-white" style="background-color: #D62828;">Enviar
                        opinión</button>
                </form>

                <div v-if="errorMensaje" class="alert alert-warning mt-3" style="font-size: 0.95rem;">
                    {{ errorMensaje }}
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.card {
    border-radius: 16px;
    transition: box-shadow 0.2s ease;
}

.card:hover {
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.btn {
    border-radius: 999px;
    font-weight: 600;
}
</style>