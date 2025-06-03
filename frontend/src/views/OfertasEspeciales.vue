<script setup>
import { reactive, ref, computed, onMounted } from 'vue'
import axios from 'axios';
import api from '../services/api'
import { usuario } from '../authBus'
import { mostrarExito, mostrarError } from '../sweetalert2'

const bloques = reactive([
    { titulo: 'Viajes para jóvenes', perfil: 'joven', ofertas: [], loading: true },
    { titulo: 'Viajes para jubilados', perfil: 'jubilado', ofertas: [], loading: true },
    { titulo: 'Viajes para personas con movilidad reducida', perfil: 'movilidad', ofertas: [], loading: true },
    { titulo: 'Descuentos con puntos acumulados', perfil: 'puntos', ofertas: [], loading: true }
])

const mostrarModal = ref(false)
const destinoSeleccionado = ref(null)
const vuelos = ref([])
const vueloSeleccionado = ref(null)
const errorMensaje = ref('')
const exitoMensaje = ref('')

const today = new Date()
const tomorrow = new Date()
tomorrow.setDate(today.getDate() + 1)

const descuentoAplicado = computed(() => {
    return usuario.value?.descuentoActivo ?? 0
})

const totalConDescuento = computed(() => {
    return Math.max(0, totalReserva.value - descuentoAplicado.value)
})

const reservaFormulario = ref({
    fechaInicio: today.toISOString().slice(0, 10),
    fechaFin: tomorrow.toISOString().slice(0, 10),
    adultos: 0,
    ninos: 0,
    habitaciones: 0
})

const asistenciaMovilidad = ref(false)
const comentarioAccesibilidad = ref('')

const toggleAccesibilidad = () => {
    document.body.classList.toggle('modo-accesible');
}

const getImagenDestino = (dest) => {
    const nombre = dest.Nombre?.toLowerCase().replace(/\s+/g, '-') || 'generico'
    return `/img/${nombre}.jpg`
}

onMounted(() => {
    bloques.forEach(async (bloque) => {
        try {
            const res = await axios.get(`http://localhost:8000/api/ofertas-especiales?perfil=${bloque.perfil}`)
            bloque.ofertas = res.data
        } catch (err) {
            console.error(`Error cargando ofertas para ${bloque.perfil}`, err)
        } finally {
            bloque.loading = false
        }
    })
    cargarFavoritos()
})

const abrirModalReserva = async (dest) => {
    destinoSeleccionado.value = dest
    mostrarModal.value = true
    try {
        const res = await axios.get(`http://localhost:8000/api/vuelos/destino/${dest.ID_destino}`)
        vuelos.value = Array.isArray(res.data) ? res.data : []
        vueloSeleccionado.value = vuelos.value[0] || null
    } catch {
        vuelos.value = []
        vueloSeleccionado.value = null
    }
}

const cerrarModal = () => {
    mostrarModal.value = false
    destinoSeleccionado.value = null
    resetFormularioReserva()
}

const resetFormularioReserva = () => {
    const today = new Date()
    const tomorrow = new Date()
    tomorrow.setDate(today.getDate() + 1)
    reservaFormulario.value = {
        fechaInicio: today.toISOString().slice(0, 10),
        fechaFin: tomorrow.toISOString().slice(0, 10),
        adultos: 0,
        ninos: 0,
        habitaciones: 0
    }
    vueloSeleccionado.value = null
    vuelos.value = []
    asistenciaMovilidad.value = false
    comentarioAccesibilidad.value = ''
}

const confirmarReserva = async () => {
    if (!usuario.value || !destinoSeleccionado.value) return
    try {
        await axios.post('/reservas', {
            ID_usuario: usuario.value.ID_usuario,
            ID_destino: destinoSeleccionado.value.ID_destino,
            ID_vuelo: vueloSeleccionado.value?.ID_vuelo ?? null,
            adultos: reservaFormulario.value.adultos,
            ninos: reservaFormulario.value.ninos,
            habitaciones: reservaFormulario.value.habitaciones,
            fecha_inicio: reservaFormulario.value.fechaInicio,
            fecha_fin: reservaFormulario.value.fechaFin,
            total: totalReserva.value,
            Asistencia_movilidad: asistenciaMovilidad.value,
            Comentario_accesibilidad: comentarioAccesibilidad.value,
            Nombre_hotel: destinoSeleccionado.value?.hotel || ''
        })
        cerrarModal();
        await mostrarExito('Reserva realizada', 'Tu reserva fue registrada con éxito.');

        usuario.value.descuentoActivo = 0
        localStorage.setItem('usuario', JSON.stringify(usuario.value))

        await refrescarUsuario()
    } catch {
        cerrarModal();
        await mostrarError('Error', 'Error al realizar la reserva.');
    } finally {
        cerrarModal()
    }
}

const refrescarUsuario = async () => {
    try {
        const res = await axios.get(`http://localhost:8000/api/usuarios/${usuario.value.ID_usuario}`);
        usuario.value = res.data;
        localStorage.setItem('usuario', JSON.stringify(usuario.value));
    } catch (e) {
        console.error("Error al actualizar los datos del usuario:", e);
    }
}

const totalPersonas = computed(() =>
    parseInt(reservaFormulario.value.adultos) + parseInt(reservaFormulario.value.ninos)
)

const calcularNoches = computed(() => {
    const inicio = new Date(reservaFormulario.value.fechaInicio)
    const fin = new Date(reservaFormulario.value.fechaFin)
    if (isNaN(inicio) || isNaN(fin) || fin <= inicio) return 0
    return Math.ceil((fin - inicio) / (1000 * 60 * 60 * 24))
})

const totalReserva = computed(() => {
    const noches = calcularNoches.value
    const personas = totalPersonas.value
    const precioHotel = parseFloat(destinoSeleccionado.value?.Precio) || 0
    const precioVuelo = vueloSeleccionado.value ? parseFloat(vueloSeleccionado.value.Precio_vuelo) : 0
    return (noches * personas * precioHotel) + (personas * precioVuelo)
})

const favoritos = ref([])

const cargarFavoritos = async () => {
    if (!usuario.value) return
    try {
        const res = await axios.get(`http://localhost:8000/api/favoritos?usuario=${usuario.value.ID_usuario}`)
        favoritos.value = res.data.map(f => f.ID_destino)
    } catch (e) {
        console.error('Error al cargar favoritos:', e)
    }
}

const esFavorito = (destino) => {
    return favoritos.value.includes(destino.ID_destino)
}

const toggleFavorito = async (destino) => {
    if (!usuario.value) {
        await mostrarError('Debes iniciar sesión para guardar favoritos.')
        return
    }

    const idDestino = destino.ID_destino

    if (esFavorito(destino)) {
        try {
            await axios.delete(`http://localhost:8000/api/favoritos/${idDestino}`, {
                data: { ID_usuario: usuario.value.ID_usuario }
            })
            favoritos.value = favoritos.value.filter(id => id !== idDestino)
        } catch (e) {
            console.error('Error al quitar de favoritos:', e)
        }
    } else {
        try {
            await axios.post(`http://localhost:8000/api/favoritos`, {
                ID_usuario: usuario.value.ID_usuario,
                ID_destino: idDestino
            })
            favoritos.value.push(idDestino)
        } catch (e) {
            console.error('Error al añadir a favoritos:', e)
        }
    }
}

const esOfertaEspecial = computed(() =>
  destinoSeleccionado.value?.Seccion_destino === 'experiencia'
)
</script>

<template>
    <div class="container py-4">
        <h2 class="text-center text-white mb-4">Ofertas Especiales</h2>

        <!-- Mensajes de reserva -->
        <div v-if="errorMensaje" class="alert alert-danger">{{ errorMensaje }}</div>
        <div v-if="exitoMensaje" class="alert alert-success">{{ exitoMensaje }}</div>

        <div v-for="bloque in bloques" :key="bloque.titulo" class="mb-5">
            <h4 class="text-white mb-3">{{ bloque.titulo }}</h4>

            <div v-if="bloque.loading" class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
            </div>

            <div v-if="!bloque.loading && bloque.ofertas.length === 0" class="alert alert-warning">
                No hay ofertas disponibles en esta categoría.
            </div>

            <div class="row">
                <div v-for="oferta in bloque.ofertas" :key="oferta.ID_destino" class="col-md-4 mb-3">
                    <div class="card h-100 shadow rounded-4 overflow-hidden border-0">
                        <img :src="getImagenDestino(oferta)" class="card-img-top img-fluid" alt="Imagen del destino"
                            style="height: 200px; object-fit: cover;" />
                        <button class="btn btn-link p-0 position-absolute top-0 end-0 m-2"
                            @click.stop="toggleFavorito(oferta)">
                            <i :class="esFavorito(oferta) ? 'fas fa-heart' : 'far fa-heart'"
                                style="font-size: 2rem; color: red;"></i>
                        </button>
                        <div class="card-body p-4 text-center">
                            <h5 class="card-title fw-bold">{{ oferta.Nombre }}</h5>
                            <p class="card-text text-muted mb-2">
                                <i class="bi bi-geo-alt-fill"></i> {{ oferta.Ubicacion }}
                            </p>
                            <p class="card-text mb-2">
                                <strong>Hotel:</strong> {{ oferta.hotel }}<br />
                                <strong>Precio:</strong>
                                <span class="text-muted text-decoration-line-through" v-if="bloque.perfil !== 'puntos'">
                                    {{ oferta.Precio }} €
                                </span>
                                <span class="fw-bold text-success">
                                    {{ (oferta.Precio * 0.8).toFixed(2) }} €<br />
                                </span>
                                <strong>Tipo:</strong> {{ oferta.Tipo_experiencia }}
                            </p>
                            <p v-if="oferta.Accesibilidad && ['si', 'sí'].includes(oferta.Accesibilidad.toLowerCase())"
                                class="text-success fw-semibold">
                                ♿ Accesible
                            </p>
                            <p v-else><br></p>
                            <button @click="abrirModalReserva(oferta)"
                                class="btn text-white w-100 fw-semibold rounded-pill"
                                style="background-color: #D62828;">
                                Reservar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL -->
        <div v-if="mostrarModal" class="modal-backdrop">
            <div class="modal-content-custom">
                <h5 class="mb-3">Confirmar reserva</h5>
                <p><strong>Destino:</strong> {{ destinoSeleccionado?.Nombre }}</p>
                <p><strong>Hotel:</strong> {{ destinoSeleccionado?.hotel }}</p>
                <p><strong>Ubicación:</strong> {{ destinoSeleccionado?.Ubicacion }}</p>
                <p>
                    <strong>Precio por noche:</strong>
                    <span v-if="esOfertaEspecial">
                        <s class="text-muted">{{ destinoSeleccionado?.Precio }} €</s>
                        <span class="text-success fw-bold ms-2">
                            {{ (destinoSeleccionado?.Precio * 0.8).toFixed(2) }} €
                        </span>
                    </span>
                    <span v-else>
                        {{ destinoSeleccionado?.Precio }} €
                    </span>
                </p>

                <div class="mb-2">
                    <label class="form-label">Fecha entrada</label>
                    <input type="date" v-model="reservaFormulario.fechaInicio" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Fecha salida</label>
                    <input type="date" v-model="reservaFormulario.fechaFin" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Adultos</label>
                    <input type="number" v-model="reservaFormulario.adultos" min="1" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Niños</label>
                    <input type="number" v-model="reservaFormulario.ninos" min="0" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Habitaciones</label>
                    <input type="number" v-model="reservaFormulario.habitaciones" min="1" class="form-control" />
                </div>

                <div class="mb-2 d-flex align-items-center justify-content-between">
                    <label for="asistenciaMovilidad" class="mb-0">
                        Necesito asistencia por movilidad reducida ♿
                    </label>
                    <input type="checkbox" id="asistenciaMovilidad" v-model="asistenciaMovilidad"
                        style="width: 18px; height: 18px;" />
                </div>

                <div class="mb-2">
                    <label for="comentarioAccesibilidad">¿Alguna necesidad especial?</label>
                    <textarea id="comentarioAccesibilidad" v-model="comentarioAccesibilidad" class="form-control"
                        rows="3" :disabled="!asistenciaMovilidad"
                        placeholder="Por ejemplo: ascensor, rampa, cama baja..."></textarea>
                </div>

                <div v-if="vuelos.length > 0" class="mb-3">
                    <label class="form-label"><strong>Selecciona vuelo</strong></label>
                    <select v-model="vueloSeleccionado" class="form-select">
                        <option disabled value="">-- Selecciona un vuelo --</option>
                        <option v-for="vuelo in vuelos" :key="vuelo.ID_vuelo" :value="vuelo">
                            {{ vuelo.Compania }} - {{ vuelo.Numero_vuelo }} ({{ vuelo.Hora_salida.slice(11, 16) }} → {{
                                vuelo.Hora_llegada.slice(11, 16) }}) - {{ vuelo.Precio_vuelo }} €
                        </option>
                    </select>
                </div>

                <div v-else class="text-muted small">
                    No se requiere vuelo para esta reserva.
                </div>

                <p><strong>Noches:</strong> {{ calcularNoches }}</p>
                <p><strong>Total:</strong> {{ totalReserva.toFixed(2) }} €</p>
                <p v-if="descuentoAplicado > 0" class="text-success small">
                    Descuento aplicado por puntos: -{{ descuentoAplicado }} €
                </p>

                <p class="text-muted small">
                    {{ calcularNoches }} noche<span v-if="calcularNoches > 1">s</span> ×
                    {{ totalPersonas }} persona<span v-if="totalPersonas > 1">s</span> ×
                    {{ destinoSeleccionado?.Precio }} € por persona/noche
                </p>

                <p v-if="vueloSeleccionado" class="text-muted small">
                    + {{ totalPersonas }} persona<span v-if="totalPersonas > 1">s</span> × {{
                        vueloSeleccionado.Precio_vuelo }} € por vuelo
                </p>

                <div class="d-flex justify-content-end gap-2 mt-3">
                    <button @click="confirmarReserva" class="btn text-white"
                        style="background-color: #D62828;">Confirmar</button>
                    <button @click="cerrarModal" class="btn text-dark fw-semibold"
                        style="background-color: #F7B801;">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
</template>


<style scoped>
.modal-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(5px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1050;
    padding: 2rem;
    overflow-y: auto;
}

.modal-content-custom {
    background: white;
    padding: 2.5rem;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    max-width: 500px;
    width: 100%;
    font-family: 'Poppins', sans-serif;
    animation: fadeIn 0.3s ease-in-out;
    max-height: 90vh;
    overflow-y: auto;
}

.modal-content-custom h2,
.modal-content-custom h3 {
    color: #C8102E;
    font-weight: bold;
    margin-bottom: 1rem;
}

.modal-content-custom label {
    font-weight: 500;
    margin-bottom: 0;
    color: #333;
}

.modal-content-custom input,
.modal-content-custom select {
    border-radius: 10px;
    padding: 8px 12px;
    border: 1px solid #ccc;
    width: 100%;
    margin-bottom: 12px;
}

.btn-confirmar {
    background-color: #C8102E;
    color: white;
    font-weight: 600;
    border: none;
    border-radius: 10px;
    padding: 10px 20px;
    transition: background-color 0.3s ease;
}

.btn-confirmar:hover {
    background-color: #a60d24;
}

.btn-cancelar {
    background-color: #FFD700;
    color: #000;
    font-weight: 600;
    border: none;
    border-radius: 10px;
    padding: 10px 20px;
    margin-left: 1rem;
    transition: background-color 0.3s ease;
}

.btn-cancelar:hover {
    background-color: #e6c200;
}


.total-box {
    background-color: #f9f9f9;
    padding: 1rem;
    border-radius: 12px;
    margin-top: 1.5rem;
    border: 1px solid #ddd;
}

@keyframes fadeIn {
    from {
        transform: scale(0.95);
        opacity: 0;
    }

    to {
        transform: scale(1);
        opacity: 1;
    }
}

.btn {
    border-radius: 999px;
    font-weight: 600;
}

@media (max-height: 600px) {
    .modal-content-custom {
        padding: 1.5rem;
        font-size: 0.9rem;
    }
}
</style>