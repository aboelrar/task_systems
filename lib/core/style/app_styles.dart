import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static const fontLight = FontWeight.w300;
  static const fontBold = FontWeight.w700;
  static const semiBold = FontWeight.w600;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;

  static TextStyle bigTextStyle = TextStyle(
    fontSize: 27,
    color: AppColor.primaryColor,
    fontWeight: AppStyles.fontBold,
  );

  static TextStyle titleStyle = TextStyle(fontSize: 20, color: AppColor.black);

  static TextStyle mediumTextStyle = TextStyle(
    fontSize: 16,
    color: AppColor.silverGrey,
  );

  static TextStyle smallTextStyle = TextStyle(
    fontSize: 12,
    color: AppColor.greySatTextColor,
  );

  static TextStyle exSmallTextStyle = TextStyle(
    fontSize: 9,
    color: AppColor.black,
    fontWeight: regular,
  );
}
