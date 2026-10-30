# Laboratorio de Propiedades ACID en PostgreSQL (Chinook DB)

Este repositorio contiene los scripts de prueba para demostrar el manejo de transacciones, recuperación ante errores y visibilidad de datos bajo el estándar ACID utilizando la base de datos **Chinook** en **PostgreSQL 16**.

## 📌 Configuración e Importación
- **Motor:** PostgreSQL 16
- **Base de datos:** Chinook (Esquema relational `SerialPKs`)
- **Nivel de Aislamiento:** `Read Committed` (predeterminado en PostgreSQL)
- **Modo de Ejecución:** Manual mediante `BEGIN`, `COMMIT` y `ROLLBACK` (desactivando el comportamiento autocommit implícito).

## 📁 Contenido del Repositorio
1. `01_venta_exitosa.sql`: Transacción completa de venta con recálculo dinámico del total y confirmación permanente (`COMMIT`).
2. `02_rollback_total.sql`: Demostración de atomicidad al inducir un fallo por clave foránea (`FK constraint`) y reversión total (`ROLLBACK`).
3. `03_savepoint.sql`: Recuperación parcial de errores en transacciones complejas utilizando puntos de restauración (`SAVEPOINT`).
4. `04_validaciones.sql`: Pruebas de visibilidad entre sesiones independientes (Conexión A y Conexión B) para validar el aislamiento de datos.

## 🚀 Guía de Ejecución
1. Abrir **pgAdmin 4** y conectarse a la base de datos `chinook`.
2. Ejecutar los scripts en orden correlativo (`01` al `04`) dentro del Query Tool.
3. Para la prueba `04_validaciones.sql`, abrir dos ventanas independientes del Query Tool para simular la Conexión A y la Conexión B.