import Swal from 'sweetalert2'

export function mostrarExito(titulo = 'Éxito', mensaje = 'Operación realizada correctamente') {
  return Swal.fire({
    icon: 'success',
    title: titulo,
    text: mensaje,
    confirmButtonColor: '#8e7dff',
    confirmButtonText: 'OK'
  })
}

export function mostrarError(titulo = 'Error', mensaje = 'Ha ocurrido un problema') {
  return Swal.fire({
    icon: 'error',
    title: titulo,
    text: mensaje,
    confirmButtonColor: '#e63946', // rojo intenso
    confirmButtonText: 'OK'
  })
}
