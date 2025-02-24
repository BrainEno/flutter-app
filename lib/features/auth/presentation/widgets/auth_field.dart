import 'package:belog/core/theme/app_pallete.dart'; // Import your color palette
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final TextEditingController controller;
  final IconData? prefixIcon; // New: Optional prefix icon
  final TextStyle? style; // New: Optional text style
  final TextStyle? hintStyle; // New: Optional hint text style
  final Color? borderColor; // New: Optional border color
  final Color? focusedBorderColor; // New: Optional focused border color

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.prefixIcon,
    this.style,
    this.hintStyle,
    this.borderColor,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      style: style ??
          TextStyle(
            fontSize: 16,
            color: isDarkMode
                ? AppPallete.whiteColor // White text in dark mode
                : AppPallete.lightBlack, // Black text in light mode
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
              fontSize: 16,
              color: isDarkMode
                  ? AppPallete.greyColor // Medium grey hint in dark mode
                  : AppPallete.lightGreyText, // Light grey hint in light mode
            ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDarkMode
                    ? AppPallete.greyColor // Medium grey icon in dark mode
                    : AppPallete.lightGreyText, // Light grey icon in light mode
              )
            : null,
        filled: true,
        fillColor: isDarkMode
            ? AppPallete.greyColorDark // Dark grey background in dark mode
            : AppPallete.lightBackground, // White background in light mode
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: _authFieldBorder(
            context, isDarkMode, borderColor), // Theme aware border
        enabledBorder: _authFieldBorder(
            context, isDarkMode, borderColor), // Theme aware enabled border
        focusedBorder: _authFieldFocusedBorder(
            context, focusedBorderColor), // Focused border remains gradient
        errorBorder: _authFieldErrorBorder(context), // Error border remains red
        focusedErrorBorder:
            _authFieldErrorBorder(context), // Focused error border remains red
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "请输入$hintText!" : null,
    );
  }

  // Theme-aware border for AuthField
  OutlineInputBorder _authFieldBorder(
      BuildContext context, bool isDarkMode, Color? borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor ??
            (isDarkMode
                ? AppPallete.greyColorLight // Light grey border in dark mode
                : AppPallete.lightBorder), // Light border in light mode
      ),
    );
  }

  // Focused border remains Gradient independent of theme
  OutlineInputBorder _authFieldFocusedBorder(
      BuildContext context, Color? focusedBorderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: focusedBorderColor ?? AppPallete.gradient2,
      ),
    );
  }

  // Error border remains red independent of theme
  OutlineInputBorder _authFieldErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.redAccent),
    );
  }
}
