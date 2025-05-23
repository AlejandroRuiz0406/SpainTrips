<script>
export default {}
</script>

<template>
    <footer class="footer-custom mt-5">
        <div class="container text-center">
            <p class="mb-2">© 2025 <strong>SpainTrips</strong>. Todos los derechos reservados.</p>
            <p class="mb-0">
                <RouterLink class="footer-link" to="/contacto">Contacto</RouterLink> |
                <RouterLink class="footer-link" to="/opiniones">Opiniones</RouterLink>
            </p>
        </div>
    </footer>
</template>

<style scoped>
.footer-custom {
    background-color: #0053A0;
    /* el mismo que la navbar */
    color: #ffffff;
    padding: 2rem 0;
    font-family: 'Poppins', sans-serif;
    font-size: 0.95rem;
    box-shadow: 0 -4px 10px rgba(0, 0, 0, 0.1);
}

.footer-custom strong {
    color: #FFD700;
    /* acento amarillo */
}

.footer-link {
    color: #FFD700;
    text-decoration: none;
    margin: 0 8px;
    transition: color 0.3s ease;
}

.footer-link:hover {
    color: #ffffff;
    text-decoration: underline;
}
</style>