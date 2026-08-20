# Plan — Sistema de Taller Mecánico (Ruby on Rails)

## Contexto actual
- App Rails **8.1.3.1** generada originalmente en `untitled/`, renombrada a `taller_mecanico/` (Ruby 4.0.6, SQLite, Git sin commits).
- Módulo de aplicación renombrado de `Untitled` a `TallerMecanico`.
- El documento `sistema-taller-mecanico-desde-cero.md` es la fuente de requisitos.

## Decisiones cerradas
- **Login con roles**: `admin` / `recepcionista` / `mecanico` (generador de autenticación de Rails 8 + enum `rol` en `User`).
- **Ubicación**: app existente renombrada a `taller_mecanico/`.
- **Entrega**: por fases incrementales.
- **Estética**: CSS propio simple (sin Bootstrap).
- **Stock**: **no se repone** al cancelar una orden con repuestos consumidos.
- **Enums**: valores como string con helpers de Active Record (p. ej. `enum :estado, { recibida: "recibida" }`).
- **Eliminación**: borrado lógico (estado `inactivo`) para entidades maestras; FK protegidas con `dependent: :restrict_with_error`.
- **IDE**: RubyMine (los comandos se lanzan desde ahí; en consola usar `ruby bin/rails ...` en Windows/PowerShell).
- **IDIOMA**: toda la UI y los mensajes en español (`config.i18n.default_locale = :es`).

## Modelo de datos (mapeo del doc a convenciones Rails)

| Tabla | Campos clave | Estado/enum |
|---|---|---|
| `clientes` | nombre, apellido, telefono, correo, direccion | activo/inactivo |
| `vehiculos` | cliente_id, placa, marca, modelo, anio, color, kilometraje | activo/inactivo |
| `especialidades` | nombre, descripcion | activo/inactivo |
| `mecanicos` | nombre, apellido, telefono, correo, especialidad_id | activo/inactivo |
| `bahias` | numero, tipo (elevador/fosa/plataforma) | disponible/ocupada/mantenimiento |
| `ordenes_trabajo` | vehiculo_id, bahia_id, fecha_ingreso, hora_ingreso, kilometraje_ingreso, motivo_ingreso | recibida → entregada/cancelada |
| `ordenes_mecanicos` | orden_trabajo_id, mecanico_id, rol (encargado/ayudante) | — |
| `diagnosticos` | orden_trabajo_id (único), fecha, descripcion, observaciones | registrado/validado |
| `presupuestos` | orden_trabajo_id (único), fecha, monto_estimado | pendiente/aprobado/rechazado |
| `servicios` | nombre, descripcion, precio_base | activo/inactivo |
| `detalles_ordenes_servicios` | orden_trabajo_id, servicio_id, mecanico_id, precio_aplicado | — |
| `proveedores` | nombre, telefono, correo, direccion | activo/inactivo |
| `repuestos` | proveedor_id, nombre, marca, modelo_compatible, precio, stock | activo/inactivo |
| `detalles_ordenes_repuestos` | orden_trabajo_id, repuesto_id, cantidad, precio_unitario | — |
| `facturas` | cliente_id, orden_trabajo_id, fecha, monto_total | pendiente/pagada |

Relaciones clave: `OrdenTrabajo` es el centro → `has_one :diagnostico, :presupuesto, :factura`, `has_many :mecanicos` vía `OrdenMecanico`, `has_many :servicios/:repuestos` vía los detalles.

## Estados

- **Orden de Trabajo**: `recibida` → `en_diagnostico` → `presupuestada` → `aprobada` | `cancelada` → `en_reparacion` → `finalizada` → `entregada`.
- **Presupuesto**: `pendiente` / `aprobado` / `rechazado`.
- **Bahía**: `disponible` / `ocupada` / `mantenimiento`.
- **Diagnóstico**: `registrado` / `validado`.
- **Factura**: `pendiente` / `pagada`.
- **Entidades lógicas** (Cliente, Vehículo, Mecánico, Especialidad, Proveedor, Servicio, Repuesto): `activo` / `inactivo`.

## Reglas de negocio clave

- Bahía disponible al crear la orden; se ocupa desde la recepción y se libera al `entregada`/`cancelada`.
- Transiciones de orden validadas con métodos Ruby + enum (sin gem extra).
- A `en_reparacion` solo con presupuesto `aprobado`; presupuesto rechazado → orden `cancelada`.
- Diagnóstico único por orden, solo desde `en_diagnostico`; editable solo en `registrado`.
- Presupuesto único por orden, solo tras diagnóstico.
- Detalles de repuestos solo con orden en `aprobada`/`en_reparacion`; validación `stock >= cantidad` y descuento automático al crear el detalle.
- Factura solo para órdenes `finalizada`/`entregada`; `monto_total` calculado (servicios + repuestos), no editable.
- No eliminar entidades con dependencias activas.

## Fases

- **Fase 0 — Base y autenticación**: `rails generate authentication`, enum `rol` en `User`, locales `es.yml`, seeds con admin, CSS propio, permisos por rol.
- **Fase 1 — Migraciones + modelos**: las 15 tablas, índices únicos, FK con `restrict_with_error`, relaciones y enums.
- **Fase 2 — Reglas de negocio**: transiciones de orden, stock, cálculo de factura, borrado lógico.
- **Fase 3 — CRUD catálogos**: Cliente, Vehículo, Especialidad, Mecánico, Bahía, Servicio, Proveedor, Repuesto + permisos.
- **Fase 4 — Flujo de órdenes**: recepción, panel de órdenes, transiciones, diagnóstico, presupuesto, aprobación/rechazo.
- **Fase 5 — Facturación**: generar factura desde orden finalizada/entregada, marcar pago, dashboard simple.
- **Fase 6 — Semillas, pruebas y pulido**: `seeds.rb` demo, tests de modelo (Minitest), `bin/rails test` y `bin/rubocop`.

## Comandos útiles (Windows / PowerShell)
- `ruby bin/rails server` — lanzar servidor (o usar el run configuration de RubyMine).
- `ruby bin/rails generate ...`
- `ruby bin/rails db:migrate`
- `ruby bin/rails db:seed`
- `ruby bin/rails test`
- `ruby bin/rubocop`