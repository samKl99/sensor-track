import 'package:flutter/material.dart';

class SensorTrackTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final bool? autocorrect;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextStyle? hintStyle;
  final TextInputType? keyBoardType;
  final TextCapitalization? textCapitalization;

  const SensorTrackTextField({
    this.hint,
    this.controller,
    this.autovalidateMode,
    this.autocorrect,
    this.obscureText,
    this.readOnly,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.onTap,
    this.validator,
    this.hintStyle,
    this.keyBoardType,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          filled: true,
          hintText: hint,
          hintStyle: hintStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              //color: ColorUtil.focusedTextField,
              width: 1.0,
            ),
          ),
        ),
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        autocorrect: autocorrect ?? false,
        obscureText: obscureText ?? false,
        readOnly: readOnly ?? false,
        textInputAction: textInputAction,
        keyboardType: keyBoardType ?? TextInputType.text,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
