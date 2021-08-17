import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/widgets/touch_able.dart';

class PageButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Function onTap;

  PageButton({@required this.icon, @required this.color, @required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TouchAble(
      radius: 10,
      function: onTap,
      widget: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorSources.dynamicPrimary),
          ),
          addHorizontalSpace(Dimensions.SIZE_LARGE),
          Text(
            title,
            style: TextStyle(
              color: ColorSources.black(context),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
