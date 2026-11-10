import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CodeInputField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final int length;

  const CodeInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.length = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: index < 2 ? AppColors.primary : AppColors.textHint,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
