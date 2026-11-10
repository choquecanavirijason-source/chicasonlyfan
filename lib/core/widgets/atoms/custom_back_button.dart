import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const CustomBackButton({super.key, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: color ?? AppColors.textWhite),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
