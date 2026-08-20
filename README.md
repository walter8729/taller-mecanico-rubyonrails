# Taller Mecánico

Sistema de gestión para talleres mecánicos: control del ingreso y reparación de vehículos, uso de bahías, asignación de mecánicos, diagnóstico, presupuestos, repuestos y facturación.

El flujo real del taller se replica de punta a punta: **ingreso → diagnóstico → presupuesto → aprobación del cliente → reparación → entrega → factura**.

## Funcionalidades

- **Autenticación con roles**: `admin`, `recepcionista` y `mecanico` con permisos diferenciados.
- **Catálogos**: clientes, vehículos, especialidades, mecánicos, bahías, servicios de mano de obra, proveedores y repuestos (con control de stock).
- **Órdenes de trabajo**: recepción de vehículos, asignación de bahía y mecánicos, seguimiento del estado en el tiempo.
- **Diagnóstico**: registro único por orden, editable hasta validarse.
- **Presupuesto**: generación tras el diagnóstico, aprobación o rechazo por el cliente.
- **Reparación**: alta de servicios y repuestos por orden; el stock se descuenta automáticamente.
- **Facturación**: factura generada solo para órdenes finalizadas/entregadas, con monto total calculado (servicios + repuestos).
- **Dashboard**: resumen de órdenes activas, bahías ocupadas, facturas pendientes y alertas de stock bajo.

## Stack tecnológico

| Capa | Tecnología |
|---|---|
| Lenguaje | Ruby 4.0.6 |
| Framework | Ruby on Rails 8.1.3.1 |
| Base de datos | SQLite (desarrollo) |
| Frontend | Hotwire (Turbo + Stimulus), importmap, CSS propio |
| Autenticación | Generador de auth de Rails 8 (User/Session + bcrypt) |
| Tests | Minitest (Rails default) |
| Lint | RuboCop (`rubocop-rails-omakase`) |

## Modelo de datos

`OrdenTrabajo` es la entidad central y conecta todo el flujo:

- `has_one` : `Diagnostico`, `Presupuesto`, `Factura`
- `has_many` : `OrdenMecanico` (mecánicos vía tabla intermedia con rol encargado/ayudante), `DetalleOrdenServicio`, `DetalleOrdenRepuesto`

Tablas: `clientes`, `vehiculos`, `especialidades`, `mecanicos`, `bahias`, `ordenes_trabajo`, `ordenes_mecanicos`, `diagnosticos`, `presupuestos`, `servicios`, `detalles_ordenes_servicios`, `proveedores`, `repuestos`, `detalles_ordenes_repuestos`, `facturas`, `users`, `sessions`.

## Estados del sistema

**Orden de trabajo**: `recibida` → `en_diagnostico` → `presupuestada` → `aprobada` | `cancelada` → `en_reparacion` → `finalizada` → `entregada`.

**Presupuesto**: `pendiente` / `aprobado` / `rechazado` — la reparación solo inicia con presupuesto aprobado.

**Bahía**: `disponible` / `ocupada` / `mantenimiento` — se ocupa al recepcionar y se libera al entregar o cancelar.

**Diagnóstico**: `registrado` (editable) / `validado` (fijo).

**Factura**: `pendiente` / `pagada` — no se puede eliminar una factura pagada.

**Entidades lógicas** (Clientes, Vehículos, Mecánicos, Especialidades, Proveedores, Servicios, Repuestos): `activo` / `inactivo` (borrado lógico, conserva el historial).

## Reglas de negocio clave

- No se crean órdenes en bahías ocupadas o en mantenimiento.
- Transiciones de estado validadas en el modelo (sin gemas de state machine).
- Diagnóstico y presupuesto únicos por orden.
- El stock se descuenta al registrar el detalle de repuesto; no se puede usar un repuesto sin stock.
- El `monto_total` de la factura se calcula (servicios + repuestos) y nunca se edita a mano.
- El stock **no se repone** al cancelar una orden con repuestos consumidos.

## Requisitos

- Ruby 4.0.6 (ver `.ruby-version`)
- Rails 8.1.3.1
- Bundler
- SQLite 3

## Puesta en marcha

```bash
bundle install
ruby bin/rails db:setup      # crea la BD y carga migraciones + semillas
ruby bin/rails server        # http://localhost:3000
```

> En Windows/PowerShell usar siempre `ruby bin/rails ...` (no `bin/rails` directo).

### Usuarios de demostración (seeds)

| Rol | Email | Contraseña |
|---|---|---|
| Admin | `admin@taller.local` | `admin123` |
| Recepcionista | `recepcion@taller.local` | `recepcion123` |
| Mecánico | `mecanico@taller.local` | `mecanico123` |

Los seeds cargan catálogos de ejemplo y 5 órdenes en distintos puntos del ciclo de vida (facturada, en reparación, presupuestada, recibida y cancelada) para explorar el sistema con datos realistas.

## Tests

```bash
ruby bin/rails test       # suite completa (122 tests, Minitest)
ruby bin/rubocop          # lint (sin ofensas)
```

Los tests cubren validaciones y reglas de negocio (`test/models/`), los CRUD de catálogos y el flujo completo de órdenes/facturación (`test/controllers/`).

## Estructura de carpetas

```
taller_mecanico/
├── app/
│   ├── controllers/   # catálogos + flujo (órdenes, diagnóstico, presupuesto, facturas)
│   ├── models/        # reglas de negocio
│   ├── views/         # vistas en español, CSS propio
│   └── assets/stylesheets/application.css
├── config/routes.rb   # rutas anidadas del flujo de órdenes
├── db/
│   ├── migrate/       # migraciones de las 15 tablas
│   └── seeds.rb       # datos demo + usuarios
├── test/              # fixtures, tests de modelos y controllers
├── AGENTS.md          # guía de convenciones para agentes
└── skill.md
```

## Notas

- Toda la interfaz y los mensajes están en **español** (`config.i18n.default_locale = :es`).
- El proyecto está pensado para ejecutarse localmente con SQLite; el código usa solo tipos y consultas estándar de Active Record, por lo que migrar a PostgreSQL se reduce a cambiar el adapter en `config/database.yml` y regenerar la base (`db:schema:load` + `db:seed`).