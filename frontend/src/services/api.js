import axios from 'axios'

// const api = axios.create({
//   baseURL: 'http://localhost:8000/api',
//   withCredentials: false
// })

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api',
  headers: {
    'Content-Type': 'application/json'
  }
})

// Añadir token a cada petición si existe
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default api
