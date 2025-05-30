import 'package:flutter/cupertino.dart';

class UserPositionUtils {
  static void centerInitialPosition(
    BuildContext context,
    TransformationController transformationController,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final viewportSize = renderBox.size;

    final contentWidth = viewportSize.width * 10;
    final contentHeight = viewportSize.height * 3;

    final centerX = (contentWidth - viewportSize.width) / 2;
    final centerY = (contentHeight - viewportSize.height) / 2;

    transformationController.value =
        Matrix4.identity()..translate(-centerX, -centerY);
  }

  static Rect getVisibleContentRect(
    TransformationController transformationController,
  ) {
    final Matrix4 matrix = transformationController.value;
    final double scaleX = matrix.getColumn(0).x;
    final double scaleY = matrix.getColumn(1).y;
    final double translateX = matrix.getTranslation().x;
    final double translateY = matrix.getTranslation().y;

    final double viewportWidth = Size(1, 1).width;
    final double viewportHeight = Size(1, 1).height;

    final double visibleLeft = -translateX / scaleX;
    final double visibleTop = -translateY / scaleY;
    final double visibleRight = visibleLeft + viewportWidth / scaleX;
    final double visibleBottom = visibleTop + viewportHeight / scaleY;

    return Rect.fromLTRB(visibleLeft, visibleTop, visibleRight, visibleBottom);
  }
}
