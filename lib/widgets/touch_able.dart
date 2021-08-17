import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';

class TouchAble extends StatelessWidget {
  final Widget widget;
  final double radius;
  final Function function;

  TouchAble({
    this.widget,
    this.radius = 0,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,
        Positioned.fill(
          child: Container(
            child: Material(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
                onTap: () => function(),
                splashColor: ColorSources.SECONDARY.withAlpha(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
