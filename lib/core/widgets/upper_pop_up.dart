import 'package:flutter/material.dart';

class UpperPopup<T> extends StatelessWidget {
  const UpperPopup({
    super.key,
    required this.child,
    required this.itemBuilder,
    required this.onSelected,
    this.tooltip,
    this.shape,
    this.offset,
    this.enabled = true,
  });

  final Widget child;
  final PopupMenuItemBuilder<T> itemBuilder;
  final ValueChanged<T> onSelected;

  final String? tooltip;
  final ShapeBorder? shape;
  final Offset? offset;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: enabled,
      tooltip: tooltip,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      offset: offset ?? const Offset(0, kToolbarHeight),
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      child: child,
    );
  }
}
