# Microservicio de Clientes - FactuMarket

Microservicio para la gestión de clientes del sistema de facturación electrónica, implementado con Ruby on Rails 7 siguiendo principios de Clean Architecture.

## 🏗️ Arquitectura

Este microservicio implementa **Clean Architecture** con las siguientes capas:

```
┌─────────────────────────────────────┐
│   Presentación (Controllers)        │  ← API REST con MVC
├─────────────────────────────────────┤
│   Aplicación (Use Cases)            │  ← Lógica de aplicación
├─────────────────────────────────────┤
│   Dominio (Entities, Validators)    │  ← Lógica de negocio
├─────────────────────────────────────┤
│   Infraestructura (Repositories)    │  ← Acceso a datos
└─────────────────────────────────────┘
```

![Diagrama de la arquitectura](diagrama.png)

## 📁 Estructura de Carpetas

```
app/
├── controllers/api/v1/          # Capa de Presentación (MVC)
├── use_cases/clientes/          # Capa de Aplicación
├── domain/
│   ├── entities/                # Entidades de dominio
│   ├── repositories/            # Interfaces de repositorios
│   └── validators/              # Validadores de negocio
└── infrastructure/
    ├── repositories/            # Implementaciones de repositorios
    └── http/                    # Clientes HTTP
```

## 🚀 Tecnologías

- **Ruby**: 3.2.2
- **Rails**: 7.1.0
- **Base de datos**: Oracle (transaccional)
- **Comunicación**: HTTP REST (HTTParty)
- **Testing**: RSpec

## 📋 Prerequisitos

- Ruby 3.2.2
- Oracle Database (XE 21c o superior)
- Oracle Instant Client
- Bundler
- Docker

## ⚙️ Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/mariaabonilla11/clients-service-app
cd clients-service-app
```

### 2. Copiar la carpeta instantclient_linux

Se debe descomprimir el archivo instantclient_linux.zip y ubicar la carpeta instantclient_linux dentro de clients-service-app

### 3. Ejecutar imagen y correr contenedor 🐳

### Construir imagen

```bash
cd clients-service-app
docker compose up --build
```

### 3. Configurar variables de entorno

```bash
Si se desea cambiar las credenciales de Oracle cambiar credenciales en docker-compose.yml y config/database.yml
```

El servicio estará disponible en `http://IPLOCAL:3000`

## Colección de Postman

Puedes importar la colección de Postman desde este archivo:
[📥 Descargar colección de Postman](./Microservices.postman_collection.json)

## 📡 API Endpoints

### Crear Cliente

```http
POST /api/v1/clients
Content-Type: application/json

{
  "name": "Empresa Test S.A.",
  "identification": "900123456-7",
  "type_identification": "NIT",
  "email": "contacto@empresatest.com",
  "address": "Calle 123 # 45-67"
}
```

**Respuesta exitosa (201)**:

```json
{
  "message": "Cliente creado exitosamente",
  "data": {
    "id": 1,
    "name": "Empresa Test S.A.",
    "identification": "900123456-7",
    "type_identification": "NIT",
    "email": "contacto@empresatest.com",
    "address": "Calle 123 # 45-67",
    "state": "active",
    "created_at": "2024-11-05T10:30:00Z",
    "updated_at": "2024-11-05T10:30:00Z"
  }
}
```

### Consultar Cliente por ID

```http
GET /api/v1/clients/1
```

**Respuesta exitosa (200)**:

```json
{
  "data": {
    "id": 1,
    "name": "Empresa Test S.A.",
    "identification": "900123456-7",
    "type_identification": "NIT",
    "email": "contacto@empresatest.com",
    "address": "Calle 123 # 45-67",
    "state": "active",
    "created_at": "2024-11-05T10:30:00Z",
    "updated_at": "2024-11-05T10:30:00Z"
  }
}
```

### Listar Clientes

```http
GET /api/v1/clients
```

**Respuesta exitosa (200)**:

```json
{
  "data": [
    {
      "id": 1,
      "name": "Empresa Test S.A.",
      ...
    },
    {
      "id": 2,
      "name": "Otra Empresa S.A.S.",
      ...
    }
  ],
  "count": 2
}
```

## 🧪 Testing

### Ejecutar todos los tests

```bash
bundle exec rspec
```

### Ejecutar tests específicos

```bash
# Tests de entidades
bundle exec rspec spec/domain/entities/

# Tests de use cases
bundle exec rspec spec/use_cases/

# Test específico
bundle exec rspec spec/domain/entities/client_spec.rb
```

### Cobertura de tests

```bash
bundle exec rspec --format documentation
```

## 🔗 Dependencias con otros Microservicios

Este microservicio se comunica con:

- **Auditoría Service** (`http://localhost:3003`): Para registrar eventos de creación y consulta de clientes

## 📊 Flujo de Datos

1. **Request HTTP** → Controller (`ClientsController`)
2. **Controller** → Use Case (`CreateClient`, `FindClient`, `ListClients`)
3. **Use Case** → Domain Entity (`Client`) + Validator
4. **Use Case** → Repository (`OracleClientRepository`)
5. **Repository** → Base de datos Oracle
6. **Use Case** → HTTP Client (`AuditService`)
7. **Response** ← Controller

## 🎯 Principios Aplicados

### Clean Architecture

- ✅ Separación en capas (Presentación, Aplicación, Dominio, Infraestructura)
- ✅ Regla de dependencias (capas internas no conocen las externas)
- ✅ Entidades de dominio puras sin dependencias de framework

### MVC

- ✅ Controllers manejan requests HTTP
- ✅ Models representan datos persistentes
- ✅ Serialización de respuestas JSON

### SOLID

- ✅ Single Responsibility: cada clase tiene una única responsabilidad
- ✅ Dependency Inversion: use cases dependen de abstracciones (interfaces)
- ✅ Interface Segregation: repositorios con métodos específicos

## 🛡️ Validaciones de Negocio

- Nombre: mínimo 3 caracteres, máximo 200
- Identificación: mínimo 5 caracteres, máximo 50, única
- Email: formato válido, máximo 100 caracteres
- Tipo de identificación: NIT, CC, CE, PASAPORTE
- Estado: activo, inactivo, suspendido

## 🔧 Manejo de Errores

El servicio maneja los siguientes errores:

- **422 Unprocessable Entity**: Datos inválidos o reglas de negocio no cumplidas
- **404 Not Found**: Cliente no encontrado
- **400 Bad Request**: Parámetros faltantes
- **500 Internal Server Error**: Errores del sistema

## 📝 Registro de Auditoría

Cada operación genera un evento en el servicio de auditoría:

- `client.create`: Cuando se crea un cliente
- `client.read`: Cuando se consulta un cliente
- `client.list`: Cuando se listan clientes

## 🚦 Health Check

```http
GET /health
```

Respuesta: `200 OK`

## 👥 Autor

Maria Bonilla
