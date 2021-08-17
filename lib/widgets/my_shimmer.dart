import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Get.isDarkMode ? Colors.grey[300] : ColorSources.BLUE_GREY,
          highlightColor: Get.isDarkMode ? Colors.grey[400] : ColorSources.DARK_BLUE,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(
              bottom: Dimensions.SIZE_DEFAULT,
              top: index == 0 ? Dimensions.SIZE_DEFAULT : 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: 18,
                        color: Colors.grey,
                      ),
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
