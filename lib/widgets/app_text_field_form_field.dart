import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.fieldKey,
    this.label,
    this.hint,
    this.initialValue,
    this.validator,
  });

  final Key? fieldKey;
  final String? label;
  final String? hint;
  final String? initialValue;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1),
    );
    return TextFormField(
      key: fieldKey,
      initialValue: initialValue,
      validator: validator,
      decoration: InputDecoration(
        border: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        enabledBorder: borderStyle,
        errorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelText: label,
        hintText: hint,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.black26),
      ),
    );
  }
}
