import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType textInputType;
  final int maxLine;
  final Widget prefix;
  final TextEditingController textEditingController;
  final String labelText;
  final TextInputAction textInputAction;
  final double borderWidth;
  final Function validator;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  CustomTextFormField({
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.labelText = '- - -',
    this.textEditingController,
    this.borderWidth = 0,
    this.textInputType,
    this.maxLine = 1,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      validator: validator,
      controller: textEditingController,
      style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w500),
      keyboardType: textInputType,
      textInputAction: textInputAction,
      cursorColor: ColorSources.black(context),
      maxLines: maxLine,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: ColorSources.RED, fontWeight: FontWeight.w500),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorSources.dynamicPrimary, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorSources.dynamicPrimary, width: 2),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: ColorSources.black(context).withOpacity(0.7),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        prefixIcon: prefix,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        helperStyle: TextStyle(color: ColorSources.BLACK_26, fontWeight: FontWeight.w500, fontSize: 14),
        hintStyle: TextStyles.bodyTextBlack(context: context, fontSize: 14),
        filled: true,
        fillColor: Get.isDarkMode ? ColorSources.WHITE : ColorSources.DARK_BLUE,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300], width: borderWidth),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorSources.dynamicPrimary, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
