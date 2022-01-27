import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenRotationFix extends StatefulWidget {
  static const id = 'rotation_fix';

  const ScreenRotationFix({Key key}) : super(key: key);

  @override
  State<ScreenRotationFix> createState() => _ScreenRotationFixState();
}

class _ScreenRotationFixState extends State<ScreenRotationFix> {
  int rotation = 0;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final path = args['path'];

    void _rotateRight() {
      rotation += 90;
      setState(() {});
    }

    void _rotateLeft() {
      rotation -= 90;
      setState(() {});
    }

    return Scaffold(
      body: RotatedBox(
        quarterTurns: (rotation ~/ 90).abs(),
        child: Image.file(
          File(path),
          fit: BoxFit.contain,
        ),
      ).centered(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 36,
        items: [
          getItem('Rotate Left', Icons.rotate_left),
          getItem('Rotate Right', Icons.rotate_right),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _rotateLeft();
              break;
            case 1:
              _rotateRight();
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pop(context, rotation);
        },
        label: 'Save'.text.make(),
        icon: const Icon(Icons.check),
      ),
    );
  }
}

// VxBox(
//         child: HStack(
//           [
//             IconButton(onPressed: () => _rotateLeft(), icon: const Icon(Icons.rotate_left)),
//             IconButton(onPressed: () => _rotateRight(), icon: const Icon(Icons.rotate_right)),
//           ],
//           axisSize: MainAxisSize.max,
//           alignment: MainAxisAlignment.spaceEvenly,
//         ).py8(),
//       ).amber300.make()

BottomNavigationBarItem getItem(String title, IconData icon) {
  return BottomNavigationBarItem(icon: Icon(icon), label: title);
}
