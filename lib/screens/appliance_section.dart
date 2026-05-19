import 'package:flutter/material.dart';

import '../../data/appliance_templates.dart';
import '../../models/appliance_model.dart';
import '../../models/appliance_template.dart';

import '../../widgets/appliances/appliance_chip.dart';
import '../../widgets/appliances/appliance_inventory_card.dart';

class ApplianceSection extends StatelessWidget {
  const ApplianceSection({
    super.key,
    required this.appliances,
    required this.onAddTemplate,
    required this.onAddManual,
    required this.onEdit,
    required this.onDelete,
    required this.onChanged,
  });

  final List<ApplianceModel> appliances;
  final ValueChanged<ApplianceTemplate> onAddTemplate;
  final VoidCallback onAddManual;
  final ValueChanged<ApplianceModel> onEdit;
  final ValueChanged<String> onDelete;
  final ValueChanged<ApplianceModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title and add button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Appliances',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FilledButton.icon(
              onPressed: onAddManual,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        //list of appliance templates
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: applianceTemplates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final template = applianceTemplates[index];
              final selected = appliances.any((a) => a.name == template.name);

              return ApplianceChip(
                appliance: template,
                selected: selected,
                onTap: () => onAddTemplate(template),
              );
            },
          ),
        ),

        const SizedBox(height: 18),

        //inventory list
        if (appliances.isEmpty)
          const Text('No saved appliances yet.')
        else
          ...appliances.map(
            (model) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => onEdit(model),
                child: ApplianceInventoryCard(
                  appliance: model,
                  onChanged: onChanged,
                  onDelete: () => onDelete(model.id),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
