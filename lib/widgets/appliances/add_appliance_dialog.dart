import 'package:flutter/material.dart';

import '../../models/appliance_template.dart';
import '../../data/appliance_templates.dart';

class AddApplianceDialog extends StatefulWidget {
  const AddApplianceDialog({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.wattsController,
    required this.quantityController,
    required this.hoursController,
    required this.daysController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController wattsController;
  final TextEditingController quantityController;
  final TextEditingController hoursController;
  final TextEditingController daysController;

  final Future<void> Function() onSubmit;

  @override
  State<AddApplianceDialog> createState() => _AddApplianceDialogState();
}

class _AddApplianceDialogState extends State<AddApplianceDialog> {
  ApplianceTemplate? selectedTemplate;

  void _applyTemplate(ApplianceTemplate template) {
    widget.nameController.text = template.name;
    widget.wattsController.text = template.defaultWatts.toString();
    widget.quantityController.text = template.defaultQuantity.toString();
    widget.hoursController.text = template.defaultHoursPerDay.toString();
    widget.daysController.text = template.defaultDaysPerWeek.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Appliance'),
      content: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ApplianceTemplate?>(
                initialValue: selectedTemplate,
                decoration: const InputDecoration(
                  labelText: 'Choose from list',
                ),
                items: [
                  const DropdownMenuItem<ApplianceTemplate?>(
                    value: null,
                    child: Text('Custom'),
                  ),
                  ...applianceTemplates.map(
                    (template) => DropdownMenuItem<ApplianceTemplate?>(
                      value: template,
                      child: Text(template.name),
                    ),
                  ),
                ],
                onChanged: (template) {
                  setState(() {
                    selectedTemplate = template;
                  });
                  if (template == null) return;
                  _applyTemplate(template);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: widget.nameController,
                decoration: const InputDecoration(
                  labelText: 'Appliance Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter appliance name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: widget.wattsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Watts',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Qty',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: widget.hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hrs/day',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: widget.daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Days/week',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await widget.onSubmit();
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
