import 'package:flutter/material.dart';

/// Loading state — blueprint-ui.md §6 (3 state wajib).
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!, // ⚠️ JANGAN hapus `!` - field tipenya String?
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}
