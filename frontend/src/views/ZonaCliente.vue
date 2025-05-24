<script>
import axios from 'axios';
import { usuario } from '../authBus'

export default {
    name: "ZonaClienteModal",
    data() {
        return {
            usuario: {
                nombre: '', correo: '', nuevaContrasena: '',
            },
            catalogo: [
                { ID_recompensa: 1, Descuento_aplicado: 20, Puntos_necesarios: 10 },
                { ID_recompensa: 2, Descuento_aplicado: 100, Puntos_necesarios: 100 }
            ],
            modalAbierto: null,
            puntos: null,
            reservas: [],
            userId: localStorage.getItem('user_id'),
            mensajePerfil: '',
            tipoMensajePerfil: '',
            favoritos: [],
            mensajeFavoritos: '',
            recompensas: [],
            mensajeRecompensas: ''
        };
    },
    methods: {
        abrirModal(nombre) {
            this.modalAbierto = nombre;

            if (nombre === 'perfil') {
                this.obtenerPerfil();
            }

            if (nombre === 'puntos') {
                this.obtenerPuntos();
            } else if (nombre === 'reservas') {
                this.obtenerReservas();
            }

            if (nombre === 'favoritos') {
                this.cargarFavoritos();
            }

            if (nombre === 'puntos') {
                this.obtenerPuntos()
                this.obtenerCatalogo()
            }
        },
        cerrarModal() {
            this.modalAbierto = null;
        },
        cerrarSesion() {
            try {
                await api.post('/logout', {}, {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('token')}`
                    }
                })
            } catch (error) {
                console.warn('Error cerrando sesión (token puede haber expirado).')
            }

            localStorage.removeItem('usuario')
            localStorage.removeItem('token')
            usuario.value = null
            router.push('/')
        },
        async obtenerPuntos() {
            try {
                const userRes = await axios.get(`http://localhost:8000/api/usuarios/${this.userId}`);
                this.puntos = userRes.data.puntos || 0;

                const recompensasRes = await axios.get(`http://localhost:8000/api/usuarios/${this.userId}/recompensas`);
                this.recompensas = Array.isArray(recompensasRes.data) ? recompensasRes.data : [];
            } catch (error) {
                console.error("Error al obtener puntos o recompensas:", error);
                this.puntos = 0;
                this.recompensas = [];
            }
        },
        async obtenerReservas() {
            try {
                const res = await axios.get(`http://localhost:8000/api/mis-reservas/${this.userId}`);
                this.reservas = Array.isArray(res.data) ? res.data : [];
            } catch (error) {
                console.error("Error al obtener reservas:", error);
                this.reservas = [];
            }
        },
        async obtenerPerfil() {
            try {
                const res = await axios.get(`http://localhost:8000/api/usuarios/${this.userId}`);
                this.usuario.nombre = res.data.Nombre;
                this.usuario.correo = res.data.Correo;
            } catch (error) {
                console.error("Error al obtener perfil:", error);
            }
        },
        async actualizarPerfil() {
            try {
                const payload = {
                    Nombre: this.usuario.nombre,
                    Correo: this.usuario.correo
                };

                if (this.nuevaContrasena.trim() !== '') {
                    payload.password = this.nuevaContrasena;
                }

                await axios.put(`http://localhost:8000/api/usuarios/${this.userId}`, payload);
                this.mensajePerfil = "Perfil actualizado correctamente.";
                this.tipoMensajePerfil = "success";
                this.cerrarModal();
            } catch (error) {
                console.error("Error al actualizar perfil:", error);
                this.mensajePerfil = "Hubo un error al actualizar el perfil.";
                this.tipoMensajePerfil = "danger";
            } finally {
                setTimeout(() => {
                    this.mensajePerfil = '';
                }, 4000);
            }
        },
        async cargarFavoritos() {
            try {
                const res = await axios.get(`http://localhost:8000/api/favoritos?usuario=${this.userId}`);

                this.favoritos = Array.isArray(res.data) ? res.data : [];
            } catch (error) {
                console.error("Error al obtener favoritos:", error);
                this.favoritos = [];
                this.mensajeFavoritos = 'Error al cargar favoritos.';
            }
        },
        toggleAccesibilidad() {
            document.body.classList.toggle('modo-accesible');
        },
        eliminarFavorito(id) {
            axios.delete(`http://localhost:8000/api/favoritos/${id}`)
                .then(() => {
                    this.favoritos = this.favoritos.filter(f => f.ID_favorito !== id);
                })
                .catch(() => {
                    this.mensajeFavoritos = 'No se pudo eliminar el favorito.';
                });
        },
        async canjearRecompensa() {
            try {
                if (this.puntos < 300) {
                    alert("Necesitas al menos 300 puntos para canjear una recompensa.");
                    return;
                }

                const res = await axios.post('http://localhost:8000/api/recompensas', {
                    ID_usuario: this.userId,
                    Puntos_necesarios: 300,
                    Descuento_aplicado: 20
                });

                alert("¡Has canjeado una recompensa con éxito!");
                this.obtenerPuntos(); // refrescar puntos y recompensas
            } catch (error) {
                alert("Error al canjear la recompensa.");
                console.error(error);
            }
        },
        async obtenerCatalogo() {
            try {
                const res = await axios.get('http://localhost:8000/api/recompensas'); // devuelve solo recompensas sin usuario
                this.catalogo = Array.isArray(res.data) ? res.data : [];
            } catch (error) {
                console.error("Error al obtener catálogo:", error);
                this.catalogo = [];
            }
        },
        async canjearRecompensaDesdeCatalogo(id) {
            try {
                await axios.put(`http://localhost:8000/api/recompensas/${id}/canjear`);
                await this.obtenerPuntos();
                await this.obtenerCatalogo();
            } catch (error) {
                this.mensajeRecompensas = 'Error al canjear recompensa.';
                console.error(error);
            }
        },
        canjearVisualmente(recompensa) {
            if (this.puntos < recompensa.Puntos_necesarios) {
                this.mensajeRecompensas = 'No tienes puntos suficientes.';
                return;
            }

            // Restar puntos
            this.puntos -= recompensa.Puntos_necesarios;

            if (usuario.value) {
                usuario.value.puntos = this.puntos;
                usuario.value.descuentoActivo = recompensa.Descuento_aplicado;
                localStorage.setItem('usuario', JSON.stringify(usuario.value));
            }

            // Añadir al historial visualmente
            this.recompensas.push({
                ID_recompensa: Date.now(),
                Descripcion: recompensa.Descripcion || `Descuento de ${recompensa.Descuento_aplicado}€`,
                Descuento_aplicado: recompensa.Descuento_aplicado,
                Puntos_necesarios: recompensa.Puntos_necesarios
            });

            // Eliminar del catálogo
            this.catalogo = this.catalogo.filter(r => r.ID_recompensa !== recompensa.ID_recompensa);
        }
    }
}
</script>

<template>
    <div class="container mt-5">
        <h2 class="text-center mb-4">Zona Cliente</h2>
        <div class="d-flex justify-content-end mb-3">
            <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                ♿ Accesibilidad visual
            </button>
        </div>
        <div v-if="mensajePerfil" class="mb-4">
            <div :class="['alert', tipoMensajePerfil === 'success' ? 'alert-success' : 'alert-danger']" role="alert">
                {{ mensajePerfil }}
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-8">
                <div class="card h-100 text-center">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <h5 class="card-title">Ver y editar perfil</h5>
                        <button class="btn btn-primary mt-3" @click="abrirModal('perfil')">Acceder</button>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 text-center">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <h5 class="card-title">Favoritos</h5>
                        <button class="btn btn-primary mt-3" @click="abrirModal('favoritos')">Ver favoritos</button>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 text-center">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <h5 class="card-title">Canjear puntos</h5>
                        <button class="btn btn-success mt-3" @click="abrirModal('puntos')">Canjear</button>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 text-center">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <h5 class="card-title">Historial de reservas</h5>
                        <button class="btn btn-secondary mt-3" @click="abrirModal('reservas')">Ver historial</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-end mt-4">
            <button class="btn btn-danger" @click="cerrarSesion">Cerrar sesión</button>
        </div>

        <!-- MODAL PERFIL -->
        <div class="modal fade" :class="{ show: modalAbierto === 'perfil' }" tabindex="-1" style="display: block;"
            v-if="modalAbierto === 'perfil'">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Perfil del Usuario</h5>
                        <button type="button" class="btn-close" @click="cerrarModal"></button>
                    </div>
                    <div class="modal-body">
                        <form @submit.prevent="actualizarPerfil">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre</label>
                                <input type="text" id="nombre" v-model="usuario.nombre" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Correo</label>
                                <input type="email" id="email" v-model="usuario.correo" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="nuevaContrasena" class="form-label">Nueva contraseña</label>
                                <input type="password" id="nuevaContrasena" v-model="nuevaContrasena"
                                    class="form-control">
                            </div>
                            <button type="submit" class="btn btn-success">Guardar cambios</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL FAVORITOS -->
        <div class="modal fade" :class="{ show: modalAbierto === 'favoritos' }" tabindex="-1" style="display: block;"
            v-if="modalAbierto === 'favoritos'">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Mis destinos favoritos</h5>
                        <button type="button" class="btn-close" @click="cerrarModal"></button>
                    </div>

                    <div class="modal-body">
                        <div v-if="mensajeFavoritos" class="alert alert-info">
                            {{ mensajeFavoritos }}
                        </div>

                        <div v-if="favoritos.length === 0 && !mensajeFavoritos" class="text-center text-muted">
                            No tienes destinos marcados como favoritos.
                        </div>

                        <ul v-else class="list-group">
                            <li v-for="fav in favoritos" :key="fav.ID_favorito"
                                class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-0">
                                        <span v-if="fav.destino">{{ fav.destino.Nombre }}</span>
                                        <span v-else>Destino ID: {{ fav.ID_destino }}</span>
                                    </h6>
                                </div>
                                <button class="btn btn-sm btn-danger" @click="eliminarFavorito(fav.ID_favorito)">
                                    Quitar
                                </button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL PUNTOS -->
        <div class="modal fade" :class="{ show: modalAbierto === 'puntos' }" tabindex="-1" style="display: block;"
            v-if="modalAbierto === 'puntos'">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Canjear puntos</h5>
                        <button type="button" class="btn-close" @click="cerrarModal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="fw-bold">Tienes actualmente {{ puntos }} puntos.</p>

                        <!-- Historial de recompensas -->
                        <div v-if="recompensas.length">
                            <h6 class="mt-3">Historial de recompensas canjeadas:</h6>
                            <ul class="list-group">
                                <li v-for="r in recompensas" :key="r.ID_recompensa" class="list-group-item">
                                    Descuento de <strong>{{ r.Descuento_aplicado }}€</strong> - Canjeado por
                                    <strong>{{ r.Puntos_necesarios }}</strong> puntos
                                </li>
                            </ul>
                        </div>

                        <!-- Catálogo de recompensas disponibles (simulado) -->
                        <div v-if="catalogo.length" class="mt-4">
                            <h6>Catálogo de recompensas disponibles:</h6>
                            <ul class="list-group">
                                <li v-for="r in catalogo" :key="r.ID_recompensa"
                                    class="list-group-item d-flex justify-content-between align-items-center">
                                    <span>{{ r.Descripcion }} ({{ r.Puntos_necesarios }} puntos)</span>
                                    <button class="btn btn-sm btn-warning" :disabled="puntos < r.Puntos_necesarios"
                                        @click="canjearVisualmente(r)">
                                        Canjear
                                    </button>
                                </li>
                            </ul>
                        </div>

                        <div v-else class="text-muted text-center mt-3">
                            No hay recompensas disponibles en este momento.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL RESERVAS -->
        <div class="modal fade" :class="{ show: modalAbierto === 'reservas' }" tabindex="-1" style="display: block;"
            v-if="modalAbierto === 'reservas'">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Historial de reservas</h5>
                        <button type="button" class="btn-close" @click="cerrarModal"></button>
                    </div>
                    <div class="modal-body">
                        <ul class="list-group">
                            <li class="list-group-item" v-for="reserva in reservas" :key="reserva.ID_reserva">
                                Reserva en <strong>{{ reserva.destino?.Nombre || 'Destino desconocido' }}</strong>
                                - Estado: <span class="text-capitalize">{{ reserva.Estado }}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    font-family: 'Poppins', sans-serif;
}

h2 {
    font-weight: bold;
    color: #C8102E;
    text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.1);
}

.card {
    border-radius: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    transition: transform 0.3s ease;
}

.card:hover {
    transform: translateY(-5px);
}

.card-title {
    color: #C8102E;
    font-weight: 600;
}

.btn-primary {
    background-color: #C8102E;
    border-color: #C8102E;
}

.btn-primary:hover {
    background-color: #a80e24;
    border-color: #a80e24;
}

.btn-success {
    background-color: #FFD700;
    border-color: #FFD700;
    color: #000;
}

.btn-success:hover {
    background-color: #e6c200;
    border-color: #e6c200;
}

.btn-secondary {
    background-color: #333;
    border-color: #333;
}

.btn-secondary:hover {
    background-color: #111;
    border-color: #111;
}

.btn-danger {
    background-color: #D72638;
    border-color: #D72638;
}

.modal-content {
    border-radius: 15px;
}

.list-group-item {
    border-radius: 10px;
    margin-bottom: 8px;
}

h5 {
    color: #C8102E;
    font-weight: 600;
}
</style>
