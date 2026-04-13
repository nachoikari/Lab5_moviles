import 'package:flutter/material.dart';
import 'package:lab_5/models/gasto.dart';
import 'package:lab_5/widgets/expenses/expense_tile.dart';

class ExpensesList extends StatelessWidget {
  final List<Gasto> gastos;
  final bool cargando;
  final void Function(Gasto gasto) onEditExpense;
  final void Function(Gasto gasto) onDeleteExpense;

  const ExpensesList({
    super.key,
    required this.gastos,
    required this.cargando,
    required this.onEditExpense,
    required this.onDeleteExpense,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (gastos.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No hay gastos registrados')),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemCount: gastos.length,
        itemBuilder: (context, index) {
          final gasto = gastos[index];

          return ExpenseTile(
            descripcion: gasto.descripcion,
            cantidad: gasto.cantidad,
            onEdit: () => onEditExpense(gasto),
            onDelete: () => onDeleteExpense(gasto),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 2),
      ),
    );
  }
}
