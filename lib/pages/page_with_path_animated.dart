import 'dart:ui';

import 'package:flutter/material.dart';

class PageWithPathAnimated extends StatefulWidget {
  const PageWithPathAnimated({Key? key}) : super(key: key);

  @override
  State<PageWithPathAnimated> createState() => _PageState();
}

class _PageState extends State<PageWithPathAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late int _step;
  late Path _path;

  bool get _isFirstStep => _step == 0;

  static const _kFactor = 1.0 / 1.5;
  static const _kPictureSize = Size(3840.0 * _kFactor, 2160.0 * _kFactor);
  static const _kScreenSize = Size(360.0, 592.0);

  void _setupAnimationSettings() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation)
      ..addListener(() => setState(() {}));

    _step = 0;
    _path = _getPath(step: _step);
  }

  void _action() {
    if (!_isFirstStep) {
      final step = (_step % 2 == 0) ? 0 : 1;
      _path = _getPath(step: step);
      _controller.reset();
    }
    _controller.forward();
    _step++;
  }

  Path _getPath({required int step}) {
    late Path path;
    switch (step) {
      case 0:
        path = Path()
          ..moveTo(
            0,
            _kPictureSize.height / 2.0,
          )
          ..quadraticBezierTo(
            _kPictureSize.width / 2.0,
            _kPictureSize.height / 1.5,
            _kPictureSize.width - _kScreenSize.width,
            _kPictureSize.height / 2.0,
          );
        break;
      case 1:
        path = Path()
          ..moveTo(
            _kPictureSize.width - _kScreenSize.width,
            _kPictureSize.height / 2.0,
          )
          ..quadraticBezierTo(
            _kPictureSize.width / 2.0,
            -_kPictureSize.height / 2.2,
            0,
            _kPictureSize.height / 2.0,
          );
        break;

      default:
        throw UnimplementedError('Path not implemented for step $step.');
    }

    return path;
  }

  Offset _calculateRelativePosition(value) {
    PathMetric pathMetric = _path.computeMetrics().first;
    value = pathMetric.length * value;
    final pos = pathMetric.getTangentForOffset(value);
    return pos?.position.scale(-1, -1) ?? Offset.zero;
  }

  @override
  void initState() {
    super.initState();
    _setupAnimationSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: _calculateRelativePosition(_animation.value).dx,
            top: _calculateRelativePosition(_animation.value).dy,
            child: SizedBox(
              width: _kPictureSize.width,
              height: _kPictureSize.height,
              child: Image.asset(
                'assets/images/dash.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _action,
                child: const Text('Go'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
