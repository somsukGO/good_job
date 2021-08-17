import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';

class TitleText extends StatelessWidget {
  final String title;
  final String text;

  TitleText({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: ColorSources.black(context),
            fontSize: 14,
          ),
        ),
        Text(
          text,
          style: TextStyles.detailText(),
        ),
      ],
    );
  }
}
