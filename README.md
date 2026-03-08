# pokedex-swiftui

Aplicación desarrollada en SwiftUI que consume la API pública PokeAPI para mostrar información de Pokémon.

## Tecnologías

- SwiftUI
- MVVM
- Repository Pattern
- Dependency Injection
- URLSession
- Async/Await
- Clean Architecture (Data / Domain / Presentation)

## Funcionalidades

- Listado de Pokémon
- Detalle de Pokémon
- Carga de imágenes desde la API
- Consumo de API REST (PokeAPI)
- Búsqueda de Pokémon por nombre o número
- Filtro de Pokémon por tipo
- Chips visuales de tipos con color dinámico
- Paginación / infinite scroll
- Pull to refresh
- Manejo de estados de carga y error

## Arquitectura

La aplicación sigue una arquitectura basada en **MVVM + Repository Pattern**, separando responsabilidades en diferentes capas para mejorar mantenibilidad, testabilidad y escalabilidad.

### Capas

**Presentation**
- SwiftUI Views
- ViewModels

Responsable de la UI y estado de la aplicación.

**Domain**
- Protocolos de repositorio
- Modelos de dominio

Define contratos de negocio independientes de la capa de datos.

**Data**
- Services
- Repository implementations
- Networking

Encargado de consumir APIs y transformar datos.

### Inyección de dependencias

Se utiliza un `AppContainer` para centralizar la creación de dependencias y desacoplar las capas del sistema.

## Instalación
1. Clonar el repositorio
2. Abrir el proyecto en Xcode
3. Ejecutar en simulador o dispositivo
