import 'package:flutter/material.dart';

class RoundRectButton extends StatelessWidget {
  const RoundRectButton({
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey : Colors.green,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
