import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:asatic/data/utils/app_constants.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;

  @override
  Path getClip(Size size) => Path()
    ..relativeLineTo(0, 0.45.sw)
    ..quadraticBezierTo(size.width / 2, 0.6.sw, size.width, 0.45.sw)
    ..relativeLineTo(0, -0.6.sw)
    ..close();
}

// CustomPainter class to for the header curved-container
class HeaderCurvedContainer extends CustomPainter {
  BuildContext context;
  HeaderCurvedContainer({
    required this.context,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Constants.secondryDarkCol;
    Path path = Path()
      ..relativeLineTo(0, 0.45.sw)
      ..quadraticBezierTo(size.width / 2, 0.6.sw, size.width, 0.45.sw)
      ..relativeLineTo(0, -0.6.sw)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
