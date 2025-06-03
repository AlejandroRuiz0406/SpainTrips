<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'
import { usuario, setUsuario } from '../authBus'

export default {
    setup() {
        //const usuario = ref(null)
        const router = useRouter()

        // onMounted(() => {
        //     const userData = localStorage.getItem('usuario')
        //     if (userData) {
        //         usuario.value = JSON.parse(userData)
        //     }
        // })

        onMounted(() => {
            const userData = localStorage.getItem('usuario')
            if (userData && userData !== 'undefined') {
                try {
                    setUsuario(JSON.parse(userData))
                } catch (e) {
                    console.warn('Usuario corrupto en localStorage. Reiniciando...')
                    localStorage.removeItem('usuario')
                    setUsuario(null)
                }
            }
        })

        const cerrarSesion = async () => {
            try {
                await axios.post('http://localhost:8000/api/logout', {}, {
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
        }

        const toggleAccesibilidad = () => {
            document.body.classList.toggle('modo-accesible');
        }

        return { usuario, cerrarSesion, toggleAccesibilidad }
    }
}
</script>


<template>
    <nav class="navbar navbar-expand-lg navbar-dark px-4"
        style="position: sticky; top: 0; z-index: 1000; background-color: #0053A0;">
        <div class="container-fluid">
            <RouterLink class="navbar-brand d-flex align-items-center" to="/">
                <img src="/img/logo.png" alt="SpainTrips Logo" style="height: 52px; object-fit: contain;"
                    class="me-2 rounded bg-white p-1 shadow-sm" />
            </RouterLink>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/">Inicio</RouterLink>
                    </li>
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/vuelo-hotel">Vuelo + Hotel</RouterLink>
                    </li>
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/solo-hotel">Solo Hotel</RouterLink>
                    </li>
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/ofertas">Ofertas Especiales</RouterLink>
                    </li>
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/opiniones">Opiniones</RouterLink>
                    </li>
                    <li class="nav-item">
                        <RouterLink class="nav-link" to="/contacto">Contacto</RouterLink>
                    </li>
                </ul>

                <ul class="navbar-nav mb-2 mb-lg-0 d-flex align-items-center">
                    <li class="nav-item me-3">
                        <button @click="toggleAccesibilidad" class="btn btn-outline-light bg-dark">
                            ♿ Accesibilidad visual
                        </button>
                    </li>

                    <li v-if="!usuario" class="nav-item me-3">
                        <RouterLink class="nav-link" to="/login">Iniciar sesión</RouterLink>
                    </li>
                    <li v-if="!usuario" class="nav-item me-3">
                        <RouterLink class="nav-link" to="/registro">Registrarse</RouterLink>
                    </li>

                    <li v-if="usuario && usuario.puntos !== undefined" class="nav-item me-3">
                        <span class="text-white fw-semibold"
                            style="background: rgba(0,0,0,0.2); padding: 6px 12px; border-radius: 8px; font-size: 0.9rem;">
                            💠 {{ usuario.puntos }} SP
                        </span>
                    </li>

                    <li v-if="usuario && (usuario.rol === 'cliente' || usuario.rol === 'usuario')"
                        class="nav-item me-3">
                        <RouterLink class="nav-link" to="/cliente">Zona Cliente</RouterLink>
                    </li>

                    <li v-if="usuario && usuario.rol === 'administrador'" class="nav-item me-3">
                        <RouterLink class="nav-link" to="/admin">Zona Admin</RouterLink>
                    </li>

                    <li v-if="usuario?.ID_usuario" class="nav-item">
                        <button class="btn btn-outline-light btn-sm" @click="cerrarSesion">Salir</button>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</template>

<style>
.btn {
    border-radius: 999px;
    font-weight: 600;
}

.router-link-active {
    color: #FFD700 !important;
    font-weight: bold !important;
}
</style>