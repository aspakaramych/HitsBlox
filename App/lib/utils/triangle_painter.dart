import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {

  Size arrowSize;
  Color color;

  TrianglePainter(this.arrowSize, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(arrowSize.width, arrowSize.height / 2);
    path.lineTo(0, arrowSize.height);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}