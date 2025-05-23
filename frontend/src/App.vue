<script>
import Navbar from './components/Navbar.vue'
import Footer from './components/Footer.vue'

export default {
  components: {
    Navbar,
    Footer
  }
}
</script>

<template>
  <div class="app-wrapped">
    <Navbar />
    <router-view class="main-content" />
    <Footer />
  </div>
</template>

<style>
.app-wrapped {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
}

@keyframes fondoRotativo {
  0%   { background-image: url('/img/playa.jpg'); }
  33%  { background-image: url('/img/montaña.jpg'); }
  66%  { background-image: url('/img/ciudad.jpg'); }
  100% { background-image: url('/img/playa.jpg'); }
}

body {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  animation: fondoRotativo 30s infinite;
  transition: background-image 1s ease-in-out;
}
</style>
