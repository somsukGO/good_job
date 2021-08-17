import 'package:flutter/material.dart';
import 'package:good_job/Utils/text_styles.dart';

class CustomTitle extends StatelessWidget {
  final String title;

  CustomTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 16),
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ],
    );
  }
}
