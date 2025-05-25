<script>
import api from '../services/api'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { setUsuario } from '../authBus'

export default {
    setup() {
        const correo = ref('')
        const contrasena = ref('')
        const cargando = ref(false)
        const error = ref('')
        const router = useRouter()

        const iniciarSesion = async () => {
            cargando.value = true
            error.value = ''

            try {
                const response = await axios.post('http://localhost:8000/api/login', {
                    Correo: correo.value,
                    Contraseña: contrasena.value
                })

                const { access_token, token_type, usuario, rol } = response.data

                // Guardamos la sesión
                localStorage.setItem('token', access_token)
                localStorage.setItem('user_id', usuario.ID_usuario)
                //localStorage.setItem('usuario', JSON.stringify({ nombre: usuario, rol }))
                localStorage.setItem('usuario', JSON.stringify(usuario))
                setUsuario(response.data.usuario)

                // Redirigir según rol
                if (rol === 'admin') {
                    router.push('/')
                } else {
                    router.push('/')
                }

            } catch (err) {
                //error.value = err.response?.data?.error || 'Error al iniciar sesión'
                console.log(err.response?.data) // para ver el mensaje exacto en consola
                error.value = err.response?.data?.error || 'Error al iniciar sesión'
            } finally {
                cargando.value = false
            }
        }

        return {
            correo,
            contrasena,
            cargando,
            error,
            iniciarSesion
        }
    }
}
</script>

<template>
    <div class="container mt-5">
        <div class="card shadow-sm p-4 mx-auto" style="max-width: 500px; border-radius: 16px;">
            <h2 class="mb-4" style="color: #0053A0; font-weight: 700;">Iniciar Sesión</h2>
            <form @submit.prevent="iniciarSesion">
                <div class="container mt-5" style="max-width: 500px;">
                    <form @submit.prevent="iniciarSesion">
                        <div class="mb-3">
                            <label for="correo" class="form-label">Correo electrónico</label>
                            <input v-model="correo" type="email" class="form-control" id="correo" required />
                        </div>
                        <div class="mb-3">
                            <label for="contrasena" class="form-label">Contraseña</label>
                            <input v-model="contrasena" type="password" class="form-control" id="contrasena" required />
                        </div>
                        <button type="submit" class="btn text-white w-100" style="background-color: #D62828;"
                            :disabled="cargando">
                            {{ cargando ? 'Accediendo...' : 'Entrar' }}
                        </button>
                        <div class="text-center mt-3">
                            <span>¿No tienes cuenta? </span>
                            <RouterLink to="/registro" class="text-decoration-none fw-semibold" style="color: #0053A0;">
                                Regístrate aquí
                            </RouterLink>
                        </div>
                        <div v-if="error" class="alert alert-danger mt-3">{{ error }}</div>
                    </form>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
a {
  transition: color 0.2s ease;
}
a:hover {
  color: #003d7a;
  text-decoration: underline;
}
</style>