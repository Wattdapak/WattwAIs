import 'package:flutter/material.dart';
import '../../models/appliance_model.dart';
import '../../models/appliance_template.dart';
import 'appliance_chip.dart';
import 'appliance_inventory_card.dart';
import '../../data/appliance_templates.dart';

class ApplianceSection extends StatelessWidget {
  const ApplianceSection({
    super.key,
    required this.appliances,
    required this.onAddTemplate,
    required this.onAddManual,
    required this.onDelete,
    required this.onChanged,
  });

  final List<ApplianceModel> appliances;
  final ValueChanged<ApplianceTemplate> onAddTemplate;
  final VoidCallback onAddManual;
  final ValueChanged<String> onDelete;
  final ValueChanged<ApplianceModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Appliances',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FilledButton.icon(
              onPressed: onAddManual,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: applianceTemplates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final template = applianceTemplates[index];
              final selected = appliances.any((a) => a.name == template.name);
              return ApplianceChip(
                appliance: template,
                selected: selected,
                onTap: () {
                  if (!selected) {
                    onAddTemplate(template);
                  } else {
                    final existing = appliances.where((a) => a.name == template.name);
                    if (existing.isNotEmpty) {
                      onDelete(existing.first.id);
                    }
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        if (appliances.isEmpty)
          const Text(
            'No saved appliances yet.',
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        else
          ...appliances.map(
            (model) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ApplianceInventoryCard(
                appliance: model,
                onChanged: onChanged,
                onDelete: () => onDelete(model.id),
              ),
            ),
          ),
      ],
    );
  }
}
