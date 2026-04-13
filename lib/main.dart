import 'package:flutter/material.dart';
import 'package:lab_5/models/db_helper.dart';
import 'package:lab_5/models/gasto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DbHelper();

  print('=== Start database test ===');

  try {
    await dbHelper.eliminarTodosLosGastos();
    print('Table cleaned');

    final id1 = await dbHelper.insertarGasto(
      Gasto(
        descripcion: 'Lunch',
        cantidad: 3500.0,
      ),
    );
    print('Inserted expense 1 with id: $id1');

    final id2 = await dbHelper.insertarGasto(
      Gasto(
        descripcion: 'Bus ticket',
        cantidad: 650.0,
      ),
    );
    print('Inserted expense 2 with id: $id2');

    final expenses = await dbHelper.gastos();

    print('=== Expenses in database ===');
    for (final expense in expenses) {
      print(expense);
    }

    print('Total expenses: ${expenses.length}');
    print('=== End database test ===');
  } catch (e, stackTrace) {
    print('Database error: $e');
    print(stackTrace);
  }


  runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
