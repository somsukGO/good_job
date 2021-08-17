import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';

class Loading extends StatelessWidget {
  final String title;

  Loading({this.title});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        color: ColorSources.BLACK.withAlpha(50),
        child: LoadingBody(title: title),
      ),
    );
  }
}

class LoadingBody extends StatelessWidget {
  final String title;

  LoadingBody({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorSources.backgroundColor(context),
        ),
        width: 200,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SpinKitFadingCircle(
              color: ColorSources.dynamicPrimary,
              size: 45.0,
            ),
            Text(title, style: TextStyles.bodyTextBlack(context: context)),
          ],
        ),
      ),
    );
  }
}
