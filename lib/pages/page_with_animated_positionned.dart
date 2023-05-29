import 'package:flutter/material.dart';

class PageWithAnimatedPositionned extends StatefulWidget {
  const PageWithAnimatedPositionned({Key? key}) : super(key: key);

  @override
  State<PageWithAnimatedPositionned> createState() => _PageState();
}

class _PageState extends State<PageWithAnimatedPositionned> {
  late bool _isPlayed;
  static const _kFactor = 1.0 / 1.5;
  static const _kPictureSize = Size(3840.0 * _kFactor, 2160.0 * _kFactor);

  void _action() => setState(() => _isPlayed = !_isPlayed);

  @override
  void initState() {
    super.initState();
    _isPlayed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
            left: _isPlayed ? (-_kPictureSize.width / 2.0) : 0.0,
            top: _isPlayed ? (-_kPictureSize.height / 2.0) : 0.0,
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
