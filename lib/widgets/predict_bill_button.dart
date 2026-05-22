import 'package:flutter/material.dart';

class PredictBillButton extends StatelessWidget {
  const PredictBillButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF1792E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color( 0xFF1792E8,)
            .withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        child: isLoading ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
            ),
        )
        : const Text('Predict Bill'),
      ),
    );
  }
}