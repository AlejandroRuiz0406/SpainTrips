import { ref } from 'vue'

//export const usuario = ref(null)

export const usuario = ref(JSON.parse(localStorage.getItem('usuario') || '{}'))

export const setUsuario = (userData) => {
  usuario.value = userData
}
