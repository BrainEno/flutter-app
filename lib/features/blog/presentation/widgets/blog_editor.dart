import 'package:belog/core/theme/app_pallete.dart'; // Import your color palette
import 'package:flutter/material.dart';

enum BlogEditorContentType {
  title,
  body,
  tag, // Example for potential tag input - can be extended
  other,
}

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final BlogEditorContentType contentType; // New: Content Type parameter
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool expands;

  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.contentType =
        BlogEditorContentType.body, // Default to body content type
    this.hintStyle,
    this.textStyle,
    this.maxLines = 1,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final contentPadding = _getContentPadding(contentType);
    final fontSize = _getFontSize(contentType);
    final fontWeight = _getFontWeight(contentType);
    final hintFontSize = _getHintFontSize(contentType);
    final hintFontWeight = _getHintFontWeight(contentType);

    return Container(
      constraints: BoxConstraints(
        minHeight: 80,
        maxHeight: 300,
      ),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        validator: (value) {
          if (value!.isEmpty) {
            return '请输入$hintText';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
                fontSize: hintFontSize, // Dynamic hint font size
                fontWeight: hintFontWeight, // Dynamic hint font weight
                fontFamily: 'Roboto',
                color: isDarkMode
                    ? AppPallete.greyColorLight.withAlpha((0.5 * 255).toInt())
                    : AppPallete.lightGreyText.withAlpha((0.5 * 255).toInt()),
              ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: contentPadding, // Dynamic content padding
        ),
        style: textStyle ??
            TextStyle(
              fontSize: fontSize, // Dynamic font size
              height: 1.6,
              fontWeight: fontWeight, // Dynamic font weight
              fontFamily: 'Roboto',
              color: isDarkMode ? AppPallete.whiteColor : AppPallete.lightBlack,
            ),
        maxLines: maxLines,
        expands: expands,
        cursorColor: isDarkMode ? AppPallete.whiteColor : AppPallete.lightBlack,
      ),
    );
  }

  EdgeInsetsGeometry _getContentPadding(BlogEditorContentType contentType) {
    switch (contentType) {
      case BlogEditorContentType.title:
        return const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 12.0); // More vertical padding for title
      case BlogEditorContentType.body:
      default:
        return const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0); // Standard vertical padding for body
      // Adjust padding for other content types as needed
    }
  }

  double _getFontSize(BlogEditorContentType contentType) {
    switch (contentType) {
      case BlogEditorContentType.title:
        return 20.0; // Larger font size for title
      case BlogEditorContentType.body:
      default:
        return 16.0; // Standard font size for body
      // Adjust font size for other content types as needed
    }
  }

  FontWeight _getFontWeight(BlogEditorContentType contentType) {
    switch (contentType) {
      case BlogEditorContentType.title:
        return FontWeight.w600; // Bolder font weight for title
      case BlogEditorContentType.body:
      default:
        return FontWeight.w400; // Normal font weight for body
      // Adjust font weight for other content types as needed
    }
  }

  double _getHintFontSize(BlogEditorContentType contentType) {
    switch (contentType) {
      case BlogEditorContentType.title:
        return 20.0; // Slightly smaller hint for title, but still prominent
      case BlogEditorContentType.body:
      default:
        return 16.0; // Standard hint font size for body
      // Adjust hint font size for other content types as needed
    }
  }

  FontWeight _getHintFontWeight(BlogEditorContentType contentType) {
    switch (contentType) {
      case BlogEditorContentType.title:
        return FontWeight.w300; // Lighter hint for title
      case BlogEditorContentType.body:
      default:
        return FontWeight.w300; // Standard hint font weight
      // Adjust hint font weight for other content types as needed
    }
  }
}
