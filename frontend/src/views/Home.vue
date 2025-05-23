<script>
import axios from 'axios';
import { ref } from 'vue'
import { usuario } from '../authBus'
import router from '../router'
import { mostrarExito, mostrarError } from '../sweetalert2'

export default {
    name: "Inicio",

    data() {
        return {
            destacados: [],
            mostrarModal: false,
            destinoSeleccionado: null,
            fechaEntrada: '',
            fechaSalida: '',
            adultos: 0,
            ninos: 0,
            habitaciones: 0,
            userId: localStorage.getItem("user_id"),
            mensajeReserva: '',
            tipoMensajeReserva: '',
            busqueda: '',
            fechaBusqueda: '',
            resultadosFiltrados: [],
            busquedaRealizada: false,
            filtroAccesible: false,
            asistenciaMovilidad: false,
            comentarioAccesibilidad: '',
            nombreHotel: '',
            favoritos: []
        }
    },
    mounted() {
        this.cargarDestacados();
        this.cargarFavoritos()
        this.resultadosFiltrados = [];
    },
    methods: {
        toggleAccesibilidad() {
            document.body.classList.toggle('modo-accesible');
        },
        async cargarDestacados() {
            try {
                const res = await axios.get('spaintrips-production.up.railway.app/api/destinos');
                this.destacados = res.data
                    .filter(d => d.Accesibilidad && ['si', 'sí'].includes(d.Accesibilidad.toLowerCase()))
                    .slice(0, 3);
                this.resultadosFiltrados = this.destacados;
            } catch (e) {
                console.error('Error al cargar destinos:', e);
            }
        },
        getImagenDestino(dest) {
            const nombre = dest.Nombre?.toLowerCase().replace(/\s+/g, '-') || 'generico'
            return `/img/${nombre}.jpg`
        },
        abrirModalReserva(destino) {
            if (!usuario.value) {
                router.push('/login')
                return
            }

            this.destinoSeleccionado = destino;
            this.fechaEntrada = '';
            this.fechaSalida = '';
            this.adultos = 0;
            this.ninos = 0;
            this.habitaciones = 0;
            this.mostrarModal = true;
        },

        cerrarModal() {
            this.mostrarModal = false;
            this.asistenciaMovilidad = false;
            this.comentarioAccesibilidad = '';
            this.nombreHotel = '';
        },

        totalNoches() {
            const entrada = new Date(this.fechaEntrada);
            const salida = new Date(this.fechaSalida);
            const diff = (salida - entrada) / (1000 * 60 * 60 * 24);
            return diff > 0 ? diff : 1;
        },

        totalPersonas() {
            return parseInt(this.adultos) + parseInt(this.ninos);
        },

        totalPrecio() {
            return (this.totalNoches() * this.totalPersonas() * this.destinoSeleccionado?.Precio || 0).toFixed(2);
        },
        async confirmarReserva() {
            if (
                !this.fechaEntrada ||
                !this.fechaSalida ||
                this.totalPersonas() <= 0 ||
                this.habitaciones <= 0
            ) {
                await mostrarError('Campos incompletos', 'Por favor, rellena todos los campos correctamente.');
                return;
            }

            const payload = {
                ID_usuario: this.userId,
                ID_destino: this.destinoSeleccionado.ID_destino,
                fecha_inicio: this.fechaEntrada,
                fecha_fin: this.fechaSalida,
                habitaciones: this.habitaciones,
                adultos: this.adultos,
                ninos: this.ninos,
                puntos_usados: 0,
                Estado: "pendiente",
                ID_vuelo: this.destinoSeleccionado.ID_vuelo || null,
                Asistencia_movilidad: this.asistenciaMovilidad,
                Comentario_accesibilidad: this.comentarioAccesibilidad,
                Tipo_asistencia: this.tipoAsistencia || "",
                Nombre_hotel: this.nombreHotel,
            };


            try {
                await axios.post("spaintrips-production.up.railway.app/api/reservas", payload);
                this.cerrarModal();
                await mostrarExito('Reserva realizada', 'Tu reserva fue registrada con éxito.');

                usuario.value.descuentoActivo = 0;
                localStorage.setItem('usuario', JSON.stringify(usuario.value));

                await this.refrescarUsuario()

                setTimeout(() => {
                    this.mensajeReserva = '';
                }, 3000);
            } catch (error) {
                console.error("Error al guardar reserva:", error);
                this.cerrarModal();
                await mostrarError('Error', 'Error al realizar la reserva.');

                setTimeout(() => {
                    this.mensajeReserva = '';
                }, 3000);
            }
        },
        async refrescarUsuario() {
            try {
                const res = await axios.get(`spaintrips-production.up.railway.app/api/usuarios/${usuario.value.ID_usuario}`);
                usuario.value = res.data;
                localStorage.setItem('usuario', JSON.stringify(usuario.value));
            } catch (e) {
                console.error("Error al actualizar los datos del usuario:", e);
            }
        },
        async buscarDestinos() {
            const texto = this.busqueda.trim().toLowerCase();

            if (!texto) {
                this.resultadosFiltrados = [];
                return;
            }

            try {
                const res = await axios.get('spaintrips-production.up.railway.app/api/destinos');
                this.resultadosFiltrados = res.data.filter(dest =>
                    dest.Nombre?.toLowerCase().includes(texto) &&
                    (!this.filtroAccesible || (dest.Accesibilidad && ['si', 'sí'].includes(dest.Accesibilidad.toLowerCase())))
                );
                this.busquedaRealizada = true;
            } catch (error) {
                console.error('Error al buscar destinos:', error);
                this.resultadosFiltrados = [];
            }
        },
        async cargarFavoritos() {
            if (!usuario.value) return
            try {
                const res = await axios.get(`spaintrips-production.up.railway.app/api/favoritos?usuario=${usuario.value.ID_usuario}`)
                this.favoritos = res.data.map(f => f.ID_destino)
            } catch (e) {
                console.error('Error al cargar favoritos:', e)
            }
        },
        esFavorito(destino) {
            return this.favoritos.includes(destino.ID_destino)
        },
        async toggleFavorito(destino) {
            if (!usuario.value) {
                await mostrarError('Debes iniciar sesión para guardar favoritos.')
                return
            }

            const idDestino = destino.ID_destino

            if (this.esFavorito(destino)) {
                try {
                    await axios.delete(`spaintrips-production.up.railway.app/api/favoritos/${idDestino}`, {
                        data: { ID_usuario: usuario.value.ID_usuario }
                    })
                    this.favoritos = this.favoritos.filter(id => id !== idDestino)
                } catch (e) {
                    console.error('Error al quitar de favoritos:', e)
                }
            } else {
                try {
                    await axios.post(`spaintrips-production.up.railway.app/api/favoritos`, {
                        ID_usuario: usuario.value.ID_usuario,
                        ID_destino: idDestino
                    })
                    this.favoritos.push(idDestino)
                } catch (e) {
                    console.error('Error al añadir a favoritos:', e)
                }
            }
        }
    },
    computed: {
        descuentoAplicado() {
            return usuario.value?.descuentoActivo ?? 0;
        },
        totalFinal() {
            const base = parseFloat(this.totalPrecio());
            return Math.max(0, base - this.descuentoAplicado);
        }
    }
};
</script>

<template>
    <div class="container py-5">
        <div class="d-flex justify-content-end mb-3">
            <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                ♿ Accesibilidad visual
            </button>
        </div>

        <section class="text-center py-5 mb-5" style="background-color: #0053A0; color: white;">
            <div class="container">
                <h1 class="display-4 fw-bold">Esto es <span style="color: #F7B801">SpainTrips</span></h1>
                <p class="lead mt-3">La mejor forma de encontrar tus viajes soñados</p>
            </div>
        </section>

        <section class="mb-5">
            <h2 class="text-center text-white mb-5">Viajes destacados</h2>
            <div v-if="mensajeReserva" :class="`alert alert-${tipoMensajeReserva} mt-4 text-center`">
                {{ mensajeReserva }}
            </div>
            <div class="row g-4">
                <div v-for="destino in destacados" :key="destino.ID_destino" class="col-md-4">
                    <div class="card h-100 shadow rounded-4 overflow-hidden border-0">
                        <img :src="getImagenDestino(destino)" class="card-img-top img-fluid" alt="Imagen del destino"
                            style="height: 200px; object-fit: cover;" />
                        <button class="btn btn-link p-0 position-absolute top-0 end-0 m-2"
                            @click.stop="toggleFavorito(destino)">
                            <i :class="esFavorito(destino) ? 'fas fa-heart' : 'far fa-heart'"
                                style="font-size: 2rem; color: red;"></i>
                        </button>
                        <div class="card-body p-4 text-center">
                            <h5 class="card-title fw-bold">{{ destino.Nombre }}</h5>
                            <p class="card-text text-muted mb-2">
                                <i class="bi bi-geo-alt-fill"></i> {{ destino.Ubicacion }}
                            </p>
                            <p class="card-text mb-2">
                                <strong>Hotel:</strong> {{ destino.hotel }}<br />
                                <strong>Precio:</strong> {{ destino.Precio }} €<br />
                                <strong>Tipo:</strong> {{ destino.Tipo_experiencia }}
                            </p>
                            <p v-if="destino.Accesibilidad && ['si', 'sí'].includes(destino.Accesibilidad.toLowerCase())"
                                class="text-success fw-semibold">
                                ♿ Accesible
                            </p>
                            <button class="btn text-white" style="background-color: #D62828;"
                                @click="abrirModalReserva(destino)">Reservar</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <h2 class="text-center text-white mb-4">Buscador de viajes</h2>
            <div class="card shadow-sm p-4">
                <form class="row g-3 align-items-end justify-content-center" @submit.prevent="buscarDestinos">
                    <div class="col-md-3">
                        <label for="inputDestino" class="form-label">Destino o ciudad</label>
                        <input v-model="busqueda" id="inputDestino" type="text" class="form-control"
                            placeholder="Ej: Valencia" />
                    </div>

                    <div class="col-md-3">
                        <label for="inputFecha" class="form-label">Fecha estimada</label>
                        <input v-model="fechaBusqueda" id="inputFecha" type="date" class="form-control" />
                    </div>

                    <div class="col-md-3">
                        <div class="form-check mt-4">
                            <input class="form-check-input" type="checkbox" id="filtroAccesible"
                                v-model="filtroAccesible" />
                            <label class="form-check-label" for="filtroAccesible">
                                ♿ Solo destinos accesibles
                            </label>
                        </div>
                    </div>

                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-warning fw-semibold text-dark rounded-pill">
                            Buscar
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <section v-if="busquedaRealizada && resultadosFiltrados.length > 0" class="mt-5">
            <div class="row g-4">
                <div v-for="destino in resultadosFiltrados" :key="destino.ID_destino" class="col-md-4">
                    <div class="card shadow-sm h-100">
                        <img :src="getImagenDestino(destino)" class="card-img-top" alt="Imagen del destino"
                            style="height: 180px; object-fit: cover;" />
                        <button class="btn btn-link p-0 position-absolute top-0 end-0 m-2"
                            @click.stop="toggleFavorito(destino)">
                            <i :class="esFavorito(destino) ? 'fas fa-heart' : 'far fa-heart'"
                                style="font-size: 2rem; color: red;"></i>
                        </button>
                        <div class="card-body text-center">
                            <h5 class="card-title">{{ destino.Nombre }}</h5>
                            <p class="card-text">
                                <strong>Ubicación:</strong> {{ destino.Ubicacion }}<br />
                                <strong>Hotel:</strong> {{ destino.hotel }}<br />
                                <strong>Precio:</strong> {{ destino.Precio }} €<br />
                                <strong>Tipo:</strong> {{ destino.Tipo_experiencia }}
                            </p>
                            <p v-if="destino.Accesibilidad && ['si', 'sí'].includes(destino.Accesibilidad.toLowerCase())"
                                class="text-success fw-semibold">
                                ♿ Accesible
                            </p>
                            <button class="btn btn-primary" @click="abrirModalReserva(destino)">Reservar</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <p v-else-if="busquedaRealizada && resultadosFiltrados.length === 0" class="text-center text-muted mt-4 bg-white">
            No se encontraron resultados para tu búsqueda.
        </p>

        <div v-if="mostrarModal" class="modal-backdrop">
            <div class="modal-reserva">
                <h5 class="mb-3">Confirmar reserva</h5>
                <p><strong>Destino:</strong> {{ destinoSeleccionado?.Nombre }}</p>
                <p><strong>Hotel:</strong> {{ destinoSeleccionado?.hotel }}</p>
                <p><strong>Ubicación:</strong> {{ destinoSeleccionado?.Ubicacion }}</p>
                <p><strong>Precio por noche:</strong> {{ destinoSeleccionado?.Precio }} €</p>

                <div class="mb-2">
                    <label class="form-label">Fecha entrada</label>
                    <input type="date" v-model="fechaEntrada" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Fecha salida</label>
                    <input type="date" v-model="fechaSalida" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Adultos</label>
                    <input type="number" v-model="adultos" min="0" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Niños</label>
                    <input type="number" v-model="ninos" min="0" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Habitaciones</label>
                    <input type="number" v-model="habitaciones" min="1" class="form-control" />
                </div>

                <div class="mb-2 d-flex align-items-center justify-content-between">
                    <label class="form-label mb-0">Necesito asistencia por movilidad reducida ♿</label>
                    <input type="checkbox" v-model="asistenciaMovilidad" style="width: 18px; height: 18px;" />
                </div>

                <div class="mb-2">
                    <label for="comentarioAccesibilidad">¿Alguna necesidad especial?</label>
                    <textarea id="comentarioAccesibilidad" v-model="comentarioAccesibilidad" class="form-control"
                        rows="3" :disabled="!asistenciaMovilidad"
                        placeholder="Por ejemplo: ascensor, rampa, cama baja..."></textarea>
                </div>

                <p><strong>Noches:</strong> {{ totalNoches() }} noche(s)</p>
                <p><strong>Total:</strong> {{ totalPrecio() }} €</p>
                <p><strong>Total con descuento:</strong> {{ totalFinal.toFixed(2) }} €</p>

                <p v-if="descuentoAplicado > 0" class="text-success small">
                    Descuento aplicado por puntos: -{{ descuentoAplicado }} €
                </p>

                <p class="text-muted small">
                    {{ totalNoches() }} noche(s) × {{ totalPersonas() }} persona(s) × {{ destinoSeleccionado?.Precio }}
                    €
                    por persona/noche
                </p>

                <div class="d-flex justify-content-end gap-2 mt-3">
                    <button @click="confirmarReserva" class="btn btn-confirmar">Confirmar</button>
                    <button @click="cerrarModal" class="btn btn-cancelar">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
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

.card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
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

.btn {
    border-radius: 999px;
}

:global(.modo-accesible) {
    background-color: #000 !important;
    color: #fff !important;
    font-size: 1.1em;
}

:global(.modo-accesible .card),
:global(.modo-accesible .navbar),
:global(.modo-accesible .btn),
:global(.modo-accesible input),
:global(.modo-accesible select),
:global(.modo-accesible textarea),
:global(.modo-accesible label) {
    background-color: #111 !important;
    color: #fff !important;
    border-color: #fff !important;
}

:global(.modo-accesible img) {
    filter: brightness(0.9) contrast(1.1);
}

:global(.modo-accesible .btn-primary),
:global(.modo-accesible .btn-secondary),
:global(.modo-accesible .btn-outline-dark) {
    background-color: #222 !important;
    color: #fff !important;
    border-color: #fff !important;
}

@media (max-width: 768px) {

    form .col-md-3,
    form .col-md-2 {
        width: 100%;
    }
}
</style>