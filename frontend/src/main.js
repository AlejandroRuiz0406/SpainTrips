import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'bootstrap/dist/css/bootstrap.min.css'
import * as bootstrap from 'bootstrap'
import 'bootstrap'
import { usuario } from './authBus'

const saved = localStorage.getItem("usuario")
if (saved) {
  try {
    usuario.value = JSON.parse(saved)
  } catch {
    localStorage.removeItem("usuario")
    usuario.value = null
  }
} else {
  usuario.value = null
}

const app = createApp(App)
app.use(router)
app.mount('#app')

// Chat de atención al cliente (Tawk.to)
const s1 = document.createElement('script')
s1.async = true
s1.src = 'https://embed.tawk.to/681a467b0f0cd31910ef6794/1iqja6kil'
s1.charset = 'UTF-8'
s1.setAttribute('crossorigin', '*')
document.body.appendChild(s1)

// Esperar a que Tawk cargue y ocultar el widget por defecto
window.Tawk_API.onLoad = function () {
    window.Tawk_API.hide();
};

// Mostrar el chat solo en la ruta /contacto
router.afterEach((to) => {
    if (window.Tawk_API && window.Tawk_API.hide && window.Tawk_API.show) {
        if (to.path === '/contacto') {
            window.Tawk_API.show();
        } else {
            window.Tawk_API.hide();
        }
    }
});

