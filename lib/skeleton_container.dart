import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius radius;

  const SkeletonContainer._({
    this.height = double.infinity,
    this.width = double.infinity,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    Key? key,
  }) : super(key: key);

  const SkeletonContainer.square({
    required double width,
    required double height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded(
      {required double width,
      required double height,
      BorderRadius radius = const BorderRadius.all(Radius.circular(12))})
      : this._(width: width, height: height, radius: radius);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: radius,
        ),
      ),
    );
  }
}
