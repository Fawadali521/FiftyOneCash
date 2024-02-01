import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';

class AnimatedBar extends StatefulWidget {
  const AnimatedBar({super.key});

  @override
  State<AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  bool isTop = true;

  Duration duration = const Duration(milliseconds: 2000);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    while (true) {
      isTop = false;
      setState(() {});
      await _controller.forward();
      isTop = true;
      setState(() {});
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedAlign(
            duration: duration,
            curve: Curves.linear,
            alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Container(
              height: 3,
              width: 300 - 15,
              decoration: BoxDecoration(
                color: Palette.neon,
                // gradient: LinearGradient(
                //     begin: Alignment.centerLeft,
                //     end: Alignment.centerRight,
                //     colors: [
                //       Colors.greenAccent.withOpacity(0.5),
                //       Colors.greenAccent,
                //       Colors.greenAccent,
                //       Colors.greenAccent.withOpacity(0.5),
                //     ]),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        });
  }
}
