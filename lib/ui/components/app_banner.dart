import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onAction;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBanner({
    super.key,
    required this.message,
    required this.actionText,
    required this.onAction,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.blue.shade50;
    final txtColor = textColor ?? Colors.blue.shade900;
    final actionColor = textColor ?? Colors.blue.shade700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: bgColor,
      child: Row(
        children: [
          Icon(icon, color: actionColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16.0, // Rule §6.3: Strict 16sp
                color: txtColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 16.0, // Rule §6.3: Strict 16sp
                fontWeight: FontWeight.bold,
                color: actionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
