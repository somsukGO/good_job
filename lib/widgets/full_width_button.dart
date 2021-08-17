import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';

class FullWidthButton extends StatelessWidget {
  final String title;
  final Alignment alignment;
  final double paddingHorizontal;
  final Color primary;
  final Function function;
  final double paddingVertical;
  final double borderWidth;
  final Color borderColor;

  FullWidthButton({
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.paddingVertical = 15,
    this.function,
    this.title,
    this.alignment = Alignment.center,
    this.paddingHorizontal = 0,
    this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        child: ElevatedButton(
          onPressed: () {
            function();
          },
          child: Container(
            alignment: alignment,
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Text(
              title,
              style: TextStyle(
                color: ColorSources.WHITE,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: primary,
            onPrimary: Colors.teal.shade100,
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
