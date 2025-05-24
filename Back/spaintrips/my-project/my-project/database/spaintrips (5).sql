-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: mariadb:3306
-- Tiempo de generación: 24-05-2025 a las 15:27:25
-- Versión del servidor: 11.4.4-MariaDB
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `spaintrips`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `destinos`
--

CREATE TABLE `destinos` (
  `ID_destino` bigint(20) UNSIGNED NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Ubicacion` varchar(150) NOT NULL,
  `Precio` decimal(8,2) NOT NULL,
  `Temporada` varchar(50) DEFAULT NULL,
  `Tipo_experiencia` varchar(50) NOT NULL,
  `Accesibilidad` varchar(50) NOT NULL,
  `hotel` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `Seccion_destino` enum('temporada','experiencia') DEFAULT 'experiencia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `destinos`
--

INSERT INTO `destinos` (`ID_destino`, `Nombre`, `Ubicacion`, `Precio`, `Temporada`, `Tipo_experiencia`, `Accesibilidad`, `hotel`, `created_at`, `updated_at`, `Seccion_destino`) VALUES
(2, 'Barcelona', 'Barcelona', 349.50, 'Verano', 'aventura', 'No', 'Hotel W Barcelona', NULL, NULL, 'experiencia'),
(3, 'Valencia Cultura', 'Valencia', 199.90, 'Primavera', 'cultural', 'Sí', 'Hotel NH Valencia Center', NULL, NULL, 'experiencia'),
(4, 'Madrid', 'Centro de España', 120.50, 'Otoño', 'Cultural', 'Alta', 'Hotel Riu Plaza España', NULL, NULL, 'experiencia'),
(5, 'Tenerife Relax', 'Tenerife', 275.00, 'Verano', 'vuelo + hotel', 'Sí', 'Iberostar Tenerife', NULL, NULL, 'temporada'),
(6, 'Costa del Sol Relax', 'Málaga', 189.99, 'Verano', 'relax', 'Sí', 'Sol Málaga Guadalmar', NULL, NULL, 'experiencia'),
(7, 'Granada Aventura', 'Granada', 215.50, 'Invierno', 'aventura', 'No', 'Hotel Granada Center', NULL, NULL, 'temporada'),
(11, 'Lanzarote Relax', 'Lanzarote', 275.00, NULL, 'vuelo + hotel', 'Sí', 'NH Lanzarote', NULL, NULL, 'temporada'),
(12, 'Mallorca Sun', 'Palma de Mallorca', 240.00, NULL, 'vuelo + hotel', 'No', 'Hotel Sol Beach', NULL, NULL, 'temporada'),
(13, 'Costa Brava Escape', 'Girona', 220.00, NULL, 'vuelo + hotel', 'Sí', 'Brava Resort', NULL, NULL, 'temporada'),
(14, 'Vigo Cultural', 'Vigo', 260.00, NULL, 'vuelo + hotel', 'Sí', 'Hotel Centro Histórico', NULL, NULL, 'experiencia'),
(15, 'Zaragoza Turismo', 'Zaragoza', 280.00, NULL, 'vuelo + hotel', 'Sí', 'Gaudí Experience Hotel', NULL, NULL, 'experiencia'),
(16, 'Bilbao Modernismo', 'Bilbao', 230.00, NULL, 'vuelo + hotel', 'No', 'Hotel Ilunion Bilbao', NULL, NULL, 'experiencia'),
(17, 'Alicante Azul', 'Alicante', 210.00, NULL, 'vuelo + hotel', 'Sí', 'Blue Coast Hotel', NULL, NULL, 'temporada'),
(18, 'Cádiz Costa', 'Cádiz', 195.00, NULL, 'vuelo + hotel', 'No', 'Playa del Sur Resort', NULL, NULL, 'temporada'),
(19, 'Jaén Flamenca', 'Jaén', 250.00, NULL, 'vuelo + hotel', 'Sí', 'Hotel Olivo', NULL, NULL, 'experiencia'),
(20, 'San Sebastián Gastronómico', 'San Sebastián', 235.00, NULL, 'vuelo + hotel', 'Sí', 'Sabor Norte Hotel', NULL, NULL, 'experiencia'),
(21, 'Relax en Almería', 'Almería', 195.00, NULL, 'vuelo + hotel', 'Sí', 'Beachside Resort Almería', NULL, NULL, 'experiencia'),
(22, 'Cultura en Salamanca', 'Salamanca', 90.00, NULL, 'solo hotel', 'Sí', 'Hotel Universidad', NULL, NULL, 'experiencia'),
(23, 'Naturaleza en León', 'León', 95.00, NULL, 'solo hotel', 'No', 'Parador de la Montaña', NULL, NULL, 'temporada'),
(24, 'Gastronomía en Burgos', 'Burgos', 88.00, NULL, 'solo hotel', 'Sí', 'Hotel Asador Real', NULL, NULL, 'experiencia'),
(25, 'Escapada cultural a Cuenca', 'Cuenca', 95.00, NULL, 'solo hotel', 'Sí', 'Parador de Cuenca', NULL, NULL, 'temporada'),
(26, 'Naturaleza en Palencia', 'Palencia', 82.50, NULL, 'solo hotel', 'Sí', 'Hotel Montaña Verde', NULL, NULL, 'temporada'),
(27, 'Relax en Ciudad Real', 'Ciudad Real', 89.00, NULL, 'solo hotel', 'Sí', 'Hotel Termal Castilla', NULL, NULL, 'temporada'),
(28, 'Aventura en Zamora', 'Zamora', 76.00, NULL, 'solo hotel', 'Sí', 'Hotel Rural Los Arribes', NULL, NULL, 'temporada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favoritos`
--

CREATE TABLE `favoritos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ID_usuario` bigint(20) UNSIGNED NOT NULL,
  `ID_destino` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `favoritos`
--

INSERT INTO `favoritos` (`id`, `ID_usuario`, `ID_destino`, `created_at`, `updated_at`) VALUES
(1, 9, 5, '2025-05-21 18:10:50', '2025-05-21 18:10:50'),
(15, 2, 6, '2025-05-22 17:03:44', '2025-05-22 17:03:44'),
(17, 2, 3, '2025-05-24 11:11:24', '2025-05-24 11:11:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes_contacto`
--

CREATE TABLE `mensajes_contacto` (
  `ID_mensaje` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mensaje` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mensajes_contacto`
--

INSERT INTO `mensajes_contacto` (`ID_mensaje`, `nombre`, `email`, `mensaje`, `created_at`) VALUES
(1, 'Carlos', 'carlos@gmail.com', 'Tengo dudas.', '2025-05-06 17:21:56'),
(2, 'Carlos', 'carlos@gmail.com', 'Tengo una duda con respecto a la asistencia de rampa en ek aeropuerto de Tenerife', '2025-05-22 17:06:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensaje_contactos`
--

CREATE TABLE `mensaje_contactos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '2025_04_13_114507_create_destinos_table', 1),
(3, '2025_04_13_114520_create_usuarios_table', 1),
(4, '2025_04_13_114526_create_reservas_table', 1),
(5, '2025_04_13_114541_create_recompensas_table', 1),
(6, '2025_04_13_114549_create_opinions_table', 1),
(7, '2025_04_21_122823_2025_04_13_114541_create_recompensas_table', 2),
(8, '2025_04_24_165844_create_personal_access_tokens_table', 3),
(9, '2025_05_02_155513_make_id_destino_nullable_on_opiniones', 4),
(10, '2025_05_06_171933_create_mensaje_contactos_table', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opiniones`
--

CREATE TABLE `opiniones` (
  `ID_opinion` bigint(20) UNSIGNED NOT NULL,
  `ID_usuario` bigint(20) UNSIGNED NOT NULL,
  `Comentario` text NOT NULL,
  `Puntuacion` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `opiniones`
--

INSERT INTO `opiniones` (`ID_opinion`, `ID_usuario`, `Comentario`, `Puntuacion`, `created_at`, `updated_at`) VALUES
(2, 2, 'Muy buen destino, lo recomiendo', 5, NULL, NULL),
(3, 2, 'Gran web', 3, NULL, NULL),
(4, 2, 'Tenerife muy recomendado', 5, NULL, NULL),
(7, 2, 'Buena experiencia en Vigo.', 4, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(2, 'App\\Models\\Usuario', 2, 'spaintrips_token', '3b2aa1e442dc6db9a323c5554640c81ff53e61188aeda222f4bfb06d3e1d2072', '[\"*\"]', NULL, NULL, '2025-05-01 10:03:37', '2025-05-01 10:03:37'),
(3, 'App\\Models\\Usuario', 2, 'spaintrips_token', '763ffb526cb1d577580602f790a66d1bdcce7df929864a9803ccc9b45383003b', '[\"*\"]', NULL, NULL, '2025-05-01 11:13:35', '2025-05-01 11:13:35'),
(5, 'App\\Models\\Usuario', 2, 'spaintrips_token', '2eb24adbbda84236393c7f6f440c6ef723abafee470e7215cf832e03565c97a4', '[\"*\"]', NULL, NULL, '2025-05-01 11:38:35', '2025-05-01 11:38:35'),
(10, 'App\\Models\\Usuario', 2, 'spaintrips_token', '6c0072363b96335b43e1eca68d3379bb5a158f0b934d343bc234e608ea5c552f', '[\"*\"]', NULL, NULL, '2025-05-01 13:48:28', '2025-05-01 13:48:28'),
(11, 'App\\Models\\Usuario', 2, 'spaintrips_token', '4ef82651cc14fb27ba259ffdb5bba727ca2ea74dd67bcfd37abc94ff846c5156', '[\"*\"]', NULL, NULL, '2025-05-01 13:48:55', '2025-05-01 13:48:55'),
(12, 'App\\Models\\Usuario', 2, 'spaintrips_token', '12c9643864f654eb39468137bb58af696fa4bb4706a0b67c83fe1dc91a804404', '[\"*\"]', NULL, NULL, '2025-05-01 13:54:00', '2025-05-01 13:54:00'),
(13, 'App\\Models\\Usuario', 2, 'spaintrips_token', '9a32e30ba1bb18678e5fffb4a44781c86bba86ff00efc52a8b75715215f02228', '[\"*\"]', NULL, NULL, '2025-05-01 13:55:33', '2025-05-01 13:55:33'),
(25, 'App\\Models\\Usuario', 2, 'spaintrips_token', '3f84fb020e1e6f53036f3818e95f205f4365ccfb52dc2d4dd14f639341f709c9', '[\"*\"]', NULL, NULL, '2025-05-09 15:09:08', '2025-05-09 15:09:08'),
(32, 'App\\Models\\Usuario', 10, 'spaintrips_token', 'e9b2e2f86ff7643dfbf517afd504485b5e74b20bf1174f0ffaad7e7b793eec98', '[\"*\"]', NULL, NULL, '2025-05-17 13:39:15', '2025-05-17 13:39:15'),
(36, 'App\\Models\\Usuario', 2, 'spaintrips_token', '17dad08cbb986ace2d7bdbb30bef6fa81f3a7626a83e241a8f55b30225fb8608', '[\"*\"]', NULL, NULL, '2025-05-24 11:03:43', '2025-05-24 11:03:43'),
(37, 'App\\Models\\Usuario', 2, 'spaintrips_token', '908dc6027261b55123b94631b767e4fc8b5f6324941ffcb768cb7c39a6e199ff', '[\"*\"]', NULL, NULL, '2025-05-24 11:23:46', '2025-05-24 11:23:46'),
(38, 'App\\Models\\Usuario', 2, 'spaintrips_token', '518c0fa40b7d1aefbe4f1579abd6c92d2b887fc0b50050554d1853955f0daa64', '[\"*\"]', NULL, NULL, '2025-05-24 11:31:57', '2025-05-24 11:31:57'),
(39, 'App\\Models\\Usuario', 2, 'spaintrips_token', '21b615a31971b3666474bf5043d0dc96229a05a1fcfa3e71920b1e2661ded25f', '[\"*\"]', NULL, NULL, '2025-05-24 12:27:31', '2025-05-24 12:27:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recompensas`
--

CREATE TABLE `recompensas` (
  `ID_recompensa` bigint(20) UNSIGNED NOT NULL,
  `Descripcion` varchar(255) DEFAULT NULL,
  `Descuento_aplicado` int(255) NOT NULL,
  `Puntos_necesarios` int(11) NOT NULL,
  `ID_usuario` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `recompensas`
--

INSERT INTO `recompensas` (`ID_recompensa`, `Descripcion`, `Descuento_aplicado`, `Puntos_necesarios`, `ID_usuario`, `created_at`, `updated_at`) VALUES
(3, '5% de descuento', 20, 10, 2, NULL, NULL),
(4, '15% de descuento', 15, 100, NULL, NULL, NULL),
(5, NULL, 30, 50, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `ID_reserva` bigint(20) UNSIGNED NOT NULL,
  `ID_usuario` bigint(20) UNSIGNED NOT NULL,
  `ID_destino` bigint(20) UNSIGNED NOT NULL,
  `ID_vuelo` bigint(20) UNSIGNED DEFAULT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `Estado` varchar(20) NOT NULL DEFAULT 'pendiente',
  `Asistencia_movilidad` tinyint(1) DEFAULT 0,
  `Comentario_accesibilidad` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `adultos` int(11) DEFAULT 1,
  `ninos` int(11) DEFAULT 0,
  `habitaciones` int(11) DEFAULT 1,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `puntos_usados` int(11) NOT NULL DEFAULT 0,
  `Tipo_asistencia` varchar(255) DEFAULT NULL,
  `Nombre_hotel` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`ID_reserva`, `ID_usuario`, `ID_destino`, `ID_vuelo`, `Fecha`, `Estado`, `Asistencia_movilidad`, `Comentario_accesibilidad`, `created_at`, `updated_at`, `adultos`, `ninos`, `habitaciones`, `fecha_inicio`, `fecha_fin`, `total`, `puntos_usados`, `Tipo_asistencia`, `Nombre_hotel`) VALUES
(7, 2, 2, 4, '2025-04-20 00:00:00', 'confirmada', 0, NULL, NULL, NULL, 1, 0, 1, NULL, NULL, NULL, 0, NULL, NULL),
(8, 6, 2, 5, '2025-05-03 12:14:34', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 1, NULL, NULL, NULL, 0, NULL, NULL),
(9, 6, 2, 6, '2025-05-03 13:50:03', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 1, NULL, NULL, NULL, 0, NULL, NULL),
(12, 6, 2, 4, '2025-05-03 13:57:37', 'confirmada', 0, NULL, NULL, NULL, 2, 0, 0, '2025-05-03', '2025-05-04', 939.00, 0, NULL, NULL),
(13, 2, 5, NULL, '2025-05-04 13:50:55', 'pendiente', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL),
(14, 2, 3, 5, '2025-05-06 17:04:37', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 0, '2025-05-06', '2025-05-07', 295.40, 0, NULL, NULL),
(15, 2, 3, 5, '2025-05-06 17:04:52', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 0, '2025-05-06', '2025-05-07', 295.40, 0, NULL, NULL),
(16, 2, 7, NULL, '2025-05-06 17:05:07', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 0, '2025-05-06', '2025-05-07', 215.50, 0, NULL, NULL),
(17, 2, 5, NULL, '2025-05-06 17:05:31', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 0, '2025-05-06', '2025-05-07', 275.00, 0, NULL, NULL),
(18, 2, 4, NULL, '2025-05-06 17:05:58', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 0, '2025-05-06', '2025-05-07', 120.50, 0, NULL, NULL),
(19, 2, 3, 5, '2025-05-06 17:06:17', 'pendiente', 0, NULL, NULL, NULL, 0, 1, 0, '2025-05-06', '2025-05-07', 295.40, 0, NULL, NULL),
(78, 2, 6, NULL, '2025-05-22 17:05:05', 'pendiente', 1, 'Rampa', NULL, NULL, 1, 0, 1, '2025-05-22', '2025-05-23', 189.99, 0, NULL, NULL),
(85, 2, 3, NULL, '2025-05-24 11:04:00', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 1, '2025-05-24', '2025-05-25', 199.90, 0, NULL, NULL),
(86, 2, 5, NULL, '2025-05-24 11:09:34', 'pendiente', 0, NULL, NULL, NULL, 1, 0, 1, '2025-05-24', '2025-05-25', 275.00, 0, NULL, NULL),
(87, 2, 14, 13, '2025-05-24 11:10:34', 'confirmada', 1, NULL, NULL, NULL, 1, 0, 1, '2025-05-24', '2025-05-25', 342.00, 3, 'Asistencia hasta la puerta de embarque', 'Hotel Centro Histórico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID_usuario` bigint(20) UNSIGNED NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Correo` varchar(255) NOT NULL,
  `Contraseña` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `rol` varchar(50) NOT NULL DEFAULT 'usuario',
  `puntos` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID_usuario`, `Nombre`, `Correo`, `Contraseña`, `created_at`, `updated_at`, `rol`, `puntos`) VALUES
(2, 'Carlos Pérez', 'carlos@gmail.com', '$2y$12$6k1ceMhkLxHGA48.s0gka.vJTDH/HWtGMW90NRUh/JCxVDnomykjO', NULL, NULL, 'cliente', 145),
(3, 'Pepe', 'pepe@gmail.com', '$2y$12$CPzVgwGy7hCQ2M4HwJ7w4.jCErp/kfHloNgG2EC.4QwqhjSRRhX6a', NULL, NULL, 'usuario', 0),
(4, 'Juan', 'juan@email.com', '$2y$12$/VoDBxrYJBFC/2HbPKCBBute36dX7KobAiQDHC2E5DkU20k1NI.fu', NULL, NULL, 'usuario', 0),
(5, 'Alejandro', 'alejandro@gmail.com', '$2y$12$Or6St0HO6Hfh5uE3QDHNP.XF5SEFyytiPWBh50t65XjFW6RK2NDtq', NULL, NULL, 'usuario', 0),
(6, 'Ana', 'ana@gmail.com', '$2y$12$VvUXvrsOWyLLGlu9LQW7YO/TVkjf/XxKa52Z3.XxpvQD9pbbAaGt2', NULL, NULL, 'usuario', 6),
(9, 'admin', 'admin@spaintrips.com', '$2y$12$ounB2f4/IHLS852k0x.NnuVzNgp5BWogd3QHU2STp52qylm0BNwD6', NULL, NULL, 'administrador', 17),
(10, 'Alberto', 'alberto@gmail.com', '$2y$12$milCcr5.HKm0AMPAyy5ssOImfP0BOQXVttkbomUT.Y3rNb1kx15tS', NULL, NULL, 'usuario', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vuelos`
--

CREATE TABLE `vuelos` (
  `ID_vuelo` bigint(20) UNSIGNED NOT NULL,
  `ID_destino` bigint(20) UNSIGNED NOT NULL,
  `Compania` varchar(100) NOT NULL,
  `Numero_vuelo` varchar(50) NOT NULL,
  `Origen` varchar(100) NOT NULL,
  `Hora_salida` datetime NOT NULL,
  `Hora_llegada` datetime NOT NULL,
  `Precio_vuelo` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vuelos`
--

INSERT INTO `vuelos` (`ID_vuelo`, `ID_destino`, `Compania`, `Numero_vuelo`, `Origen`, `Hora_salida`, `Hora_llegada`, `Precio_vuelo`) VALUES
(4, 5, 'Iberia', 'IB1234', 'Madrid', '2025-06-01 10:00:00', '2025-06-01 11:30:00', 120.00),
(5, 3, 'Vueling', 'VY5678', 'Barcelona', '2025-06-02 09:00:00', '2025-06-02 10:40:00', 95.50),
(6, 4, 'Ryanair', 'FR9012', 'Valencia', '2025-06-03 14:00:00', '2025-06-03 15:30:00', 80.00),
(7, 2, 'Vueling', 'VY5678', 'Madrid', '2025-06-02 09:00:00', '2025-06-02 10:40:00', 95.50),
(8, 5, 'Iberia', 'IB005', 'Madrid', '2025-06-01 08:00:00', '2025-06-01 09:30:00', 110.00),
(9, 6, 'Vueling', 'VY006', 'Barcelona', '2025-06-02 09:00:00', '2025-06-02 10:40:00', 95.50),
(10, 11, 'Ryanair', 'FR011', 'Valencia', '2025-06-03 14:00:00', '2025-06-03 15:30:00', 80.00),
(11, 12, 'Iberia', 'IB012', 'Madrid', '2025-06-04 07:00:00', '2025-06-04 08:30:00', 105.00),
(12, 13, 'Vueling', 'VY013', 'Sevilla', '2025-06-05 10:00:00', '2025-06-05 11:40:00', 100.00),
(13, 14, 'Ryanair', 'FR014', 'Valencia', '2025-06-06 12:00:00', '2025-06-06 13:30:00', 85.00),
(14, 15, 'Iberia', 'IB015', 'Madrid', '2025-06-07 08:00:00', '2025-06-07 09:30:00', 115.00),
(15, 16, 'Vueling', 'VY016', 'Barcelona', '2025-06-08 09:00:00', '2025-06-08 10:40:00', 90.00),
(16, 17, 'Ryanair', 'FR017', 'Valencia', '2025-06-09 14:00:00', '2025-06-09 15:30:00', 82.00),
(17, 18, 'Iberia', 'IB018', 'Madrid', '2025-06-10 07:00:00', '2025-06-10 08:30:00', 108.00),
(18, 19, 'Vueling', 'VY019', 'Sevilla', '2025-06-11 10:00:00', '2025-06-11 11:40:00', 93.00),
(19, 20, 'Ryanair', 'FR020', 'Valencia', '2025-06-12 12:00:00', '2025-06-12 13:30:00', 88.00),
(20, 21, 'Iberia', 'IB021', 'Madrid', '2025-06-13 08:00:00', '2025-06-13 09:30:00', 110.00);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `destinos`
--
ALTER TABLE `destinos`
  ADD PRIMARY KEY (`ID_destino`),
  ADD UNIQUE KEY `destinos_ubicacion_unique` (`Ubicacion`);

--
-- Indices de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `favoritos_id_usuario_foreign` (`ID_usuario`),
  ADD KEY `favoritos_id_destino_foreign` (`ID_destino`);

--
-- Indices de la tabla `mensajes_contacto`
--
ALTER TABLE `mensajes_contacto`
  ADD PRIMARY KEY (`ID_mensaje`);

--
-- Indices de la tabla `mensaje_contactos`
--
ALTER TABLE `mensaje_contactos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `opiniones`
--
ALTER TABLE `opiniones`
  ADD PRIMARY KEY (`ID_opinion`),
  ADD KEY `opinions_id_usuario_foreign` (`ID_usuario`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indices de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD PRIMARY KEY (`ID_recompensa`),
  ADD KEY `recompensas_id_usuario_foreign` (`ID_usuario`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`ID_reserva`),
  ADD KEY `reservas_id_usuario_foreign` (`ID_usuario`),
  ADD KEY `reservas_id_destino_foreign` (`ID_destino`),
  ADD KEY `fk_reservas_vuelos` (`ID_vuelo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID_usuario`),
  ADD UNIQUE KEY `usuarios_correo_unique` (`Correo`);

--
-- Indices de la tabla `vuelos`
--
ALTER TABLE `vuelos`
  ADD PRIMARY KEY (`ID_vuelo`),
  ADD KEY `ID_destino` (`ID_destino`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `destinos`
--
ALTER TABLE `destinos`
  MODIFY `ID_destino` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `mensajes_contacto`
--
ALTER TABLE `mensajes_contacto`
  MODIFY `ID_mensaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mensaje_contactos`
--
ALTER TABLE `mensaje_contactos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `opiniones`
--
ALTER TABLE `opiniones`
  MODIFY `ID_opinion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `recompensas`
--
ALTER TABLE `recompensas`
  MODIFY `ID_recompensa` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `ID_reserva` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID_usuario` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `vuelos`
--
ALTER TABLE `vuelos`
  MODIFY `ID_vuelo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `favoritos_id_destino_foreign` FOREIGN KEY (`ID_destino`) REFERENCES `destinos` (`ID_destino`) ON DELETE CASCADE,
  ADD CONSTRAINT `favoritos_id_usuario_foreign` FOREIGN KEY (`ID_usuario`) REFERENCES `usuarios` (`ID_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `opiniones`
--
ALTER TABLE `opiniones`
  ADD CONSTRAINT `opinions_id_usuario_foreign` FOREIGN KEY (`ID_usuario`) REFERENCES `usuarios` (`ID_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `recompensas`
--
ALTER TABLE `recompensas`
  ADD CONSTRAINT `recompensas_id_usuario_foreign` FOREIGN KEY (`ID_usuario`) REFERENCES `usuarios` (`ID_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `fk_reservas_vuelos` FOREIGN KEY (`ID_vuelo`) REFERENCES `vuelos` (`ID_vuelo`) ON DELETE SET NULL,
  ADD CONSTRAINT `reservas_id_destino_foreign` FOREIGN KEY (`ID_destino`) REFERENCES `destinos` (`ID_destino`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservas_id_usuario_foreign` FOREIGN KEY (`ID_usuario`) REFERENCES `usuarios` (`ID_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `vuelos`
--
ALTER TABLE `vuelos`
  ADD CONSTRAINT `vuelos_ibfk_1` FOREIGN KEY (`ID_destino`) REFERENCES `destinos` (`ID_destino`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
