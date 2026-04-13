import 'package:flutter/material.dart';
import 'package:lab_5/models/db_helper.dart';
import 'package:lab_5/models/gasto.dart';
import 'package:lab_5/widgets/expenses/add_expense_form.dart';
import 'package:lab_5/widgets/expenses/expenses_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbHelper _dbHelper = DbHelper();
  List<Gasto> _gastos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    final gastos = await _dbHelper.gastos();

    if (!mounted) return;

    setState(() {
      _gastos = gastos;
      _cargando = false;
    });
  }

  Future<void> _agregarGasto(String descripcion, double cantidad) async {
    await _dbHelper.insertarGasto(
      Gasto(descripcion: descripcion, cantidad: cantidad),
    );
    await _cargarGastos();
  }

  Future<void> _editarGasto(
    Gasto gasto,
    String descripcion,
    double cantidad,
  ) async {
    if (gasto.id == null) return;

    await _dbHelper.actualizarGasto(
      Gasto(id: gasto.id, descripcion: descripcion, cantidad: cantidad),
    );
    await _cargarGastos();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gasto actualizado')));
  }

  Future<void> _eliminarGasto(Gasto gasto) async {
    if (gasto.id == null) return;

    await _dbHelper.eliminarGasto(gasto.id!);
    await _cargarGastos();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gasto eliminado')));
  }

  Future<void> _mostrarDialogoEditarGasto(Gasto gasto) async {
    final formKey = GlobalKey<FormState>();
    final descripcionController = TextEditingController(
      text: gasto.descripcion,
    );
    final cantidadController = TextEditingController(
      text: gasto.cantidad.toStringAsFixed(2),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar gasto'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese una descripcion';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cantidadController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    final cantidad = double.tryParse(
                      value?.replaceAll(',', '.') ?? '',
                    );

                    if (cantidad == null || cantidad <= 0) {
                      return 'Ingrese una cantidad valida';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final descripcion = descripcionController.text.trim();
                final cantidad = double.parse(
                  cantidadController.text.replaceAll(',', '.'),
                );

                Navigator.of(dialogContext).pop();
                await _editarGasto(gasto, descripcion, cantidad);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    descripcionController.dispose();
    cantidadController.dispose();
  }

  Future<void> _confirmarEliminarGasto(Gasto gasto) async {
    final eliminar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar gasto'),
          content: Text('Desea eliminar "${gasto.descripcion}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (eliminar != true || !mounted) return;

    await _eliminarGasto(gasto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gastos'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            AddExpenseForm(onAddExpense: _agregarGasto),
            ExpensesList(
              gastos: _gastos,
              cargando: _cargando,
              onEditExpense: _mostrarDialogoEditarGasto,
              onDeleteExpense: _confirmarEliminarGasto,
            ),
          ],
        ),
      ),
    );
  }
}
