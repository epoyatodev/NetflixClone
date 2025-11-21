# NetflixClone

Clone sencillo de la interfaz de Netflix creado con **UIKit** y **Core Data**.

> Aplicación de ejemplo para demostrar navegación, listas, búsqueda y persistencia local mediante Core Data.

---

## Capturas

Home:

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/2b294f58-98d8-49be-ac12-0196294b66ad" />

Upcoming:

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/c6abae52-faec-4313-bd84-60704f4cc029" />

Search (lista + resultados):

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/9eb81406-22a2-447e-b868-9718885cf54f" />

Search (grid resultados):

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/2d35ca62-bef3-49e8-9dfc-503b1a161350" />

Downloads:

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/07ffab26-b3f7-4e11-adc3-b4b690ac18f7" />

Detalle de película:

<img width="517" height="982" alt="image" src="https://github.com/user-attachments/assets/f18ca9b9-3409-46e3-a519-47016163aaa3" />

---

## Tecnologías

* UIKit
* Core Data (persistencia local)
* **async/await** para peticiones de red y operaciones asíncronas
* SDWebImage para la carga y caché de imágenes
* Auto Layout
* Swift

---

## Características

* Pantalla principal con carrusel / cabecera destacada.
* Sección "Trending / Upcoming" con filas horizontales.
* Buscador con resultados en lista y cuadrícula.
* Descargas: lista de contenido marcado como descargado (persistido en Core Data).
* Pantalla de detalle de cada título con descripción y acciones (descargar, reproducir).
* Navegación con `UITabBarController` (Home, Upcoming, Search, Downloads).

---

## Requisitos

* Xcode (versión compatible con tu proyecto)
* iOS SDK (objetivo configurado en el proyecto)
* Swift (versión incluida en el proyecto)

---

## Instalación y uso

1. Clona el repositorio:

```bash
git clone <URL_DEL_REPO>
cd NetflixClone
```

2. Abre el proyecto con Xcode:

```bash
open NetflixClone.xcodeproj
```

3. Compila y ejecuta en el simulador o dispositivo.

> Si la app incluye un seeding automático para datos de ejemplo, al primer arranque se poblarán los títulos. Si no, utiliza el flujo de la app (Search / Trending) para probar la UI.

---

## Core Data

* El modelo `CoreData` se encuentra en el proyecto (archivo `.xcdatamodeld`).
* Entidades principales: `Title` (o similar) con atributos como `id`, `name`, `overview`, `posterPath`, `isDownloaded`.
* Para depuración, puedes borrar la base de datos eliminando el contenedor persistente desde el simulador (Reset Content and Settings) o implementando un helper de borrado en el proyecto.

---

## Estructura del proyecto

La estructura real del proyecto es la siguiente:

```
NetflixClone/
├─ App/
│  ├─ AppDelegate.swift
│  └─ SceneDelegate.swift
├─ Controllers/
│  ├─ Core/
│  └─ General/
├─ Managers/
│  ├─ Info/
│  ├─ Network/
│  └─ DataPersistentManager.swift
├─ Models/
│  ├─ TrendingTitleResponse.swift
│  └─ YoutubeSearchResponse.swift
├─ Resources/
├─ ViewModels/
├─ Views/
├─ Assets/
├─ Info/
├─ LaunchScreen/
└─ NetflixCloneModel/

Package Dependencies:
└─ SDWebImage

```

