# Proveo - Flutter Web App

Esta es una app web hecha con Flutter para ver la interfaz de Proveo en el navegador.

## Requisitos

- Flutter instalado en tu equipo
- Un navegador como Edge o Chrome
- Acceso a la red para cargar los recursos del proyecto

## Instalar dependencias

Desde la carpeta del proyecto, ejecuta:

```bash
flutter pub get
```

## Correr la app localmente

Para levantar la aplicación web y verla en el navegador, ejecuta:

```bash
flutter run -d edge --web-port=8080
```

Si el puerto 8080 está ocupado, puedes usar otro puerto:

```bash
flutter run -d edge --web-port=8081
```

## Ver la app

Una vez que el comando responda, abre en tu navegador:

- http://localhost:8080

Si usaste otro puerto, abre ese puerto en su lugar.

## Si quieres detener la app

En la terminal donde está corriendo, presiona:

```bash
Ctrl + C
```

## Nota

La app ya está preparada para funcionar como una interfaz de prueba/prototipo de Proveo, y también incluye integración básica con Supabase cuando la configuración esté disponible.
