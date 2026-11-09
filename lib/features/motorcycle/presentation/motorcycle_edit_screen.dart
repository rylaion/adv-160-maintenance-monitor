import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/date_utils.dart';
import '../domain/motorcycle.dart';
import 'motorcycle_view_model.dart';

/// Form to edit the motorcycle profile.
class MotorcycleEditScreen extends ConsumerStatefulWidget {
  const MotorcycleEditScreen({super.key});

  @override
  ConsumerState<MotorcycleEditScreen> createState() =>
      _MotorcycleEditScreenState();
}

class _MotorcycleEditScreenState extends ConsumerState<MotorcycleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _plate = TextEditingController();
  final _chassis = TextEditingController();
  final _engine = TextEditingController();
  DateTime? _purchaseDate;
  String? _photoPath;
  Motorcycle? _original;

  @override
  void initState() {
    super.initState();
    final m = ref.read(primaryMotorcycleProvider).valueOrNull;
    if (m != null) {
      _original = m;
      _brand.text = m.brand;
      _model.text = m.model;
      _year.text = '${m.modelYear}';
      _plate.text = m.plateNumber ?? '';
      _chassis.text = m.chassisNumber ?? '';
      _engine.text = m.engineNumber ?? '';
      _purchaseDate = m.purchaseDate;
      _photoPath = m.photoPath;
    }
  }

  @override
  void dispose() {
    for (final c in [_brand, _model, _year, _plate, _chassis, _engine]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final stored = await ref
        .read(motorcycleEditViewModelProvider.notifier)
        .storePhoto(file.path);
    if (mounted) setState(() => _photoPath = stored);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? now,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (d != null) setState(() => _purchaseDate = d);
  }

  Future<void> _save() async {
    final original = _original;
    if (original == null || !_formKey.currentState!.validate()) return;
    final ok = await ref.read(motorcycleEditViewModelProvider.notifier).save(
          Motorcycle(
            id: original.id,
            brand: _brand.text,
            model: _model.text,
            modelYear: int.parse(_year.text.trim()),
            plateNumber: _plate.text,
            chassisNumber: _chassis.text,
            engineNumber: _engine.text,
            purchaseDate: _purchaseDate,
            photoPath: _photoPath,
          ),
        );
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save changes')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(motorcycleEditViewModelProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Motorcycle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Align(
              child: OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.photo_outlined),
                label: Text(_photoPath == null ? 'Add photo' : 'Change photo'),
              ),
            ),
            const SizedBox(height: 16),
            _field(_brand, 'Brand',
                validator: (v) => MotorcycleValidator.requiredText(v, 'Brand')),
            _field(_model, 'Model',
                validator: (v) => MotorcycleValidator.requiredText(v, 'Model')),
            _field(_year, 'Model year',
                keyboard: TextInputType.number,
                validator: MotorcycleValidator.modelYear),
            _field(_plate, 'Plate number'),
            _field(_chassis, 'Chassis number'),
            _field(_engine, 'Engine number'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Purchase date'),
              subtitle: Text(_purchaseDate == null
                  ? 'Not set'
                  : AppDates.formatDate(_purchaseDate!)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: saving ? null : _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {String? Function(String?)? validator, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        validator: validator,
      ),
    );
  }
}
