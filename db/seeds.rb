# Semillas del sistema de taller mecánico (idempotente).
# Cargar con: ruby bin/rails db:seed  (borra datos previos y regenera)

puts "Limpiando datos previos..."
OrdenMecanico.delete_all
DetalleOrdenRepuesto.delete_all
DetalleOrdenServicio.delete_all
Factura.delete_all
Presupuesto.delete_all
Diagnostico.delete_all
OrdenTrabajo.delete_all
Repuesto.delete_all
Servicio.delete_all
Proveedor.delete_all
Mecanico.delete_all
Bahia.delete_all
Especialidad.delete_all
Vehiculo.delete_all
Cliente.delete_all
User.delete_all

puts "Creando usuarios..."
admin = User.create!(email_address: "admin@taller.local", password: "admin123", password_confirmation: "admin123", rol: :admin)
recepcion = User.create!(email_address: "recepcion@taller.local", password: "recepcion123", password_confirmation: "recepcion123", rol: :recepcionista)
User.create!(email_address: "mecanico@taller.local", password: "mecanico123", password_confirmation: "mecanico123", rol: :mecanico)

puts "Creando catálogos..."
especialidades = {
  "Mecánica general" => "Motores, frenos y suspensión",
  "Electricidad" => "Sistema eléctrico y electrónico del vehículo",
  "Chapa y pintura" => "Reparación de carrocería y pintura"
}.map { |nombre, desc| Especialidad.create!(nombre: nombre, descripcion: desc) }

mecanica_general = especialidades[0]
electricidad = especialidades[1]

mecanicos = [
  { especialidad: mecanica_general, nombre: "Carlos", apellido: "López" },
  { especialidad: mecanica_general, nombre: "Jorge", apellido: "Ramírez" },
  { especialidad: electricidad, nombre: "Miguel", apellido: "Torres" }
].map { |m| Mecanico.create!(m) }

bahias = (1..4).map { |n| Bahia.create!(numero: n, tipo: n <= 2 ? :elevador : (n == 3 ? :fosa : :plataforma)) }

servicios = [
  { nombre: "Cambio de aceite", descripcion: "Cambio de aceite y filtro", precio_base: 1500 },
  { nombre: "Alineación y balanceo", descripcion: "Alineación de dirección y balanceo de ruedas", precio_base: 2500 },
  { nombre: "Diagnóstico eléctrico", descripcion: "Escaneo y diagnóstico de fallas eléctricas", precio_base: 3000 },
  { nombre: "Cambio de pastillas de freno", descripcion: "Reemplazo de pastillas delanteras", precio_base: 4000 },
  { nombre: "Cambio de batería", descripcion: "Reemplazo de batería 12V", precio_base: 3500 }
].map { |s| Servicio.create!(s) }

proveedores = [
  { nombre: "Repuestos del Centro", telefono: "425-1000", correo: "ventas@repcentro.com", direccion: "Av. Central 150" },
  { nombre: "Autopartes Express", telefono: "425-2000", correo: "contacto@autopartesex.com", direccion: "Calle 25 N° 300" }
].map { |p| Proveedor.create!(p) }

repuestos = [
  { proveedor: proveedores[0], nombre: "Filtro de aceite", marca: "Fram", modelo_compatible: "Corolla 2015+", precio: 200, stock: 15 },
  { proveedor: proveedores[0], nombre: "Aceite 10W-40 (1L)", marca: "Castrol", modelo_compatible: "General", precio: 350, stock: 40 },
  { proveedor: proveedores[1], nombre: "Pastillas de freno delanteras", marca: "Bendix", modelo_compatible: "Corolla 2015+", precio: 800, stock: 6 },
  { proveedor: proveedores[1], nombre: "Batería 12V 60Ah", marca: "Moura", modelo_compatible: "General", precio: 4500, stock: 5 },
  { proveedor: proveedores[1], nombre: "Bujía NGK", marca: "NGK", modelo_compatible: "General", precio: 300, stock: 2 }
].map { |r| Repuesto.create!(r) }

puts "Creando clientes y vehículos..."
clientes = [
  { nombre: "Juan", apellido: "Pérez", telefono: "300-111-2233", correo: "juan.perez@mail.com", direccion: "Calle 10 N° 5-20" },
  { nombre: "María", apellido: "Gómez", telefono: "300-222-3344", correo: "maria.gomez@mail.com", direccion: "Cra 8 N° 15-80" },
  { nombre: "Pedro", apellido: "Sánchez", telefono: "300-333-4455", correo: "pedro.sanchez@mail.com", direccion: "Av. Siempre Viva 742" },
  { nombre: "Lucía", apellido: "Fernández", telefono: "300-444-5566", correo: "lucia.fernandez@mail.com", direccion: "Calle 3 N° 12-45" }
].map { |c| Cliente.create!(c) }

vehiculos = [
  { cliente: clientes[0], placa: "ABC-123", marca: "Toyota", modelo: "Corolla", anio: 2018, color: "Rojo", kilometraje: 45000 },
  { cliente: clientes[0], placa: "DEF-456", marca: "Mazda", modelo: "CX-5", anio: 2020, color: "Gris", kilometraje: 30000 },
  { cliente: clientes[1], placa: "GHI-789", marca: "Ford", modelo: "Fiesta", anio: 2019, color: "Azul", kilometraje: 52000 },
  { cliente: clientes[2], placa: "JKL-012", marca: "Chevrolet", modelo: "Onix", anio: 2021, color: "Blanco", kilometraje: 15000 },
  { cliente: clientes[3], placa: "MNO-345", marca: "Nissan", modelo: "Versa", anio: 2017, color: "Negro", kilometraje: 61000 }
].map { |v| Vehiculo.create!(v) }

puts "Creando órdenes de trabajo con su ciclo de vida..."

# Orden 1: ciclo completo facturado y pagado
o1 = OrdenTrabajo.create!(
  vehiculo: vehiculos[0], bahia: bahias[0],
  fecha_ingreso: 5.days.ago.to_date, hora_ingreso: "08:30", kilometraje_ingreso: 45000,
  motivo_ingreso: "Cambio de aceite y revisión general"
)
o1.transicionar_a!(:en_diagnostico)
o1.build_diagnostico(fecha: 5.days.ago.to_date, descripcion: "Requiere cambio de aceite, filtro y revisión de frenos.", observaciones: "Pastillas delanteras con 40% de desgaste.").save!
o1.diagnostico.validar!
o1.build_presupuesto(fecha: 5.days.ago.to_date, monto_estimado: 3400).save!
o1.presupuesto.aprobar!
o1.ordenes_mecanicos.create!(mecanico: mecanicos[0], rol: :encargado)
o1.detalles_ordenes_servicios.create!(servicio: servicios[0], mecanico: mecanicos[0], precio_aplicado: 1500)
o1.detalles_ordenes_repuestos.create!(repuesto: repuestos[0], cantidad: 1)
o1.detalles_ordenes_repuestos.create!(repuesto: repuestos[1], cantidad: 4)
o1.transicionar_a!(:en_reparacion)
o1.finalizar!
o1.transicionar_a!(:entregada)
Factura.create!(orden_trabajo: o1, fecha: 2.days.ago.to_date).pagar!

# Orden 2: en reparación (activa)
o2 = OrdenTrabajo.create!(
  vehiculo: vehiculos[2], bahia: bahias[1],
  fecha_ingreso: 2.days.ago.to_date, hora_ingreso: "10:00", kilometraje_ingreso: 52000,
  motivo_ingreso: "Ruido en frenos delanteros"
)
o2.transicionar_a!(:en_diagnostico)
o2.build_diagnostico(fecha: 2.days.ago.to_date, descripcion: "Pastillas de freno delanteras desgastadas.", observaciones: "").save!
o2.diagnostico.validar!
o2.build_presupuesto(fecha: 2.days.ago.to_date, monto_estimado: 2400).save!
o2.presupuesto.aprobar!
o2.ordenes_mecanicos.create!(mecanico: mecanicos[1], rol: :encargado)
o2.detalles_ordenes_servicios.create!(servicio: servicios[3], mecanico: mecanicos[1], precio_aplicado: 4000)
o2.detalles_ordenes_repuestos.create!(repuesto: repuestos[2], cantidad: 1)
o2.transicionar_a!(:en_reparacion)

# Orden 3: presupuestada esperando aprobación
o3 = OrdenTrabajo.create!(
  vehiculo: vehiculos[3], bahia: bahias[2],
  fecha_ingreso: 1.day.ago.to_date, hora_ingreso: "14:00", kilometraje_ingreso: 15000,
  motivo_ingreso: "Batería descargada frecuentemente"
)
o3.transicionar_a!(:en_diagnostico)
o3.build_diagnostico(fecha: 1.day.ago.to_date, descripcion: "Batería sin carga suficiente, requiere reemplazo.", observaciones: "").save!
o3.diagnostico.validar!
o3.build_presupuesto(fecha: 1.day.ago.to_date, monto_estimado: 4800).save!

# Orden 4: recibida (ingreso)
o4 = OrdenTrabajo.create!(
  vehiculo: vehiculos[1], bahia: bahias[3],
  fecha_ingreso: Date.today, hora_ingreso: "09:00", kilometraje_ingreso: 30000,
  motivo_ingreso: "Vibración en el volante"
)

# Orden 5: cancelada (presupuesto rechazado)
o5 = OrdenTrabajo.create!(
  vehiculo: vehiculos[4], bahia: bahias[0],
  fecha_ingreso: 3.days.ago.to_date, hora_ingreso: "11:30", kilometraje_ingreso: 61000,
  motivo_ingreso: "Falla eléctrica intermitente"
)
o5.transicionar_a!(:en_diagnostico)
o5.build_diagnostico(fecha: 3.days.ago.to_date, descripcion: "Falla en alternador, requiere cambio.", observaciones: "Pieza de alto costo.").save!
o5.diagnostico.validar!
o5.build_presupuesto(fecha: 3.days.ago.to_date, monto_estimado: 9500).save!
o5.presupuesto.rechazar!

puts "Semillas cargadas."
puts "Usuarios: admin@taller.local / admin123 | recepcion@taller.local / recepcion123 | mecanico@taller.local / mecanico123"
