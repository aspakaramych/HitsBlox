import 'package:flutter/material.dart';

class BezierLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  BezierLinePainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    Offset startCopy = start;
    Offset endCopy = end;

    final controlPoint1 = Offset(startCopy.dx + 50, startCopy.dy);
    final controlPoint2 = Offset(endCopy.dx - 50, endCopy.dy);

    path.moveTo(startCopy.dx, startCopy.dy);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endCopy.dx,
      endCopy.dy,
    );

    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
