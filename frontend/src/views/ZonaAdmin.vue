<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api'
import Swal from 'sweetalert2'

const mostrarUsuarios = ref(false)
const usuarios = ref([])
const form = ref({})
const formVisible = ref(false)
const editando = ref(false)

const obtenerUsuarios = async () => {
    const res = await api.get('/usuarios')
    usuarios.value = res.data
}

const nuevoUsuario = () => {
    form.value = { Nombre: '', Correo: '', Contraseña: '', rol: 'cliente' }
    formVisible.value = true
    editando.value = false
}

const editarUsuario = (u) => {
    form.value = { ...u }
    formVisible.value = true
    editando.value = true
}

const guardarUsuario = async () => {
    if (editando.value) {
        await api.put(`/usuarios/${form.value.ID_usuario}`, form.value)
    } else {
        await api.post('/usuarios', form.value)
    }
    formVisible.value = false
    obtenerUsuarios()
}

const eliminarUsuario = async (id) => {
    const result = await Swal.fire({
        title: '¿Estás seguro?',
        text: 'Esta acción eliminará el usuario permanentemente.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    })

    if (result.isConfirmed) {
        try {
            await api.delete(`/usuarios/${id}`)
            usuarios.value = usuarios.value.filter(u => u.ID_usuario !== id)
            Swal.fire('Eliminado', 'El usuario ha sido eliminado.', 'success')
        } catch (error) {
            Swal.fire('Error', 'No se pudo eliminar el usuario.', 'error')
        }
    }
}

const cerrarUsuarios = () => {
    mostrarUsuarios.value = false
    formVisible.value = false
}

const mostrarDestinos = ref(false)
const destinos = ref([])
const formDestino = ref({})
const formDestinoVisible = ref(false)
const editandoDestino = ref(false)

const obtenerDestinos = async () => {
    const res = await api.get('/destinos')
    destinos.value = res.data
}
const nuevoDestino = () => {
    formDestino.value = { Nombre: '', Ubicacion: '', Precio: 0, Temporada: '', Tipo_experiencia: '', Accesibilidad: '', Seccion_destino: '' }
    formDestinoVisible.value = true
    editandoDestino.value = false
}
const editarDestino = (d) => {
    formDestino.value = { ...d }
    formDestinoVisible.value = true
    editandoDestino.value = true
}
const guardarDestino = async () => {
    if (editandoDestino.value) {
        await api.put(`/destinos/${formDestino.value.ID_destino}`, formDestino.value)
    } else {
        await api.post('/destinos', formDestino.value)
    }
    formDestinoVisible.value = false
    obtenerDestinos()
}
const eliminarDestino = async (id) => {
    const result = await Swal.fire({
        title: '¿Estás seguro?',
        text: 'Esta acción eliminará el destino permanentemente.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    })

    if (result.isConfirmed) {
        try {
            await api.delete(`/destinos/${id}`)
            destinos.value = destinos.value.filter(d => d.ID_destino !== id)
            Swal.fire('Eliminado', 'El destino ha sido eliminado.', 'success')
        } catch (error) {
            Swal.fire('Error', 'No se pudo eliminar el destino.', 'error')
        }
    }
}

const cerrarDestinos = () => {
    mostrarDestinos.value = false
    formDestinoVisible.value = false
}

const mostrarReservas = ref(false)
const reservas = ref([])
const formReserva = ref({})
const formReservaVisible = ref(false)
const editandoReserva = ref(false)

const obtenerReservas = async () => {
    const res = await api.get('/reservas')
    reservas.value = res.data
}

const nuevaReserva = () => {
    formReserva.value = {
        ID_usuario: '',
        ID_destino: '',
        ID_vuelo: '',
        fecha_inicio: '',
        fecha_fin: '',
        adultos: 1,
        ninos: 0,
        habitaciones: 1,
        Estado: 'pendiente',
        total: 0
    }
    formReservaVisible.value = true
    editandoReserva.value = false
}

const editarReserva = (reserva) => {
    formReserva.value = { ...reserva }
    formReservaVisible.value = true
    editandoReserva.value = true
}

const guardarReserva = async () => {
    if (editandoReserva.value) {
        await api.put(`/reservas/${formReserva.value.ID_reserva}`, formReserva.value)
    } else {
        await api.post('/reservas', formReserva.value)
    }
    formReservaVisible.value = false
    obtenerReservas()
}

const eliminarReserva = async (id) => {
    const result = await Swal.fire({
        title: '¿Eliminar reserva?',
        text: 'Esta acción es irreversible.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    })

    if (result.isConfirmed) {
        try {
            await api.delete(`/reservas/${id}`)
            reservas.value = reservas.value.filter(r => r.ID_reserva !== id)
            Swal.fire('Eliminada', 'La reserva ha sido eliminada.', 'success')
        } catch {
            Swal.fire('Error', 'No se pudo eliminar la reserva.', 'error')
        }
    }
}

const cerrarReservas = () => {
    mostrarReservas.value = false
    formReservaVisible.value = false
}

const mostrarRecompensas = ref(false)
const recompensas = ref([])
const formRecompensa = ref({})
const formRecompensaVisible = ref(false)
const editandoRecompensa = ref(false)

const obtenerRecompensas = async () => {
    const res = await api.get('/recompensas')
    recompensas.value = res.data
}

const nuevaRecompensa = () => {
    formRecompensa.value = {
        ID_usuario: '',
        Descuento_aplicado: '',
        Puntos_necesarios: ''
    }
    editandoRecompensa.value = false
    formRecompensaVisible.value = true
}

const guardarRecompensa = async () => {
    if (editandoRecompensa.value) {
        await api.put(`/recompensas/${formRecompensa.value.ID_recompensa}`, formRecompensa.value)
    } else {
        await api.post('/recompensas', formRecompensa.value)
    }
    formRecompensaVisible.value = false
    obtenerRecompensas()
}


const editarRecompensa = (recompensa) => {
    formRecompensa.value = { ...recompensa }
    editandoRecompensa.value = true
    formRecompensaVisible.value = true
}

const eliminarRecompensa = async (id) => {
    const result = await Swal.fire({
        title: '¿Eliminar recompensa?',
        text: 'Esta acción es irreversible.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    })

    if (result.isConfirmed) {
        try {
            await api.delete(`/recompensas/${id}`)
            recompensas.value = recompensas.value.filter(r => r.ID_recompensa !== id)
            Swal.fire('Eliminada', 'La recompensa ha sido eliminada.', 'success')
        } catch {
            Swal.fire('Error', 'No se pudo eliminar la recompensa.', 'error')
        }
    }
}

const cerrarRecompensas = () => {
    mostrarRecompensas.value = false
    formRecompensaVisible.value = false
}

const mostrarOpiniones = ref(false)
const opiniones = ref([])

const obtenerOpiniones = async () => {
    const res = await api.get('/opiniones')
    opiniones.value = res.data
}

const eliminarOpinion = async (id) => {
    const result = await Swal.fire({
        title: '¿Eliminar opinión?',
        text: 'Esta acción no se puede deshacer.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    })

    if (result.isConfirmed) {
        try {
            await api.delete(`/opiniones/${id}`)
            opiniones.value = opiniones.value.filter(o => o.ID_opinion !== id)
            Swal.fire('Eliminada', 'La opinión ha sido eliminada.', 'success')
        } catch {
            Swal.fire('Error', 'No se pudo eliminar la opinión.', 'error')
        }
    }
}

const cerrarOpiniones = () => {
    mostrarOpiniones.value = false
}

const mostrarEstadisticas = ref(false)
const stats = ref({
    usuarios: 0,
    destinos: 0,
    reservas: 0,
    opiniones: 0,
    recompensas: 0
})

const toggleAccesibilidad = () => {
    document.body.classList.toggle('modo-accesible');
}

const cargarEstadisticas = async () => {
    const [u, d, r, o, rec] = await Promise.all([
        api.get('/usuarios'),
        api.get('/destinos'),
        api.get('/reservas'),
        api.get('/opiniones'),
        api.get('/recompensas')
    ])

    stats.value = {
        usuarios: u.data.length,
        destinos: d.data.length,
        reservas: r.data.length,
        opiniones: o.data.length,
        recompensas: rec.data.length
    }
}

onMounted(() => {
    obtenerUsuarios()
    obtenerDestinos()
    obtenerReservas()
    obtenerRecompensas()
    obtenerOpiniones()
})
</script>

<template>
    <div class="container my-5">
        <h1 class="text-center mb-4 fw-bold">Zona Administrador</h1>
        <div class="d-flex justify-content-end mb-3">
            <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                ♿ Accesibilidad visual
            </button>
        </div>

        <div class="d-flex flex-column align-items-center gap-3">
            <div class="col">
                <button class="btn btn-primary w-100" @click="mostrarUsuarios = true">
                    Gestión de usuarios
                </button>
            </div>
            <div class="col">
                <button class="btn btn-primary w-100" @click="mostrarDestinos = true">
                    Gestión de destinos
                </button>
            </div>
            <div class="col">
                <button class="btn btn-primary w-100" @click="mostrarReservas = true">
                    Gestión de reservas
                </button>
            </div>
            <div class="col">
                <button class="btn btn-primary w-100" @click="mostrarRecompensas = true">
                    Asignación de recompensas
                </button>
            </div>
            <div class="col">
                <button class="btn btn-primary w-100" @click="mostrarOpiniones = true">
                    Visualización de opiniones
                </button>
            </div>
            <div class="col">
                <button class="btn btn-primary w-100"
                    @click="mostrarEstadisticas = true; cargarEstadisticas()">Estadísticas del sistema</button>
            </div>
        </div>

        <!-- MODAL USUARIOS -->
        <div v-if="mostrarUsuarios" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Usuarios</h3>

                <button class="btn btn-success mb-3" @click="nuevoUsuario()">Nuevo Usuario</button>

                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Correo</th>
                            <th>Rol</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="u in usuarios" :key="u.ID_usuario">
                            <td>{{ u.ID_usuario }}</td>
                            <td>{{ u.Nombre }}</td>
                            <td>{{ u.Correo }}</td>
                            <td>{{ u.rol }}</td>
                            <td>
                                <button class="btn btn-sm btn-warning me-2" @click="editarUsuario(u)">Editar</button>
                                <button class="btn btn-sm btn-danger"
                                    @click="eliminarUsuario(u.ID_usuario)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Formulario modal -->
                <div v-if="formVisible">
                    <h5>{{ editando ? 'Editar' : 'Nuevo' }} Usuario</h5>
                    <input v-model="form.Nombre" placeholder="Nombre" class="form-control mb-2" />
                    <input v-model="form.Correo" placeholder="Correo" class="form-control mb-2" />
                    <input v-model="form.Contraseña" placeholder="Contraseña" type="password"
                        class="form-control mb-2" />
                    <select v-model="form.rol" class="form-control mb-3">
                        <option value="cliente">Cliente</option>
                        <option value="administrador">Administrador</option>
                    </select>
                    <button class="btn btn-primary" @click="guardarUsuario">Guardar</button>
                </div>

                <button class="btn btn-secondary mt-3" @click="cerrarUsuarios">Cerrar</button>
            </div>
        </div>

        <!-- MODAL DESTINOS -->
        <div v-if="mostrarDestinos" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Destinos</h3>
                <button class="btn btn-success mb-3" @click="nuevoDestino()">Nuevo Destino</button>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Ubicación</th>
                            <th>Precio</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="d in destinos" :key="d.ID_destino">
                            <td>{{ d.ID_destino }}</td>
                            <td>{{ d.Nombre }}</td>
                            <td>{{ d.Ubicacion }}</td>
                            <td>{{ d.Precio }} €</td>
                            <td>
                                <button class="btn btn-sm btn-warning me-2" @click="editarDestino(d)">Editar</button>
                                <button class="btn btn-sm btn-danger"
                                    @click="eliminarDestino(d.ID_destino)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="formDestinoVisible">
                    <h5>{{ editandoDestino ? 'Editar' : 'Nuevo' }} Destino</h5>
                    <input v-model="formDestino.Nombre" placeholder="Nombre" class="form-control mb-2" />
                    <input v-model="formDestino.Ubicacion" placeholder="Ubicación" class="form-control mb-2" />
                    <input v-model="formDestino.Precio" placeholder="Precio" type="number" class="form-control mb-2" />
                    <input v-model="formDestino.Temporada" placeholder="Temporada" class="form-control mb-2" />
                    <input v-model="formDestino.Tipo_experiencia" placeholder="Tipo de experiencia"
                        class="form-control mb-2" />
                    <input v-model="formDestino.Accesibilidad" placeholder="Accesibilidad" class="form-control mb-2" />
                    <input v-model="formDestino.Seccion_destino" placeholder="Sección" class="form-control mb-2" />
                    <button class="btn btn-primary" @click="guardarDestino">Guardar</button>
                </div>
                <button class="btn btn-secondary mt-3" @click="cerrarDestinos">Cerrar</button>
            </div>
        </div>

        <!-- MODAL RESERVAS -->
        <div v-if="mostrarReservas" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Reservas</h3>
                <button class="btn btn-success mb-3" @click="nuevaReserva()">Nueva Reserva</button>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Usuario</th>
                            <th>Destino</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Fin</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="r in reservas" :key="r.ID_reserva">
                            <td>{{ r.ID_reserva }}</td>
                            <td>{{ r.ID_usuario }}</td>
                            <td>{{ r.ID_destino }}</td>
                            <td>{{ r.fecha_inicio }}</td>
                            <td>{{ r.fecha_fin }}</td>
                            <td>{{ r.Estado }}</td>
                            <td>
                                <button class="btn btn-sm btn-warning me-2" @click="editarReserva(r)">Editar</button>
                                <button class="btn btn-sm btn-danger"
                                    @click="eliminarReserva(r.ID_reserva)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="formReservaVisible">
                    <h5>{{ editandoReserva ? 'Editar' : 'Nueva' }} Reserva</h5>

                    <label>ID Usuario</label>
                    <input v-model="formReserva.ID_usuario" type="number" class="form-control mb-2" />

                    <label>ID Destino</label>
                    <input v-model="formReserva.ID_destino" type="number" class="form-control mb-2" />

                    <label>ID Vuelo (opcional)</label>
                    <input v-model="formReserva.ID_vuelo" type="number" class="form-control mb-2" />

                    <label>Fecha Inicio</label>
                    <input v-model="formReserva.fecha_inicio" type="date" class="form-control mb-2" />

                    <label>Fecha Fin</label>
                    <input v-model="formReserva.fecha_fin" type="date" class="form-control mb-2" />

                    <label>Adultos</label>
                    <input v-model="formReserva.adultos" type="number" class="form-control mb-2" />

                    <label>Niños</label>
                    <input v-model="formReserva.ninos" type="number" class="form-control mb-2" />

                    <label>Habitaciones</label>
                    <input v-model="formReserva.habitaciones" type="number" class="form-control mb-2" />

                    <label>Estado</label>
                    <input v-model="formReserva.Estado" class="form-control mb-2" />

                    <label>Total (€)</label>
                    <input v-model="formReserva.total" type="number" class="form-control mb-3" />

                    <button class="btn btn-primary" @click="guardarReserva">Guardar</button>
                </div>
                <button class="btn btn-secondary mt-3" @click="cerrarReservas">Cerrar</button>
            </div>
        </div>

        <!-- MODAL RECOMPENSAS -->
        <div v-if="mostrarRecompensas" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Recompensas asignadas</h3>
                <button class="btn btn-success mb-3" @click="nuevaRecompensa()">Asignar Recompensa</button>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>ID Usuario</th>
                            <th>Descuento</th>
                            <th>Puntos</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="r in recompensas" :key="r.ID_recompensa">
                            <td>{{ r.ID_recompensa }}</td>
                            <td>{{ r.ID_usuario }}</td>
                            <td>{{ r.Descuento_aplicado }}</td>
                            <td>{{ r.Puntos_necesarios }}</td>
                            <td>
                                <button class="btn btn-sm btn-warning me-2" @click="editarRecompensa(r)">Editar</button>
                                <button class="btn btn-sm btn-danger"
                                    @click="eliminarRecompensa(r.ID_recompensa)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="formRecompensaVisible">
                    <h5>Asignar Recompensa</h5>
                    <label>ID Usuario</label>
                    <input v-model="formRecompensa.ID_usuario" type="number" class="form-control mb-2" />
                    <label>Descuento aplicado</label>
                    <input v-model="formRecompensa.Descuento_aplicado" class="form-control mb-2" />
                    <label>Puntos necesarios</label>
                    <input v-model="formRecompensa.Puntos_necesarios" type="number" class="form-control mb-3" />
                    <button class="btn btn-primary" @click="guardarRecompensa">Guardar</button>
                </div>
                <button class="btn btn-secondary mt-3" @click="cerrarRecompensas">Cerrar</button>
            </div>
        </div>

        <!-- MODAL OPINIONES -->
        <div v-if="mostrarOpiniones" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Opiniones de usuarios</h3>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>ID Usuario</th>
                            <th>Comentario</th>
                            <th>Puntuación</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="o in opiniones" :key="o.ID_opinion">
                            <td>{{ o.ID_opinion }}</td>
                            <td>{{ o.ID_usuario }}</td>
                            <td>{{ o.Comentario }}</td>
                            <td>{{ o.Puntuacion }}</td>
                            <td>
                                <button class="btn btn-sm btn-danger"
                                    @click="eliminarOpinion(o.ID_opinion)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button class="btn btn-secondary mt-3" @click="cerrarOpiniones">Cerrar</button>
            </div>
        </div>

        <!-- MODAL ESTADISTICAS -->
        <div v-if="mostrarEstadisticas" class="modal-backdrop">
            <div class="modal-content-custom">
                <h3 class="mb-3">Estadísticas del sistema</h3>
                <table class="table table-bordered">
                    <tbody>
                        <tr>
                            <th>Usuarios registrados</th>
                            <td>{{ stats.usuarios }}</td>
                        </tr>
                        <tr>
                            <th>Destinos</th>
                            <td>{{ stats.destinos }}</td>
                        </tr>
                        <tr>
                            <th>Reservas</th>
                            <td>{{ stats.reservas }}</td>
                        </tr>
                        <tr>
                            <th>Opiniones</th>
                            <td>{{ stats.opiniones }}</td>
                        </tr>
                        <tr>
                            <th>Recompensas asignadas</th>
                            <td>{{ stats.recompensas }}</td>
                        </tr>
                    </tbody>
                </table>
                <button class="btn btn-secondary mt-3" @click="mostrarEstadisticas = false">Cerrar</button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    font-family: 'Poppins', sans-serif;
}

h1,
h3,
h5 {
    color: #C8102E;
}

.btn-primary {
    background-color: #C8102E;
    border-color: #C8102E;
    font-weight: 600;
}

.btn-primary:hover {
    background-color: #a80e24;
    border-color: #a80e24;
}

.btn-success {
    background-color: #FFD700;
    border-color: #FFD700;
    color: #000;
    font-weight: 600;
}

.btn-success:hover {
    background-color: #e6c200;
    border-color: #e6c200;
}

.btn-warning {
    background-color: #ff9800;
    border-color: #ff9800;
    color: white;
}

.btn-danger {
    background-color: #D72638;
    border-color: #D72638;
}

.btn-secondary {
    background-color: #333;
    border-color: #333;
    color: white;
}

.modal-content-custom {
    background: #fff;
    padding: 2.5rem;
    border-radius: 20px;
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
    max-width: 850px;
    width: 100%;
    max-height: 90vh;
    overflow-y: auto;
    border: 1px solid #eee;
    animation: fadeIn 0.3s ease-in-out;
}

.modal-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1050;
    padding: 2rem;
    /* Evita que se pegue a los bordes en pantallas pequeñas */
    overflow-y: auto;
}

h3 {
    color: #C8102E;
    font-weight: 700;
    font-size: 1.8rem;
}

.table th {
    background-color: #F7C600;
    color: #000;
    font-weight: bold;
    text-align: center;
}

.table td {
    vertical-align: middle;
    text-align: center;
    font-size: 0.95rem;
}

.btn {
    border-radius: 12px;
    font-weight: 500;
    padding: 6px 14px;
    font-size: 0.9rem;
}

.btn-success {
    background-color: #FFD700;
    border-color: #FFD700;
    color: #000;
}

.btn-success:hover {
    background-color: #e6c200;
}

.btn-warning {
    background-color: #FFB300;
    border-color: #FFB300;
    color: white;
}

.btn-danger {
    background-color: #D72638;
    border-color: #D72638;
    color: white;
}

.btn-secondary {
    background-color: #444;
    border-color: #444;
    color: white;
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