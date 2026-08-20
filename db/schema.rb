# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_19_150353) do
  create_table "bahias", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "estado", default: "disponible", null: false
    t.integer "numero", null: false
    t.string "tipo", default: "elevador", null: false
    t.datetime "updated_at", null: false
    t.index ["numero"], name: "index_bahias_on_numero", unique: true
  end

  create_table "clientes", force: :cascade do |t|
    t.string "apellido"
    t.string "correo"
    t.datetime "created_at", null: false
    t.string "direccion"
    t.string "estado", default: "activo", null: false
    t.string "nombre", null: false
    t.string "telefono"
    t.datetime "updated_at", null: false
  end

  create_table "detalles_ordenes_repuestos", force: :cascade do |t|
    t.integer "cantidad", default: 1, null: false
    t.datetime "created_at", null: false
    t.integer "orden_trabajo_id", null: false
    t.decimal "precio_unitario", precision: 10, scale: 2, null: false
    t.integer "repuesto_id", null: false
    t.datetime "updated_at", null: false
    t.index ["orden_trabajo_id"], name: "index_detalles_ordenes_repuestos_on_orden_trabajo_id"
    t.index ["repuesto_id"], name: "index_detalles_ordenes_repuestos_on_repuesto_id"
  end

  create_table "detalles_ordenes_servicios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "mecanico_id", null: false
    t.integer "orden_trabajo_id", null: false
    t.decimal "precio_aplicado", precision: 10, scale: 2, null: false
    t.integer "servicio_id", null: false
    t.datetime "updated_at", null: false
    t.index ["mecanico_id"], name: "index_detalles_ordenes_servicios_on_mecanico_id"
    t.index ["orden_trabajo_id"], name: "index_detalles_ordenes_servicios_on_orden_trabajo_id"
    t.index ["servicio_id"], name: "index_detalles_ordenes_servicios_on_servicio_id"
  end

  create_table "diagnosticos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion", null: false
    t.string "estado", default: "registrado", null: false
    t.date "fecha", null: false
    t.text "observaciones"
    t.integer "orden_trabajo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["orden_trabajo_id"], name: "index_diagnosticos_on_orden_trabajo_id", unique: true
  end

  create_table "especialidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "estado", default: "activo", null: false
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facturas", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.datetime "created_at", null: false
    t.string "estado", default: "pendiente", null: false
    t.date "fecha", null: false
    t.decimal "monto_total", precision: 10, scale: 2, null: false
    t.integer "orden_trabajo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_facturas_on_cliente_id"
    t.index ["orden_trabajo_id"], name: "index_facturas_on_orden_trabajo_id", unique: true
  end

  create_table "mecanicos", force: :cascade do |t|
    t.string "apellido"
    t.string "correo"
    t.datetime "created_at", null: false
    t.integer "especialidad_id", null: false
    t.string "estado", default: "activo", null: false
    t.string "nombre", null: false
    t.string "telefono"
    t.datetime "updated_at", null: false
    t.index ["especialidad_id"], name: "index_mecanicos_on_especialidad_id"
  end

  create_table "ordenes_mecanicos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "mecanico_id", null: false
    t.integer "orden_trabajo_id", null: false
    t.string "rol", default: "ayudante", null: false
    t.datetime "updated_at", null: false
    t.index ["mecanico_id"], name: "index_ordenes_mecanicos_on_mecanico_id"
    t.index ["orden_trabajo_id", "mecanico_id"], name: "index_ordenes_mecanicos_on_orden_trabajo_id_and_mecanico_id", unique: true
    t.index ["orden_trabajo_id"], name: "index_ordenes_mecanicos_on_orden_trabajo_id"
  end

  create_table "ordenes_trabajo", force: :cascade do |t|
    t.integer "bahia_id", null: false
    t.datetime "created_at", null: false
    t.string "estado", default: "recibida", null: false
    t.date "fecha_ingreso", null: false
    t.time "hora_ingreso", null: false
    t.integer "kilometraje_ingreso"
    t.text "motivo_ingreso"
    t.datetime "updated_at", null: false
    t.integer "vehiculo_id", null: false
    t.index ["bahia_id"], name: "index_ordenes_trabajo_on_bahia_id"
    t.index ["vehiculo_id"], name: "index_ordenes_trabajo_on_vehiculo_id"
  end

  create_table "presupuestos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "estado", default: "pendiente", null: false
    t.date "fecha", null: false
    t.decimal "monto_estimado", precision: 10, scale: 2
    t.integer "orden_trabajo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["orden_trabajo_id"], name: "index_presupuestos_on_orden_trabajo_id", unique: true
  end

  create_table "proveedores", force: :cascade do |t|
    t.string "correo"
    t.datetime "created_at", null: false
    t.string "direccion"
    t.string "estado", default: "activo", null: false
    t.string "nombre", null: false
    t.string "telefono"
    t.datetime "updated_at", null: false
  end

  create_table "repuestos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "estado", default: "activo", null: false
    t.string "marca"
    t.string "modelo_compatible"
    t.string "nombre", null: false
    t.decimal "precio", precision: 10, scale: 2, null: false
    t.integer "proveedor_id", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["proveedor_id"], name: "index_repuestos_on_proveedor_id"
  end

  create_table "servicios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "estado", default: "activo", null: false
    t.string "nombre", null: false
    t.decimal "precio_base", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "rol", default: "recepcionista", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "vehiculos", force: :cascade do |t|
    t.integer "anio"
    t.integer "cliente_id", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.string "estado", default: "activo", null: false
    t.integer "kilometraje"
    t.string "marca", null: false
    t.string "modelo", null: false
    t.string "placa", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vehiculos_on_cliente_id"
  end

  add_foreign_key "detalles_ordenes_repuestos", "ordenes_trabajo"
  add_foreign_key "detalles_ordenes_repuestos", "repuestos"
  add_foreign_key "detalles_ordenes_servicios", "mecanicos"
  add_foreign_key "detalles_ordenes_servicios", "ordenes_trabajo"
  add_foreign_key "detalles_ordenes_servicios", "servicios"
  add_foreign_key "diagnosticos", "ordenes_trabajo"
  add_foreign_key "facturas", "clientes"
  add_foreign_key "facturas", "ordenes_trabajo"
  add_foreign_key "mecanicos", "especialidades"
  add_foreign_key "ordenes_mecanicos", "mecanicos"
  add_foreign_key "ordenes_mecanicos", "ordenes_trabajo"
  add_foreign_key "ordenes_trabajo", "bahias"
  add_foreign_key "ordenes_trabajo", "vehiculos"
  add_foreign_key "presupuestos", "ordenes_trabajo"
  add_foreign_key "repuestos", "proveedores"
  add_foreign_key "sessions", "users"
  add_foreign_key "vehiculos", "clientes"
end
