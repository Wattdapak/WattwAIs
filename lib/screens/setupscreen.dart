import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/app_chrome.dart';
//import 'package:wattwais/screens/dashboard.dart';
//import '../widgets/bottom_nav.dart';
import '../widgets/screenscaffold.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    super.key,
    required this.appliances,
    required this.isPredicting,
    required this.onBack,
    required this.onAdd,
    required this.onChange,
    required this.onDelete,
    required this.onPredict,
  });

  final List<Appliance> appliances;
  final bool isPredicting;
  final VoidCallback onBack;
  final ValueChanged<Appliance> onAdd;
  final void Function(int index, Appliance appliance) onChange;
  final ValueChanged<int> onDelete;
  final VoidCallback onPredict;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Stack(
        children: [
          ScreenScaffold(
            withBottomPadding: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: onBack,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF161D25),
                        fixedSize: const Size(54, 54),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    ),
                    const Expanded(
                      child: Text(
                        'Setup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 64),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Tell us about your home', style: context.titleLarge),
                const SizedBox(height: 12),
                const Text(
                  "We'll predict your next bill with AI.",
                  style: TextStyle(color: AppColors.muted, fontSize: 14),
                ),
                const SizedBox(height: 24),
                const _SetupInputs(),
                const SizedBox(height: 22),
                Text('ADD APPLIANCE', style: context.sectionLabel),
                const SizedBox(height: 14),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: defaultAppliances.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final item = defaultAppliances[index];
                      return ApplianceChip(
                        appliance: item,
                        selected: appliances.any(
                          (entry) => entry.name == item.name,
                        ),
                        onTap: () => onAdd(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'INVENTORY · ${appliances.length}',
                  style: context.sectionLabel,
                ),
                const SizedBox(height: 16),
                if (appliances.isEmpty)
                  const EmptyInventoryCard()
                else
                  ...appliances.indexed.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ApplianceInventoryCard(
                        appliance: entry.$2,
                        onChanged: (value) => onChange(entry.$1, value),
                        onDelete: () => onDelete(entry.$1),
                      ),
                    ),
                  ),
                const SizedBox(height: 112),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.page,
            right: AppSpacing.page,
            bottom: 34,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: isPredicting
                  ? const _PredictingBar()
                  : PrimaryPillButton(
                      label: 'Predict my bill',
                      icon: Icons.auto_fix_high_rounded,
                      onPressed: onPredict,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupInputs extends StatelessWidget {
  const _SetupInputs();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MockInput(label: 'LAST BILL (₱)', value: '₱ 2400'),
        ),
        SizedBox(width: 18),
        Expanded(
          child: _MockInput(label: 'RATE / KWH', value: '₱ 8'),
        ),
      ],
    );
  }
}

class _MockInput extends StatelessWidget {
  const _MockInput({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.sectionLabel.copyWith(fontSize: 13)),
        const SizedBox(height: 14),
        Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xFF0F151B),
            borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
            border: Border.all(color: AppColors.mutedBorder, width: 1.3),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class ApplianceChip extends StatelessWidget {
  const ApplianceChip({
    super.key,
    required this.appliance,
    required this.selected,
    required this.onTap,
  });

  final Appliance appliance;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Add ${appliance.name}',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 102,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF102338) : const Color(0xFF10171D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? AppColors.blue : AppColors.mutedBorder,
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(appliance.icon, color: AppColors.cyan, size: 29),
              const SizedBox(height: 12),
              Text(
                appliance.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplianceInventoryCard extends StatelessWidget {
  const ApplianceInventoryCard({
    super.key,
    required this.appliance,
    required this.onChanged,
    required this.onDelete,
  });

  final Appliance appliance;
  final ValueChanged<Appliance> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return WattCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconBubble(icon: appliance.icon, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      '${appliance.watts}W · ${appliance.hoursPerDay}h/day · ×${appliance.quantity}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove ${appliance.name}',
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
                child: _QuantityStepper(
                  value: appliance.quantity,
                  onChanged: (value) =>
                      onChanged(appliance.copyWith(quantity: value)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ValuePill(label: 'Watts', value: '${appliance.watts}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ValuePill(
                  label: 'Hrs/day',
                  value: '${appliance.hoursPerDay}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        border: Border.all(color: AppColors.mutedBorder, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _RoundIconButton(
            icon: Icons.remove_rounded,
            onTap: () => onChanged(math.max(1, value - 1)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Qty',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          _RoundIconButton(
            icon: Icons.add_rounded,
            color: AppColors.cyan,
            foreground: AppColors.ink,
            onTap: () => onChanged(math.min(12, value + 1)),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF151D25),
    this.foreground = AppColors.text,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: foreground, size: 22),
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  const _ValuePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        border: Border.all(color: AppColors.mutedBorder, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class EmptyInventoryCard extends StatelessWidget {
  const EmptyInventoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const WattCard(
      child: Row(
        children: [
          IconBubble(icon: Icons.add_home_work_outlined),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Choose appliances above to build an accurate home profile.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 16,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictingBar extends StatelessWidget {
  const _PredictingBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('predicting'),
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.ink,
            ),
          ),
          SizedBox(width: 14),
          SkeletonLine(width: 138, height: 20, radius: 10),
        ],
      ),
    );
  }
}
