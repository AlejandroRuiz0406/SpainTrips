<script>
import axios from 'axios'
import api from '../services/api'
import { ref, onMounted, computed } from 'vue'
import { usuario } from '../authBus'
import { mostrarExito, mostrarError } from '../sweetalert2'

export default {
    name: 'VueloHotel',
    setup() {
        const destinos = ref([])
        const errorMensaje = ref('')
        const exitoMensaje = ref('')
        const puntosUsar = ref(0)
        const asistenciaMovilidad = ref(false)
        const comentarioAccesibilidad = ref('')
        const tipoAsistencia = ref('')
        const hotel = ref('')
        const descuentoCanjeado = computed(() => usuario.value?.descuentoActivo || 0)
        //const usuario = ref(JSON.parse(localStorage.getItem('usuario') || '{}'))

        const getImagenDestino = (dest) => {
            const nombre = dest.Nombre?.toLowerCase().replace(/\s+/g, '-') || 'generico'
            return `/img/${nombre}.jpg`
        }

        const obtenerDestinos = async () => {
            try {
                const res = await api.get('/destinos')
                destinos.value = res.data.filter(d =>
                    d.Tipo_experiencia.toLowerCase() === 'vuelo + hotel'
                )
            } catch (e) {
                errorMensaje.value = 'Error al cargar destinos.'
            }
        }

        const reservar = async (idDestino) => {
            if (!usuario.value) {
                errorMensaje.value = 'Debes iniciar sesión para reservar.'
                return
            }

            try {
                await axios.post('http://localhost:8000/api/reservas', {
                    ID_usuario: usuario.value.ID_usuario,
                    ID_destino: idDestino,
                    puntos_usados: puntosUsar.value,
                })
                exitoMensaje.value = 'Reserva realizada. Precio final: ' + response.data.precio_final + ' €'
                errorMensaje.value = ''
            } catch (e) {
                errorMensaje.value = 'Error al realizar la reserva.'
                exitoMensaje.value = ''
            }
        }

        onMounted(() => {
            obtenerDestinos()
            cargarFavoritos()
        })

        // Computados según agrupación
        const destinosPorTemporada = computed(() =>
            destinos.value.filter(dest => dest.Seccion_destino === 'temporada')
        )

        const destinosPorExperiencia = computed(() =>
            destinos.value.filter(dest => dest.Seccion_destino === 'experiencia')
        )

        const destinoSeleccionado = ref(null)
        const mostrarModal = ref(false)

        const today = new Date()
        const tomorrow = new Date()
        tomorrow.setDate(today.getDate() + 1)

        const reservaFormulario = ref({
            fechaInicio: today.toISOString().slice(0, 10),
            fechaFin: tomorrow.toISOString().slice(0, 10),
            adultos: 0,
            ninos: 0,
            habitaciones: 0
        })

        const totalPersonas = computed(() =>
            parseInt(reservaFormulario.value.adultos) + parseInt(reservaFormulario.value.ninos)
        )

        const calcularNoches = computed(() => {
            const inicio = new Date(reservaFormulario.value.fechaInicio)
            const fin = new Date(reservaFormulario.value.fechaFin)

            if (isNaN(inicio.getTime()) || isNaN(fin.getTime()) || fin <= inicio) return 0

            const diff = fin.getTime() - inicio.getTime()
            return Math.ceil(diff / (1000 * 60 * 60 * 24))
        })

        const vuelos = ref([])
        const vueloSeleccionado = ref(null)

        const totalReserva = computed(() => {
            const noches = calcularNoches.value
            const personas = totalPersonas.value

            const precioHotelPorPersona = parseFloat(destinoSeleccionado.value?.Precio) || 0
            const precioVueloPorPersona = vueloSeleccionado.value ? parseFloat(vueloSeleccionado.value.Precio_vuelo) : 0

            const totalHotel = noches * personas * precioHotelPorPersona
            const totalVuelo = vueloSeleccionado.value ? personas * precioVueloPorPersona : 0

            return totalHotel + totalVuelo
        })

        const cargarVuelos = async (idDestino) => {
            try {
                const res = await axios.get(`http://localhost:8000/api/vuelos/destino/${idDestino}`)
                if (Array.isArray(res.data)) {
                    vuelos.value = res.data
                    vueloSeleccionado.value = res.data[0] || null
                } else {
                    vuelos.value = []
                    vueloSeleccionado.value = null
                }
            } catch (e) {
                vuelos.value = []
                vueloSeleccionado.value = null
            }
        }

        const abrirModalReserva = async (dest) => {
            destinoSeleccionado.value = dest
            mostrarModal.value = true

            try {
                const res = await axios.get(`http://localhost:8000/api/vuelos/destino/${dest.ID_destino}`)
                vuelos.value = res.data
            } catch {
                vuelos.value = []
            }
        }

        const cerrarModal = () => {
            mostrarModal.value = false
            destinoSeleccionado.value = null
            resetFormularioReserva()
        }

        const toggleAccesibilidad = () => {
            document.body.classList.toggle('modo-accesible');
        }

        // const confirmarReserva = async () => {
        //     if (!usuario.value || !destinoSeleccionado.value) return

        //     try {
        //         await axios.post('http://localhost:8000/api/reservas', {
        //             ID_usuario: usuario.value.ID_usuario,
        //             ID_destino: destinoSeleccionado.value.ID_destino,
        //             ID_vuelo: vueloSeleccionado.value?.ID_vuelo ?? null,
        //             adultos: reservaFormulario.value.adultos,
        //             ninos: reservaFormulario.value.ninos,
        //             habitaciones: reservaFormulario.value.habitaciones,
        //             fecha_inicio: reservaFormulario.value.fechaInicio,
        //             fecha_fin: reservaFormulario.value.fechaFin,
        //             //total: totalReserva.value,
        //             puntos_usados: puntosUsar.value,
        //             Asistencia_movilidad: asistenciaMovilidad.value,
        //             Comentario_accesibilidad: comentarioAccesibilidad.value,
        //             Tipo_asistencia: asistenciaMovilidad.value,
        //         })

        //         //const puntosGanados = Math.floor(totalReserva.value / 150)
        //         // usuario.value.puntos = usuario.value.puntos - puntosUsar.value + puntosGanados
        //         // localStorage.setItem('usuario', JSON.stringify(usuario.value))
        //         usuario.value.descuentoActivo = 0;
        //         localStorage.setItem('usuario', JSON.stringify(usuario.value));

        //         await refrescarUsuario()

        //         exitoMensaje.value = '¡Reserva confirmada con éxito!'
        //         errorMensaje.value = ''
        //     } catch (e) {
        //         errorMensaje.value = 'Error al realizar la reserva.'
        //         exitoMensaje.value = ''
        //     } finally {
        //         cerrarModal()
        //     }
        // }

        const confirmarReserva = async () => {
            if (!usuario.value || !destinoSeleccionado.value) return;

            try {
                const payload = {
                    ID_usuario: usuario.value.ID_usuario,
                    ID_destino: destinoSeleccionado.value.ID_destino,
                    ID_vuelo: vueloSeleccionado.value?.ID_vuelo ?? null,
                     Estado: 'confirmada',
                    adultos: reservaFormulario.value.adultos,
                    ninos: reservaFormulario.value.ninos,
                    habitaciones: reservaFormulario.value.habitaciones,
                    fecha_inicio: reservaFormulario.value.fechaInicio,
                    fecha_fin: reservaFormulario.value.fechaFin,
                    total: totalFinalReserva.value,
                    puntos_usados: puntosUsar.value,
                    Asistencia_movilidad: asistenciaMovilidad.value ? 1 : 0,
                    Comentario_accesibilidad: comentarioAccesibilidad.value || '',
                    Tipo_asistencia: tipoAsistencia.value || '',
                    Nombre_hotel: destinoSeleccionado.value?.hotel || ''
                };

                const resConfirmacion = await axios.post('http://localhost:8000/api/reservas', payload);

                cerrarModal();
                await mostrarExito('¡Reserva confirmada con éxito!', resConfirmacion.data.mensaje);

                usuario.value.descuentoActivo = 0;
                localStorage.setItem('usuario', JSON.stringify(usuario.value));

                await refrescarUsuario();
            } catch (e) {
                this.cerrarModal();
                await mostrarError('Error', 'No se pudo completar la reserva.');
            } finally {
                cerrarModal();
            }
        };

        const totalFinalReserva = computed(() => {
            const total = totalReserva.value - descuentoCanjeado.value;
            return total > 0 ? total : 0;
        });

        const refrescarUsuario = async () => {
            try {
                const res = await axios.get(`http://localhost:8000/api/usuarios/${usuario.value.ID_usuario}`);
                usuario.value = res.data;
                localStorage.setItem('usuario', JSON.stringify(usuario.value));
            } catch (e) {
                console.error("Error al actualizar los datos del usuario:", e);
            }
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
        }

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

        return {
            destinos,
            destinosPorTemporada,
            destinosPorExperiencia,
            reservar,
            errorMensaje,
            exitoMensaje,
            getImagenDestino,
            abrirModalReserva,
            cerrarModal,
            confirmarReserva,
            destinoSeleccionado,
            mostrarModal,
            totalReserva,
            reservaFormulario,
            cargarVuelos,
            vuelos,
            vueloSeleccionado,
            totalPersonas,
            puntosUsar,
            usuario,
            descuentoCanjeado,
            totalFinalReserva,
            asistenciaMovilidad,
            comentarioAccesibilidad,
            tipoAsistencia,
            toggleAccesibilidad,
            esFavorito,
            toggleFavorito
        }
    }
}
</script>

<template>
    <div class="container py-4">
        <h3 class="text-white mb-4">Vuelo + Hotel</h3>
        <div class="d-flex justify-content-end mb-3">
            <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                ♿ Accesibilidad visual
            </button>
        </div>

        <!-- Mensajes -->
        <div v-if="errorMensaje" class="alert alert-danger">{{ errorMensaje }}</div>
        <div v-if="exitoMensaje" class="alert alert-success">{{ exitoMensaje }}</div>

        <!-- VIAJES POR TEMPORADA -->
        <section class="mb-5">
            <h4 class="text-white mb-3">Viajes por temporada</h4>
            <div class="row">
                <div v-for="dest in destinosPorTemporada" :key="dest.ID_destino" class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100 shadow rounded-4 overflow-hidden border-0">
                        <img :src="getImagenDestino(dest)" class="card-img-top img-fluid" alt="Imagen del destino"
                            style="height: 200px; object-fit: cover;" />
                        <button class="btn btn-link p-0 position-absolute top-0 end-0 m-2"
                            @click.stop="toggleFavorito(dest)">
                            <i :class="esFavorito(dest) ? 'fas fa-heart' : 'far fa-heart'"
                                style="font-size: 2rem; color: red;"></i>
                        </button>
                        <div class="card-body p-4 text-center">
                            <h5 class="card-title fw-bold">{{ dest.Nombre }}</h5>
                            <p class="card-text text-muted mb-2">
                                <i class="bi bi-geo-alt-fill"></i> {{ dest.Ubicacion }}
                            </p>
                            <p class="card-text mb-2">
                                <strong>Hotel:</strong> {{ dest.hotel }}<br />
                                <strong>Precio:</strong> {{ dest.Precio }} €<br />
                                <strong>Tipo:</strong> {{ dest.Tipo_experiencia }}
                            </p>
                            <p v-if="dest.Accesibilidad && ['si', 'sí'].includes(dest.Accesibilidad.toLowerCase())"
                                class="text-success fw-semibold">
                                ♿ Accesible
                            </p>
                            <button class="btn text-white w-100 fw-semibold rounded-pill"
                                style="background-color: #D62828;" @click="abrirModalReserva(dest)">
                                Reservar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- VIAJES POR EXPERIENCIA -->
        <section>
            <h4 class="text-white mb-3">Viajes por experiencia</h4>
            <div class="row">
                <div v-for="dest in destinosPorExperiencia" :key="dest.ID_destino" class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100 shadow-sm border-0">
                        <!-- Imagen relacionada con el destino -->
                        <img :src="getImagenDestino(dest)" class="card-img-top" alt="Imagen del destino"
                            style="height: 180px; object-fit: cover;" />
                        <div class="card-body">
                            <h5 class="card-title">{{ dest.Nombre }}</h5>
                            <p><strong>Hotel:</strong> {{ dest.hotel }}</p>
                            <p class="card-text mb-1"><strong>Tipo:</strong> {{ dest.Tipo_experiencia }}</p>
                            <p class="card-text mb-1"><strong>Accesible:</strong> {{ dest.Accesible ? 'Sí' : 'No' }}</p>
                            <p class="card-text mb-1"><strong>Precio:</strong> {{ dest.Precio }} €</p>
                            <p>Tienes {{ usuario.puntos }} puntos disponibles.</p>

                            <label for="puntos_usar">¿Cuántos puntos deseas usar?</label>
                            <input id="puntos_usar" type="number" v-model="puntosUsar" :max="usuario.puntos"
                                class="form-control mb-3" placeholder="Introduce puntos" />
                            <button @click="abrirModalReserva(dest)" class="btn text-white w-100"
                                style="background-color: #D62828;">
                                Reservar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Modal reserva -->
        <div v-if="mostrarModal" class="modal-backdrop">
            <div class="modal-reserva">
                <h5 class="mb-3">Confirmar reserva</h5>

                <p><strong>Destino:</strong> {{ destinoSeleccionado?.Nombre }}</p>
                <p><strong>Hotel:</strong> {{ destinoSeleccionado?.hotel }}</p>
                <p><strong>Ubicación:</strong> {{ destinoSeleccionado?.Ubicacion }}</p>
                <p><strong>Precio por noche:</strong> {{ destinoSeleccionado?.Precio }} €</p>

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

                <div v-else class="text-danger small">
                    No hay vuelos disponibles para este destino.
                </div>

                <div class="mb-2 d-flex align-items-center justify-content-between">
                    <label class="form-label mb-0">Necesito asistencia por movilidad reducida ♿</label>
                    <input type="checkbox" v-model="asistenciaMovilidad" style="width: 18px; height: 18px;" />
                </div>

                <div v-if="asistenciaMovilidad" class="mb-2">
                    <label for="comentarioAccesibilidad" class="form-label">¿Qué tipo de asistencia necesitas?</label>
                    <select v-model="tipoAsistencia" class="form-select">
                        <option disabled value="">Selecciona una opción</option>
                        <option>Silla de ruedas en aeropuerto</option>
                        <option>Asistencia hasta la puerta de embarque</option>
                        <option>Asiento con espacio extra</option>
                        <option>Otro (especificar debajo)</option>
                    </select>
                </div>

                <div v-if="asistenciaMovilidad" class="mb-2">
                    <label for="comentarioAccesibilidad" class="form-label">Comentarios adicionales</label>
                    <textarea id="comentarioAccesibilidad" v-model="comentarioAccesibilidad" class="form-control"
                        rows="2" placeholder="Por ejemplo: silla de ruedas disponible a la llegada..."></textarea>
                </div>

                <p>
                    <strong>Noches:</strong>
                    <span v-if="calcularNoches > 0">
                        {{ calcularNoches }} noche<span v-if="calcularNoches > 1">s</span>
                    </span>
                    <span v-else class="text-danger">Selecciona fechas válidas</span>
                </p>

                <p><strong>Total:</strong> {{ totalFinalReserva.toFixed(2) }} €</p>

                <p v-if="descuentoCanjeado > 0" class="text-success small">
                    Descuento aplicado por puntos: -{{ descuentoCanjeado }} €
                </p>

                <p class="text-muted small">
                    {{ calcularNoches }} noche<span v-if="calcularNoches > 1">s</span> ×
                    {{ totalPersonas }} persona<span v-if="totalPersonas > 1">s</span> ×
                    {{ destinoSeleccionado?.Precio }} € por persona/noche
                </p>

                <p class="text-muted small" v-if="vueloSeleccionado">
                    + {{ totalPersonas }} persona<span v-if="totalPersonas > 1">s</span> ×
                    {{ vueloSeleccionado.Precio_vuelo }} € por vuelo
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
.card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.btn {
    border-radius: 999px;
    font-weight: 600;
}

.modal-backdrop {
    position: fixed;
    inset: 0;
    background-color: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    z-index: 1050;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem;
    overflow-y: auto;
}

.modal-reserva {
    background-color: #fff;
    border-radius: 16px;
    padding: 2rem;
    width: 100%;
    max-width: 520px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    animation: fadeIn 0.3s ease;
    position: relative;
    font-family: 'Poppins', sans-serif;
    max-height: 90vh;
    overflow-y: auto;
}

.modal-reserva h5 {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1rem;
}

.modal-reserva .close-btn {
    position: absolute;
    top: 1.2rem;
    right: 1.5rem;
    background: none;
    border: none;
    font-size: 1.3rem;
    cursor: pointer;
    color: #666;
}

.modal-reserva input,
.modal-reserva select {
    width: 100%;
    border-radius: 10px;
    border: 1px solid #ccc;
    padding: 0.6rem 0.8rem;
    margin-bottom: 0.9rem;
}

.modal-reserva .btn {
    border-radius: 20px;
    padding: 0.6rem 1.2rem;
    font-weight: 600;
    width: 48%;
}

.btn-confirmar {
    background-color: #D62828;
    color: white;
    border: none;
}

.btn-cancelar {
    background-color: #5a5a5a;
    color: white;
    border: none;
}

@keyframes fadeIn {
    from {
        transform: translateY(-10px);
        opacity: 0;
    }

    to {
        transform: translateY(0);
        opacity: 1;
    }
}
</style>