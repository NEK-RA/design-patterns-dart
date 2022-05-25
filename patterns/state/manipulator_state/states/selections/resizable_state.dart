import 'package:flutter/material.dart';

import 'children/marker_state.dart';
import 'selection_state.dart';

import '../../shapes/shape.dart';

class MarkerState extends ManipulationState with HoverStateMixin {
  final SelectionState parentState;
  final Shape markerShape;
  final MouseCursor hoverCursor;

  MarkerState({
    required double x,
    required double y,
    required this.hoverCursor,
    required this.parentState,
  }) : markerShape = MarkerShape(x, y);

  factory MarkerState.topLeft(SelectionState parentState) {
    return MarkerState(
      x: parentState.selectedShape.x,
      y: parentState.selectedShape.y,
      hoverCursor: SystemMouseCursors.resizeUpLeft,
      parentState: parentState,
    ).._name = 'MarkerState.topLeft';
  }

  factory MarkerState.topRight(SelectionState parentState) {
    return MarkerState(
      x: parentState.selectedShape.x + parentState.selectedShape.width,
      y: parentState.selectedShape.y,
      hoverCursor: SystemMouseCursors.resizeUpRight,
      parentState: parentState,
    ).._name = 'MarkerState.topRight';
  }

  factory MarkerState.bottomRight(SelectionState parentState) {
    return MarkerState(
      x: parentState.selectedShape.x + parentState.selectedShape.width,
      y: parentState.selectedShape.y + parentState.selectedShape.height,
      hoverCursor: SystemMouseCursors.resizeDownRight,
      parentState: parentState,
    ).._name = 'MarkerState.bottomRight';
  }

  factory MarkerState.bottomLeft(SelectionState parentState) {
    return MarkerState(
      x: parentState.selectedShape.x,
      y: parentState.selectedShape.y + parentState.selectedShape.height,
      hoverCursor: SystemMouseCursors.resizeDownLeft,
      parentState: parentState,
    ).._name = 'MarkerState.bottomLeft';
  }

  @override
  void onHover() {
    context.cursor = hoverCursor;
  }

  @override
  void onMouseLeave() {
    context.cursor = SystemMouseCursors.basic;
  }

  void render(Canvas canvas) {
    markerShape.paint(canvas);
  }

  @override
  ManipulationContext get context => parentState.context;

  @override
  Shape? findShapeByCoordinates(double x, double y) {
    final rect = Rect.fromLTWH(
      markerShape.x - markerShape.width,
      markerShape.y - markerShape.width,
      markerShape.width * 2,
      markerShape.width * 2,
    );
    return rect.contains(Offset(x, y)) ? markerShape : null;
  }

  @override
  void paint(Canvas canvas) {
    parentState.paint(canvas);
  }

  String _name = 'MarkerState';

  @override
  String toString() {
    return _name;
  }
}

class ResizableState extends SelectionState {
  late final MarkerState markerState;

  late final List<MarkerState> _markers;

  ResizableState({required super.selectedShape}) {
    _markers = [
      MarkerState.topLeft(this),
      MarkerState.topRight(this),
      MarkerState.bottomRight(this),
      MarkerState.bottomLeft(this),
    ];
  }

  @override
  void mouseMove(double x, double y) {
    super.mouseMove(x, y);

    for (final marker in _markers) {
      marker.mouseMove(x, y);
      if (marker.isHover) {
        return;
      }
    }
  }

  @override
  void paint(Canvas canvas) {
    super.paint(canvas);

    for (final marker in _markers) {
      marker.render(canvas);
    }
  }

  @override
  String toString() {
    return 'Resizable State + ${super.toString()}';
  }
}
