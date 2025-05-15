import 'package:flutter/cupertino.dart';

class TrianglePainter extends CustomPainter {

  Size arrowSize;

  TrianglePainter(this.arrowSize);

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
        ..color = Color.fromARGB(255, 243, 243, 243)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}