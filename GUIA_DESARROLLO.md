# 📚 Guía de Desarrollo - Life Avenue

## 1️⃣ Resumen del Proyecto
Life Avenue es una aplicación Flutter orientada a la gestión y descubrimiento de eventos, con funcionalidades de registro de usuarios, visualización de calendario, RSVP, chat grupal y un sistema de membresías.

El desarrollo se ha enfocado en:
- Crear una experiencia fluida para los usuarios desde un **splash screen** inicial hasta la gestión completa de eventos.
- Usar **Flutter + Dart** con persistencia local en **SQLite**.
- Establecer una paleta de colores corporativa basada en tonos rojos.

---

## 2️⃣ Estructura de Carpetas

```
life_avenue/
 ├── assets/                # Imágenes y recursos gráficos
 │   ├── logo.png
 │   └── Imagen1.png
 ├── lib/
 │   ├── main.dart           # Punto de entrada de la app
 │   ├── screens/            # Pantallas principales
 │   │   ├── splash_screen.dart
 │   │   ├── welcome_screen.dart
 │   │   ├── calendar_screen.dart
 │   │   ├── discover_screen.dart
 │   │   ├── my_profile_screen.dart
 │   │   ├── my_events_screen.dart
 │   │   ├── membership_screen.dart
 │   │   └── ...
 │   ├── models/             # Modelos de datos
 │   └── db/                 # Lógica de persistencia SQLite
 ├── pubspec.yaml            # Configuración de dependencias y assets
 ├── README.md               # Descripción del proyecto
 └── .gitignore              # Archivos y carpetas ignoradas por Git
```

---

## 3️⃣ Lineamientos de diseño

- **Colores principales**:
  - Rojo principal: `RGB(208, 58, 44)`
  - Rojo secundario: `RGB(207, 57, 43)`
  - Rojo oscuro: `RGB(205, 53, 39)`
- **Tipografía**:
  - Fuente por defecto de Flutter (Material Design)
  - Botones con texto blanco sobre fondo rojo cuando se requiere contraste

---

## 4️⃣ Pantallas implementadas

| Pantalla              | Funcionalidad principal |
|----------------------|-------------------------|
| SplashScreen         | Muestra logo y nombre de la app antes de la pantalla de bienvenida |
| WelcomeScreen        | Botón de inicio que lleva a registro o selección de gustos |
| CalendarScreen       | Muestra eventos en un calendario interactivo |
| DiscoverScreen       | Descubre eventos cercanos |
| EventDetailScreen    | Detalle de un evento específico |
| MyProfileScreen      | Muestra y permite editar datos del usuario |
| MyEventsScreen       | Lista de eventos creados y RSVP del usuario |
| MembershipScreen     | Información y gestión de membresía |
| CheckInScreen        | Registro de asistencia a eventos |

---

## 5️⃣ Base de Datos
- Implementada con `sqflite` y `path_provider`.
- Tablas:
  - `events` → guarda eventos creados
  - `users` → guarda datos de usuario (futura implementación)
- Funciones CRUD ya disponibles para eventos.

---

## 6️⃣ Próximos pasos
1. Integrar **registro y login** con persistencia.
2. Mejorar **Membership** para mostrar beneficios dinámicos.
3. Conectar con base de datos remota (LAMP/Hostinger).
4. Implementar notificaciones push.
5. Mejorar UI con imágenes de eventos.

---

## 7️⃣ Notas importantes
- El `pubspec.yaml` debe tener bien declarados los assets:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/logo.png
    - assets/Imagen1.png
```
- Para compilar en Android:  
```bash
flutter build apk --release
```
- Para correr en emulador:
```bash
flutter run
```
