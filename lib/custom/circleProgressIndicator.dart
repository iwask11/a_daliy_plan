import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);
///带圆点的圆形渐变指示器
class CircleProgressIndicator extends StatefulWidget {
  const CircleProgressIndicator({
    Key? key,
    this.strokeWidth = 2.0,
    this.totalAngle = 2 * pi,
    this.value,
    required this.ringRadius,
    required this.ringColors,
    this.ringColorStops,
    this.ringBackgroundColor = const Color(0xFFEEEEEE),
    required this.dotRadius,
    required this.dotColors,
    this.dotColorStops,
    required this.progressChanged,
  }) : super(key: key);

  /// 粗细
  final double strokeWidth;
  /// 圆周角
  final double totalAngle;
  /// 当前进度，取值范围 [0.0-1.0]
  final double? value;
  /// 圆的半径
  final double ringRadius;
  /// 渐变色数组
  final List<Color> ringColors;
  /// 渐变色的终止点，对应colors属性
  final List<double>? ringColorStops;
  /// 进度条背景色
  final Color ringBackgroundColor;
  /// 圆点的半径
  final double dotRadius;
  /// 圆点的颜色
  final List<Color> dotColors;
  final List<double>? dotColorStops;

  final ProgressChanged progressChanged;

  @override
  State<StatefulWidget> createState() => CircleProgressIndicatorState();
}
/// 该组件的状态方法
class CircleProgressIndicatorState extends State<CircleProgressIndicator>
    with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (widget.value != null) _animationController.value = widget.value!;
    _animationController.addListener(() {
      if (widget.progressChanged  != null)
        widget.progressChanged (_animationController.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _ringColors = widget.ringColors;
    var _dotColors = widget.dotColors;
    if (_ringColors == null || _dotColors == null) {
      Color color = Theme
          .of(context)
          .colorScheme
          .secondary;
      _ringColors = [color, color];
      _dotColors = [color, color];
    }


    final double width = widget.ringRadius * 2.0;
    final size = new Size(width, width);
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        alignment: FractionalOffset.center,
        child: CustomPaint(
          key: paintKey,
          size: Size.fromRadius(widget.ringRadius),
          painter: CircleProgressIndicatorPainter(
            strokeWidth: widget.strokeWidth,
            ringBackgroundColor: widget.ringBackgroundColor,
            totalAngle: widget.totalAngle,
            value: _animationController.value,
            ringRadius: widget.ringRadius,
            ringColors: _ringColors,
            dotRadius: widget.dotRadius,
            dotColors: _dotColors,
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox? getBox = paintKey.currentContext!.findRenderObject() as RenderBox?;
    Offset local = getBox!.globalToLocal(details.globalPosition);
    isValidTouch = _checkValidTouch(local);
    if (!isValidTouch) {
      return;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox? getBox = paintKey.currentContext!.findRenderObject() as RenderBox?;
    Offset local = getBox!.globalToLocal(details.globalPosition);
    final double x = local.dx;
    final double y = local.dy;
    final double center = widget.ringRadius;
    double radians = atan((x - center) / (center - y));
    if (y > center) {
      radians = radians + degToRad(180.0);
    } else if (x < center) {
      radians = radians + degToRad(360.0);
    }
    _animationController.value = radians / degToRad(360.0);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isValidTouch) {
      return;
    }
  }

  bool _checkValidTouch(Offset pointer) {
    final double validInnerRadius = widget.ringRadius - widget.dotRadius * 3;
    final double dx = pointer.dx;
    final double dy = pointer.dy;
    final double distanceToCenter =
    sqrt(pow(dx - widget.ringRadius, 2) + pow(dy - widget.ringRadius, 2));
    if (distanceToCenter < validInnerRadius ||
        distanceToCenter > widget.ringRadius) {
      return false;
    }
    return true;
  }
}

//画笔实现
class CircleProgressIndicatorPainter extends CustomPainter {
  CircleProgressIndicatorPainter({
    this.ringAngle =  -pi / 2.0,
    this.strokeWidth = 10.0,
    this.value,
    this.totalAngle = 2 * pi,
    this.ringRadius,
    required this.ringColors,
    this.ringColorStops,
    this.ringBackgroundColor = const Color(0xFFFFFFFF),
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black26,
    this.lineColor = Colors.black54,
    this.dotRadius,
    required this.dotColors,
    this.dotColorStops,
  });

  final double ringAngle;
  final double strokeWidth;
  final double? value;
  final double totalAngle;
  final double? ringRadius;
  final List<Color> ringColors;
  final List<double>? ringColorStops;
  final Color ringBackgroundColor;
  final double shadowWidth;
  final Color shadowColor;
  final Color lineColor;
  final double? dotRadius;
  final List<Color> dotColors;
  final List<double>? dotColorStops;

  ///绘制方法
  @override
  void paint(Canvas canvas, Size size) {

    final double radius = ringRadius! ;
    final double _ringStrokeWidth = strokeWidth;
    final double _ringStrokeOffset = _ringStrokeWidth * 0.4;

    final double _dotRadius = dotRadius!;
    final double drawRadius = radius - _dotRadius;

    final double center = size.width * 0.5;
    final Offset _offsetCenter = Offset(center, center);
    final double outerRadius = center - _ringStrokeOffset;
    final double innerRadius = center - _dotRadius * 2 + _ringStrokeOffset;

    double _ringValue = (value ?? .0);
    _ringValue = _ringValue.clamp(.0, 1.0) * totalAngle;
    double _start = .0;
    _start = asin(strokeWidth / (size.width - strokeWidth));

    ///draw shadow
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = shadowColor
      ..strokeWidth = shadowWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowWidth);
   // canvas.drawCircle(_offsetCenter, outerRadius, shadowPaint);
   // canvas.drawCircle(_offsetCenter, innerRadius, shadowPaint);

    Path path = Path.combine(PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: _offsetCenter, radius: outerRadius)),
        Path()..addOval(Rect.fromCircle(center: _offsetCenter, radius: innerRadius)));
    canvas.drawShadow(path, shadowColor, 4.0, true);

    /// 圆环画笔
    var ringPaint = Paint()..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke..isAntiAlias = true..strokeWidth = strokeWidth;

    final Rect rect = Rect.fromCircle(center: _offsetCenter, radius: drawRadius);
    /// 绘制背景，画笔会按照先后顺序绘画, paint按照rect（形状）绘制白色圆环（形状、角度、粗细等）
    /// draw background
    if(ringBackgroundColor != Colors.transparent) {
      final Rect outline = Rect.fromCircle(center: _offsetCenter, radius: radius-_ringStrokeOffset);
      final Rect innerline = Rect.fromCircle(center: _offsetCenter, radius: radius-_ringStrokeWidth-_ringStrokeOffset);
      var linePaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeWidth = 1;
      canvas.drawArc(outline, _start, totalAngle, false, linePaint);
      ringPaint.color = ringBackgroundColor;
      canvas.drawArc(rect, _start, totalAngle, false, ringPaint);
      canvas.drawArc(innerline, _start, totalAngle, false, linePaint);
    }
    /// 绘制渐变圆弧线
    if(_ringValue > 0) {
      final double offset = asin(_ringStrokeWidth * 0.5 / drawRadius);
      /// 渐变设置， 扫描渐变
      ringPaint.shader = SweepGradient(
        startAngle: 0.0,
        endAngle: _ringValue,
        colors: ringColors,
        stops: ringColorStops,
      ).createShader(rect);
      canvas.save();
      canvas.translate(0.0, size.width);
      canvas.rotate(-90 * (pi / 180.0));
      canvas.drawArc(rect, _start, _ringValue-offset, false, ringPaint);
      canvas.restore();
    }
    /// 绘制小圆点
    if(dotRadius != null) {
      double dx = radius + drawRadius * (sin(_ringValue));
      double dy = radius - drawRadius * (cos(_ringValue));

      Paint dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      // canvas.drawCircle(new Offset(dx, dy), _dotRadius/1.35, dotPaint);
      canvas.drawCircle(new Offset(dx, dy), _dotRadius, dotPaint);
      dotPaint
        ..shader = ui.Gradient.linear(Offset.zero, Offset(100, 0),  dotColors, dotColorStops,)
        // ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawCircle(new Offset(dx, dy), _dotRadius*0.8, dotPaint);
    }
  }


  /// 刷新布局时是否需要重绘、 开发中根据需求灵活变动
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}