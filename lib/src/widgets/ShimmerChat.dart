import 'package:flutter/material.dart';

class ShimmerChat extends StatefulWidget {
  const ShimmerChat({super.key});

  @override
  _ShimmerChatState createState() => _ShimmerChatState();
}

class _ShimmerChatState extends State<ShimmerChat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.05, end: 0.01).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 30,
        right: 20,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: width / 2.2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(_animation.value),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: width / 2.2,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(_animation.value),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
