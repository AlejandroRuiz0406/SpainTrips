import api from '../services/api'
import { useRouter } from 'vue-router'

export const cerrarSesion = async () => {
  const router = useRouter()

  try {
    await api.post('/logout', {}, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`
      }
    })
  } catch (error) {
    console.warn('Fallo al cerrar sesión, pero limpiamos de todos modos.')
  }

  localStorage.removeItem('token')
  localStorage.removeItem('usuario')

  router.push('/login')
}
