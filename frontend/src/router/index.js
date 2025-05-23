import { createRouter, createWebHistory } from 'vue-router'

import Home from '../views/Home.vue'
import VueloHotel from '../views/VueloHotel.vue'
import SoloHotel from '../views/SoloHotel.vue'
import Ofertas from '../views/OfertasEspeciales.vue'
import Opiniones from '../views/Opiniones.vue'
import Contacto from '../views/Contacto.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import ZonaCliente from '../views/ZonaCliente.vue'
import ZonaAdmin from '../views/ZonaAdmin.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/vuelo-hotel', component: VueloHotel },
  { path: '/solo-hotel', component: SoloHotel },
  { path: '/ofertas', component: Ofertas },
  { path: '/opiniones', component: Opiniones },
  { path: '/contacto', component: Contacto },
  { path: '/login', component: Login },
  { path: '/registro', component: Register },
  //{ path: '/cliente', component: ZonaCliente },
  {
    path: '/cliente',
    name: 'ZonaCliente',
    component: () => import('../views/ZonaCliente.vue')
  },
  {
    path: '/admin',
    name: 'ZonaAdmin',
    component: () => import('../views/ZonaAdmin.vue'),
    beforeEnter: (to, from, next) => {
      const user = JSON.parse(localStorage.getItem('usuario'))
      if (user?.rol === 'administrador') {
        next()
      } else {
        next('/') // o redirige a una página 403 si tienes una
      }
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
