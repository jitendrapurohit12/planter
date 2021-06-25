import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class ShutterButtonUI extends HookWidget {
  final VoidCallback callback;

  const ShutterButtonUI(this.callback);

  @override
  Widget build(BuildContext context) {
    const _initialRadius = 90.0;
    const _finalRadius = 85.0;
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 100),
      lowerBound: _finalRadius,
      upperBound: _initialRadius,
    );
    return VStack([
      AnimatedBuilder(
        animation: _controller,
        builder: (_, widget) {
          return SizedBox(
            width: _controller.value,
            height: _controller.value,
            child: widget,
          );
        },
        child: GestureDetector(
          onTap: () async {
            _controller.forward();
            await Future.delayed(const Duration(milliseconds: 100));
            _controller.reverse();
            callback();
          },
          child: ButtonUI(),
        ),
      ),
    ]);
  }
}

class ButtonUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VxBox(child: VxBox().color(Colors.white).border(width: 14).roundedFull.make().p4())
        .white
        .roundedFull
        .make();
  }
}
