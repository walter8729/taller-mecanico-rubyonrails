# skill.md — Habilidades y buenas prácticas del proyecto

Resumen de las habilidades técnicas y patrones que se aplican en este repositorio. Útil como referencia rápida para quien (o lo que) desarrolle sobre esta base.

## Ruby
- Ruby 4.0.6. Código idiomático: `rubocop-rails-omakase` como guía de estilo.
- Preferir `&.` safe navigation, `tap`, `find_by`/`where`, bloques de un línea cuando aplique. Sin comentarios innecesarios en el código.

## Rails 8.1
- **Autenticación**: usar el generador `rails generate authentication` (crea `User`, `Session`, `Current`, `Authentication` concern, bcrypt, `User.authenticate_by`, reset de contraseña). Roles vía enum en `User`.
- **Enums**: declarar con valores string para legibilidad y estabilidad de datos:
  ```ruby
  enum :estado, { pendiente: "pendiente", aprobado: "aprobado", rechazado: "rechazado" }
  ```
  Genera helpers `pendiente?`, `aprobado!`, `pendiente!`, scopes, etc.
- **Validaciones**: `validates` declarativo en el modelo; `uniqueness` con `conditions` si es necesario filtrar. Mensajes de error en español vía `config/locales/es.yml`.
- **`dependent`**: usar `:restrict_with_error` cuando borrar el padre no debe eliminar datos con historial (facturas, detalles, órdenes). Cuidado con `:dependent` combinado con `has_many :through`.
- **Transacciones**: reglas que tocan varias tablas (p. ej. descontar stock + crear detalle) dentro de `ActiveRecord::Base.transaction`.
- **SQLite** para dev; no usar funciones específicas de Postgres.
- **Hotwire**: Turbo Frames/Streams y Stimulus para interacción sin JS pesado; importmap, sin bundler de JS.

## Modelado de negocio
- Estados de Orden de Trabajo como enum + métodos de transición con validaciones, sin gemas de state machine.
- Cálculos derivados (monto de factura) en el modelo, no en vistas ni controladores.
- Borrado lógico con `estado: inactivo` en entidades maestras.
- Stock: validación de disponibilidad + descuento automático al registrar consumo; política definida: no se repone al cancelar.

## Vistas / UI
- ERB con helpers de Rails; CSS propio simple en `app/assets/stylesheets/application.css` (y archivos específicos si crecen).
- Todo en español: labels, placeholders, botones, títulos, mensajes.

## Testing
- Minitest. Prioridad en `test/models/`:
  - validaciones de presencia/uniqueness
  - transiciones válidas e inválidas de OrdenTrabajo
  - descuento de stock
  - cálculo de `monto_total` de Factura
- Correr con `ruby bin/rails test`. Lint con `ruby bin/rubocop`.

## Flujo de trabajo
1. Modelos y migraciones primero (esquema estable), luego reglas, luego vistas.
2. Verificar con tests + rubocop al cerrar cada fase.
3. Trabajar por fases (ver `plan_inicial.md`).