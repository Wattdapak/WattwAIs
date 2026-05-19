import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
//import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/app_chrome.dart';
//import 'package:wattwais/screens/dashboard.dart';
//import '../widgets/bottom_nav.dart';
import '../widgets/screenscaffold.dart';
// import 'package:wattwais/widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _notifications = true;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Text(
              'J',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Julo Bretaña',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Iloilo City · Ileco',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 26),
          const Row(
            children: [
              Expanded(
                child: _ProfileMetric(value: '₱5.2k', label: 'SAVED'),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _ProfileMetric(value: '1,840', label: 'KWH'),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _ProfileMetric(value: '42d', label: 'STREAK'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          WattCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const _SettingsRow(
                  icon: Icons.credit_card_rounded,
                  title: 'Billing & rates',
                  trailing: '₱8.00 / kWh',
                ),
                _SettingsRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  trailing: _notifications ? 'On' : 'Off',
                  onTap: () => setState(() => _notifications = !_notifications),
                ),
                const _SettingsRow(
                  icon: Icons.shield_outlined,
                  title: 'Privacy',
                ),
                const _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.mutedBorder, width: 1.2),
              fixedSize: const Size.fromHeight(56),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            '⚡ WattwAIs · v1.0.0',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return WattCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: context.sectionLabel.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                IconBubble(icon: icon),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, color: AppColors.mutedBorder),
        ],
      ),
    );
  }
}

