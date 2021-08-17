import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final String labelText;
  final Function validator;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  CustomPasswordField({
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.labelText,
    this.textInputAction = TextInputAction.done,
    this.textEditingController,
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,
      focusNode: widget.focusNode,
      validator: widget.validator,
      enableSuggestions: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.textEditingController,
      style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      cursorColor: ColorSources.black(context),
      autocorrect: false,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: ColorSources.RED, fontWeight: FontWeight.w500),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorSources.dynamicPrimary, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorSources.dynamicPrimary, width: 2),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: ColorSources.black(context).withOpacity(0.7),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
          color: Get.isDarkMode ? ColorSources.WHITE_GREY_1 : ColorSources.WHITE,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        helperStyle: TextStyle(color: ColorSources.dynamicPrimary),
        hintStyle: TextStyles.bodyTextBlack(context: context, fontSize: 14),
        filled: true,
        fillColor: Get.isDarkMode ? ColorSources.WHITE : ColorSources.DARK_BLUE,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
