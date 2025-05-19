import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.white12;

    final heightLine = 80;
    final widthLine = 80;

    for (int i = 1; i < height; i++) {
      if (i % heightLine == 0) {
        Path linePath = Path();
        linePath.addRect(
          Rect.fromLTRB(0, i.toDouble(), width, (i + 2).toDouble()),
        );
        canvas.drawPath(linePath, paint);
      }
    }
    for (int i = 1; i < width; i++) {
      if (i % widthLine == 0 || i == 1) {
        Path linePath = Path();
        linePath.addRect(
          Rect.fromLTRB(i.toDouble(), 0, (i + 2).toDouble(), height),
        );
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}