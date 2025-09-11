import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({required this.size, required this.onBuild, super.key});

  final Size size;
  final void Function(BuildContext context) onBuild;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: Builder(
        builder: (context) {
          onBuild(context);
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
