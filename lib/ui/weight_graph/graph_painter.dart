import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets_weight_graph/constants/colors.dart';
import 'package:pets_weight_graph/models/pet/pet.dart';

const List<String> months = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class GraphPainter extends CustomPainter {
  Pet pet;
  BuildContext context;
  var _max; //maximum weight
  var _min; //minimum weight
  var _y; //Y Labels
  var _x; //X Labels

  GraphPainter(this.pet, this.context);

  static double border = 10.0; //take into consideration Labels space

  //paints
  final Paint linePaint = Paint()
    ..strokeWidth = 6.0
    ..style = PaintingStyle.stroke
    ..color = AppColors.GREEN;

  //styles
  final TextStyle labelStyle = TextStyle(
      color: Color(0xFF979797), fontSize: 15, fontWeight: FontWeight.w600);

  @override
  void paint(Canvas canvas, Size size) {
    _init();

    //reduces the region of the screen that future draw operations can write to
    var _width = MediaQuery.of(context).size.width > size.width
        ? MediaQuery.of(context).size.width - 10
        : size.width;
    final clipRect = Rect.fromLTWH(0, 0, _width, size.height);
    canvas.clipRect(clipRect);
    //change canvas background color
    canvas.drawPaint(Paint()..color = Theme.of(context).colorScheme.primary);

    //calculate drawable graph width and height
    final drawableHeight = size.height - border;
    final drawableWidth = size.width - border;

    //height unit
    final hu = drawableHeight / 5;
    //width unit
    final wu = (drawableWidth / this._x.length.toDouble());

    // compute box dimensions
    final boxH = hu * 3.0;
    final boxW = wu;

    final hr = boxH / (_max - _min); //height per unit value

    //offset of the first point
    _drawDashLine(canvas, size, border + boxH / 2.0);
    _drawVerticalLines(canvas, size, wu, boxH);
    //offset of the first point
    var first = Offset(border + boxW / 2.0, border + boxH / 2.0);

    final points = _calculatePoints(canvas, first, boxW, boxH, hr);
    _drawPath(canvas, points);
    _drawPoints(canvas, points);

    //Draw Dates Labels
    _drawXLabels(canvas, first, wu, hu);

    //offset of the first label
    first = Offset(first.dx - 20, 10);
    _drawYLabels(canvas, first, hu);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  //compute offset(point) for every weight value
  List<Offset> _calculatePoints(
      Canvas canvas, Offset c, double width, double height, double hr) {
    List<Offset> points = [];
    _y.forEach((element) {
      final yy = height - (element - _min) * hr;
      final dp = Offset(c.dx, c.dy - height / 2.0 + yy);
      points.add(dp);
      c += Offset(width, 0);
    });

    return points;
  }

  //compute offset(point) for every weight value
  void _drawPoints(Canvas canvas, List<Offset> points) {
    points.forEach((point) {
      canvas.drawCircle(
        point, //offset
        10, //radius
        Paint()..color = AppColors.GREEN, //point color
      );
      canvas.drawCircle(
          point, 5, Paint()..color = Theme.of(context).colorScheme.primary);
    });
  }

  Path _drawPath(Canvas canvas, List<Offset> points) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    points.sublist(0).forEach((point) {
      path.lineTo(point.dx, point.dy);
    });
    canvas.drawPath(path, linePaint);
    return path;
  }

  void _drawXLabels(Canvas canvas, Offset center, double wd, double hu) {
    //Draw Label once per Month
    var bottom = Offset(center.dx, border + 4 * hu);
    var currentDate;
    _x.forEach((element) {
      if (element != currentDate) {
        _drawText(canvas, bottom, element, labelStyle, wd * 2);
      }
      currentDate = element;
      bottom += Offset(wd, 0);
    });
  }

  void _drawYLabels(Canvas canvas, Offset start, double hu) {
    //Draw 4 Labels based on the given pet weights
    //Starting from the maximum weight
    //divide the max weight by 4 to get the odd
    //every next value will be the current Label minus the odd (currentValue-odd)
    //the last label ([0,0]) will be the minimum weight or 0

    final odd = ((_max - _min) / 3).ceil();

    final endValue = _max.ceil();

    final startValue = _min.floor();

    var currentValue = endValue;

    for (int i = 1; i < 4; i++) {
      _drawText(canvas, start, currentValue.toString(), labelStyle, hu);
      start += Offset(0, hu);
      currentValue = currentValue - odd;
    }
    _drawText(
        canvas,
        start,
        (currentValue > startValue)
            ? startValue.toString()
            : startValue.toString(),
        labelStyle,
        hu);
  }

  Size _drawText(
      Canvas canvas, Offset c, String text, xLabelStyle, double maxWidth) {
    //prepare the textPainter to fit the given text
    final textPainter =
        _measureText(text, xLabelStyle, maxWidth, TextAlign.center);

    //calculate where to print the text
    final offset =
        c + Offset(-textPainter.width / 2.0, -textPainter.height / 2.0);

    //paint the text
    textPainter.paint(canvas, offset);
    return textPainter.size;
  }

  TextPainter _measureText(
      String text, xLabelStyle, double maxWidth, TextAlign align) {
    final span = TextSpan(text: text, style: xLabelStyle);
    final textPainter = TextPainter(
        text: span, textAlign: align, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter;
  }

  void _drawDashLine(Canvas canvas, size, xCenter) {
    double dashWidth = 10, dashSpace = 5, startX = border * 3;
    final paint = Paint()
      ..color = AppColors.GREEN
      ..strokeWidth = 2;
    var _width = MediaQuery.of(context).size.width > size.width
        ? MediaQuery.of(context).size.width - 10
        : size.width;
    while (startX < _width) {
      canvas.drawLine(
          Offset(startX, xCenter), Offset(startX + dashWidth, xCenter), paint);
      startX += dashWidth + dashSpace;
    }
  }

  void _drawVerticalLines(Canvas canvas, Size size, double wu, boxH) {
    double startX = border * 10;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 2;
    var unite = border * 3;
    var _width = MediaQuery.of(context).size.width > size.width
        ? MediaQuery.of(context).size.width - 10
        : size.width;
    while (unite <= _width) {
      canvas.drawLine(
          Offset(unite, 0), Offset(unite, size.height - startX), paint);
      unite += wu;
    }
  }

  void _init() {
    //sort weights by date
    pet.weights.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    //calculate maximum weight
    _max = pet.weights.reduce((a, b) => a.value > b.value ? a : b).value;

    //calculate minimum weight
    _min = pet.weights.reduce((a, b) => a.value < b.value ? a : b).value;

    //preparing Y Labels
    _y = pet.weights.map((e) => e.value).toList();

    //preparing X Labels
    _x = pet.weights
        .map((e) => "${months[e.date.month]}\n${e.date.year}")
        .toList();
  }
}
