import 'package:flutter/material.dart';


class AppGlobal {

  static Widget commonDivider({
    double indent = 0,
    double endIndent = 0,
    double thickness = 1,
    Color color = Colors.grey,
  }) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }

}
