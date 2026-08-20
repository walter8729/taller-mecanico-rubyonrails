# Gestión de un Taller Mecánico

El objetivo es organizar el ingreso y reparación de vehículos, controlar el uso de bahías, mecánicos y repuestos, y gestionar la facturación derivada de las reparaciones — siguiendo el flujo real de trabajo de un taller: **ingreso → diagnóstico → presupuesto → aprobación del cliente → reparación → entrega**.

El sistema permitirá:
- Gestión de clientes, vehículos, mecánicos y especialidades
- Recepción de vehículos y apertura de órdenes de trabajo
- Registro de diagnósticos
- Generación y aprobación de presupuestos
- Asignación de bahías y de uno o varios mecánicos por orden
- Control de repuestos, stock y proveedores
- Catálogo de servicios de mano de obra
- Facturación

## Entidades del Sistema

**Cliente**
- id_cliente (PK)
- nombre
- apellido
- telefono
- correo
- direccion

**Vehículo**
- id_vehiculo (PK)
- id_cliente (FK)
- placa
- marca
- modelo
- anio
- color
- kilometraje

**Especialidad**
- id_especialidad (PK)
- nombre *(ej: Mecánica general, Electricidad automotriz, Chapa y pintura, Frenos y suspensión, Diagnóstico computarizado)*
- descripcion

**Mecánico**
- id_mecanico (PK)
- nombre
- apellido
- telefono
- correo
- id_especialidad (FK)

**Bahía**
- id_bahia (PK)
- numero
- tipo *(elevador, fosa, plataforma)*
- estado

**Orden de Trabajo** *(entidad central — reemplaza el concepto de "turno")*
- id_orden (PK)
- id_vehiculo (FK)
- id_bahia (FK)
- fecha_ingreso
- hora_ingreso
- kilometraje_ingreso
- motivo_ingreso
- estado

**Orden_Mecánico** *(tabla intermedia — una orden puede tener varios mecánicos trabajando)*
- id_orden (FK)
- id_mecanico (FK)
- rol *(encargado / ayudante)*

**Diagnóstico**
- id_diagnostico (PK)
- id_orden (FK, UNIQUE)
- fecha
- descripcion
- observaciones

**Presupuesto** *(entidad nueva — no existe en un sistema de turnos médicos)*
- id_presupuesto (PK)
- id_orden (FK, UNIQUE)
- fecha
- monto_estimado
- estado

**Servicio** *(catálogo de mano de obra, independiente de repuestos)*
- id_servicio (PK)
- nombre *(ej: cambio de aceite, alineación y balanceo, cambio de pastillas de freno)*
- descripcion
- precio_base

**Detalle_Orden_Servicio**
- id_detalle (PK)
- id_orden (FK)
- id_servicio (FK)
- id_mecanico (FK)
- precio_aplicado

**Proveedor**
- id_proveedor (PK)
- nombre
- telefono
- correo
- direccion

**Repuesto**
- id_repuesto (PK)
- id_proveedor (FK)
- nombre
- marca
- modelo_compatible
- precio
- stock

**Detalle_Orden_Repuesto**
- id_detalle (PK)
- id_orden (FK)
- id_repuesto (FK)
- cantidad
- precio_unitario

**Factura**
- id_factura (PK)
- id_cliente (FK)
- id_orden (FK)
- fecha
- monto_total
- estado

## Relaciones

- Cliente (1) → (N) Vehículo
- Vehículo (1) → (N) Orden de Trabajo
- Especialidad (1) → (N) Mecánico
- Bahía (1) → (N) Orden de Trabajo
- Orden de Trabajo (N) ↔ (N) Mecánico *(vía Orden_Mecánico)*
- Orden de Trabajo (1) → (0..1) Diagnóstico
- Orden de Trabajo (1) → (0..1) Presupuesto
- Orden de Trabajo (1) → (N) Detalle_Orden_Servicio ← (N) Servicio
- Orden de Trabajo (1) → (N) Detalle_Orden_Repuesto ← (N) Repuesto
- Proveedor (1) → (N) Repuesto
- Orden de Trabajo (1) → (0..1) Factura
- Cliente (1) → (N) Factura

## Reglas del Negocio

**Recepción de vehículos**
- No se permiten órdenes en fechas futuras a más de X días *(regla configurable, opcional)*
- No hay solapamiento de bahía: una bahía solo puede tener un vehículo a la vez
- Un mecánico **sí puede** participar en varias órdenes activas en simultáneo *(a diferencia de un médico, que no puede atender dos turnos a la vez)*

**Diagnóstico**
- Solo se registra una vez que la orden está en estado "En diagnóstico" o posterior
- Un diagnóstico por orden

**Presupuesto**
- Se genera únicamente después del diagnóstico
- La reparación no puede iniciar sin un presupuesto en estado "Aprobado"
- Si el cliente rechaza el presupuesto, la orden pasa a "Cancelada"

**Repuestos**
- No se puede usar un repuesto sin stock disponible
- Al confirmar el detalle de uso, se descuenta automáticamente del stock

**Facturación**
- Solo se factura una orden en estado "Finalizada" o "Entregada"
- No se factura una orden cancelada
- El monto total = suma de servicios (mano de obra) + suma de repuestos utilizados

**Eliminaciones**
- No se eliminan entidades con dependencias activas (ej: no eliminar un repuesto usado en órdenes existentes)

## Estados del Sistema

**Estados de Orden de Trabajo**
- Recibida → vehículo ingresó, pendiente de diagnóstico
- En diagnóstico → mecánico evaluando el vehículo
- Presupuestada → diagnóstico listo, presupuesto generado, esperando aprobación del cliente
- Aprobada → cliente aprobó el presupuesto, en cola de reparación
- En reparación → trabajo en curso
- Finalizada → reparación completa, vehículo listo para retiro
- Entregada → el cliente retiró el vehículo
- Cancelada → el cliente rechazó el presupuesto o se anuló la orden

Transiciones permitidas:
- Recibida → En diagnóstico
- En diagnóstico → Presupuestada
- Presupuestada → Aprobada | Cancelada
- Aprobada → En reparación
- En reparación → Finalizada
- Finalizada → Entregada

**Estados de Presupuesto**
- Pendiente → esperando respuesta del cliente
- Aprobado → cliente autorizó la reparación
- Rechazado → cliente no autorizó la reparación

**Estados de Bahía**
- Disponible → puede asignarse a una orden
- Ocupada → tiene un vehículo actualmente en proceso
- Mantenimiento → no puede asignarse a órdenes

Regla: no se pueden crear órdenes en bahías en mantenimiento u ocupadas.

**Estados de Diagnóstico**
- Registrado → diagnóstico creado, editable
- Validado → diagnóstico revisado y finalizado, ya no editable

Regla: solo los diagnósticos registrados pueden modificarse.

**Estados de Factura**
- Pendiente → factura generada, aún no pagada
- Pagado → factura cancelada y procesada

Transiciones permitidas:
- Pendiente → Pagado

Reglas:
- No se puede eliminar una factura pagada
- Solo se pueden marcar como pagadas facturas con monto válido

**Estados de Entidades Lógicas**
Aplica a: Cliente, Vehículo, Mecánico, Especialidad, Proveedor.
- Activo → disponible para asignación y registros
- Inactivo → no participa en nuevas órdenes, pero conserva información histórica

Regla: las entidades inactivas no pueden generar nuevas órdenes, diagnósticos ni presupuestos.
