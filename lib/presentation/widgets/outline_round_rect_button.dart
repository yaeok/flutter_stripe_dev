import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineRoundRectButton extends StatelessWidget {
  const OutlineRoundRectButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDisabled ? Colors.grey : Colors.green,
          width: 1,
        ),
        color: isDisabled ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
