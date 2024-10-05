import 'package:flutter/material.dart';

void scrollLeft(ScrollController scrollController) {
  scrollController.animateTo(
    scrollController.offset - 200,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

void scrollRight(ScrollController scrollController) {
  scrollController.animateTo(
    scrollController.offset + 200,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
