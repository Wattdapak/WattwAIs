import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
import '../../models/appliance_model.dart';
import 'package:wattwais/widgets/app_chrome.dart';

import 'package:wattwais/widgets/appliances/quantity_stepper.dart';
import 'package:wattwais/widgets/appliances/value_pill.dart';

class ApplianceInventoryCard extends StatelessWidget {
  const ApplianceInventoryCard({
    super.key,
    required this.appliance,
    required this.onChanged,
    required this.onDelete,
  });

  final ApplianceModel appliance;
  final ValueChanged<ApplianceModel> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return WattCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconBubble(
                icon: appliance.icon,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      appliance.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${appliance.watts}W · '
                      '${appliance.hoursPerDay}h/day · '
                      '×${appliance.quantity}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip:
                    'Remove ${appliance.name}',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: QuantityStepper(
                  value: appliance.quantity,
                  onChanged: (value) {
                    onChanged(
                      appliance.copyWith(
                        quantity: value,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ValuePill(
                  label: 'Watts',
                  value: '${appliance.watts}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ValuePill(
                  label: 'Hrs/day',
                  value:
                      '${appliance.hoursPerDay}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ValuePill(
                  label: 'days/wk',
                  value:
                      '${appliance.daysPerWeek}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}