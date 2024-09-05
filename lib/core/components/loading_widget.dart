import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double screenWidth;

  const LoadingWidget({required this.screenWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: screenWidth * 0.45,
      child: LoadingAnimationWidget.inkDrop(
        color: Theme.of(context).indicatorColor,
        size: 40,
      ),
    );
  }
}
