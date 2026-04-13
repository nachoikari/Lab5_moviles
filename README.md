# Lab_5

Proyecto Flutter para registrar gastos usando persistencia local con **SQLite**.

## Como se implemento SQLite en la app

La aplicacion guarda los gastos en una base de datos local llamada `gastos_database.db`. Esta base de datos se crea automaticamente la primera vez que se abre la app.

La conexion y las operaciones de SQLite se manejan en `lib/models/db_helper.dart`. Este archivo centraliza todo lo relacionado con la base de datos para que la pantalla principal no tenga que escribir consultas SQL directamente.

## Modelo de datos

Cada gasto se representa con la clase `Gasto`, ubicada en `lib/models/gasto.dart`.

Un gasto tiene:

- `id`: identificador unico generado por SQLite,
- `descripcion`: texto del gasto,
- `cantidad`: monto gastado.

El modelo tambien tiene `toMap()` y `fromMap()`. Estos metodos sirven para convertir un objeto `Gasto` a un formato que SQLite puede guardar, y para convertir una fila de SQLite de vuelta a un objeto `Gasto`.

## Tabla usada

La app crea una tabla llamada `Gastos` con esta estructura:

```sql
CREATE TABLE Gastos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  descripcion TEXT NOT NULL,
  cantidad REAL NOT NULL
)
```

Cada fila de esa tabla representa un gasto guardado por el usuario.

## Operaciones implementadas

En `DbHelper` se implementaron las operaciones principales:

- `insertarGasto()`: guarda un gasto nuevo.
- `gastos()`: obtiene todos los gastos guardados.
- `actualizarGasto()`: modifica un gasto existente usando su `id`.
- `eliminarGasto()`: elimina un gasto usando su `id`.
- `eliminarTodosLosGastos()`: borra todos los gastos, util para pruebas.

## Conexion con la interfaz

La pantalla principal esta en `lib/screens/home_page.dart`.

Cuando la pantalla se abre, se llama a SQLite para cargar los gastos guardados. Luego esos datos se asignan a una lista local llamada `_gastos` usando `setState()`.

La idea principal es:

```text
SQLite guarda los datos
setState actualiza lo que se ve en pantalla
```

Por ejemplo, cuando se agrega, edita o elimina un gasto:

1. Se hace el cambio en SQLite usando `DbHelper`.
2. Se vuelve a cargar la lista desde SQLite.
3. Se llama `setState()` para refrescar la UI.

De esta forma, la app no depende de una lista temporal. Los datos quedan guardados en el dispositivo y siguen disponibles aunque se cierre la aplicacion.

## Flujo general

```text
Formulario o botones del tile
        |
        v
HomePage llama a DbHelper
        |
        v
SQLite guarda, edita, consulta o elimina
        |
        v
HomePage recarga la lista
        |
        v
setState actualiza la pantalla
```

Con esto la aplicacion tiene persistencia local completa para los gastos: agregar, listar, editar y eliminar.
