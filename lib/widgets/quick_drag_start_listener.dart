import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Starts a reorder drag after a short hold — snappier than the default
/// long-press (500ms) while still leaving quick swipes free to scroll.
class QuickDragStartListener extends ReorderableDragStartListener {
  const QuickDragStartListener({
    super.key,
    required super.child,
    required super.index,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      delay: const Duration(milliseconds: 250),
      debugOwner: this,
    );
  }
}
