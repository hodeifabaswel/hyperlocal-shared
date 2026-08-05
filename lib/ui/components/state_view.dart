import 'package:flutter/material.dart';
import 'loading_indicator.dart';
import 'error_empty_state.dart';

enum ViewState { normal, loading, error, empty }

class StateView extends StatelessWidget {
  final ViewState state;
  final Widget? child;
  final String errorMessage; // Required - tidak ada default spesifik konteks
  final String emptyMessage; // Required - tidak ada default spesifik konteks
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateView({
    super.key,
    required this.state,
    required this.errorMessage,
    required this.emptyMessage,
    this.child,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return const LoadingIndicator();

      case ViewState.error:
        return ErrorEmptyState(
          icon: Icons.error_outline, // ← FIX: parameter required
          message: errorMessage,
          actionLabel: actionLabel ?? 'Coba Lagi',
          onAction: onAction,
        );

      case ViewState.empty:
        return ErrorEmptyState(
          icon: Icons.inbox_outlined, // ← FIX: parameter required
          message: emptyMessage,
          // Empty state biasanya tanpa action button
        );

      case ViewState.normal:
        return child ?? const SizedBox.shrink();
    }
  }
}
