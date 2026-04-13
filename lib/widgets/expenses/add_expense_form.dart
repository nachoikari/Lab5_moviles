import 'package:flutter/material.dart';

class AddExpenseForm extends StatefulWidget {
  final Future<void> Function(String descripcion, double cantidad) onAddExpense;

  const AddExpenseForm({super.key, required this.onAddExpense});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _cantidadController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _descripcionController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    final descripcion = _descripcionController.text.trim();
    final cantidad = double.parse(
      _cantidadController.text.replaceAll(',', '.'),
    );

    setState(() => _guardando = true);

    try {
      await widget.onAddExpense(descripcion, cantidad);
      _descripcionController.clear();
      _cantidadController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gasto agregado')));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el gasto')),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agregar gasto',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingrese una descripcion';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cantidadController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Cantidad',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
              onFieldSubmitted: (_) => _guardarGasto(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _guardando ? null : _guardarGasto,
              child: Text(_guardando ? 'Guardando...' : 'Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}
