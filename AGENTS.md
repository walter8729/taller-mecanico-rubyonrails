# AGENTS.md

Guía para agentes (IA o humanos) que trabajan en el proyecto **Taller Mecánico**.

## Proyecto
Sistema de gestión de un taller mecánico: clientes, vehículos, órdenes de trabajo, diagnóstico, presupuestos, repuestos, servicios y facturación. Documento de requisitos fuente: `sistema-taller-mecanico-desde-cero.md` (un nivel arriba de la raíz del proyecto).

## Stack
- Ruby 4.0.6 (`ruby-4.0.6`)
- Rails 8.1.3.1
- SQLite (base por defecto)
- Hotwire (Turbo + Stimulus), importmap, jbuilder
- Auth: generador de autenticación de Rails 8 (User/Session/Current + bcrypt)
- Tests: Minitest (framework por defecto)
- Lint: RuboCop `rubocop-rails-omakase`

## Comandos (Windows / PowerShell)
`bin/rails` no se ejecuta directo en PowerShell; usar `ruby bin/rails`:

- `ruby bin/rails server` — servidor (o el run configuration de RubyMine)
- `ruby bin/rails generate authentication`
- `ruby bin/rails generate migration/model/controller ...`
- `ruby bin/rails db:migrate` / `db:seed` / `db:setup`
- `ruby bin/rails test` — suite de tests
- `ruby bin/rubocop` — lint

## Convenciones
- **Idioma**: toda la UI, mensajes, labels y validaciones en español. No usar tildes en identificadores de código (`nombre`, `telefono`, `direccion`, `anio`, `mecanico`).
- **Nombres de tablas/modelos**: en español, snake_case plural en tablas (p. ej. `ordenes_trabajo`, `OrdenTrabajo`).
- **FK**: siempre `*_id` (convención Rails): `cliente_id`, `vehiculo_id`, `orden_trabajo_id`, etc.
- **Enums**: valores string con helpers, ej. `enum :estado, { recibida: "recibida", aprobada: "aprobada" }`. Usar `_?`/`_!` generados.
- **Transiciones de orden**: implementar como métodos en el modelo `OrdenTrabajo` (p. ej. `marcar_en_reparacion!`) con validaciones previas; NO usar gemas de state machine.
- **Eliminación**: borrado lógico vía estado `inactivo` para entidades maestras; `dependent: :restrict_with_error` en FK con dependencias activas. No usar `destroy` para datos con historial.
- **`monto_total` de Factura**: calculado en el modelo (suma de servicios + repuestos), nunca editable desde el form.
- **Stock**: descontar automáticamente al crear un `DetalleOrdenRepuesto` (validando stock previo). **No reponer** stock al cancelar órdenes.
- **CSS**: CSS propio en `app/assets/stylesheets/`, sin frameworks de UI.
- **Tests**: cubrir validaciones y reglas de negocio en `test/models/`; transiciones y cálculo de factura como prioridad.

## Arquitectura
- MVC estándar Rails. Modelos delgados pero con reglas de negocio en el modelo (no en controladores).
- `OrdenTrabajo` es la entidad central: `has_one :diagnostico, :presupuesto, :factura`, `has_many :mecanicos` vía `OrdenMecanico`, `has_many :servicios`/`:repuestos` vía detalles.
- Permisos por rol: helpers en `ApplicationController` + `before_action` (admin todo; recepcionista clientes/vehículos/órdenes/facturas; mecánico diagnóstico/presupuesto/reparación).

## Notas RubyMine
- El IDE se abre sobre `taller_mecanico/`. Usar run configurations de Rails server / console en lugar de comandos manuales cuando sea posible.
- Tras renombrar el módulo a `TallerMecanico`, RubyMine puede requerir reindexar (Invalidate Caches si aparecen símbolos viejos `Untitled`).