import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PressableButton extends StatefulWidget {
  // Required
  final String text;
  final VoidCallback? onTap;

  // Styling
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  // Size
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  // Icon (optional)
  final String? svgIcon;
  final double iconSize;
  final Color? iconColor;
  final double iconSpacing;
  final bool iconOnRight;

  // Border (optional)
  final Color? borderColor;
  final double borderWidth;

  // Animation
  final double scaleFactor;
  final Duration animationDuration;

  // State
  final bool isLoading;
  final bool isDisabled;

  const PressableButton({
    super.key,
    required this.text,
    this.onTap,
    // Styling
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    // Size
    this.width,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    // Icon
    this.svgIcon,
    this.iconSize = 20,
    this.iconColor,
    this.iconSpacing = 8,
    this.iconOnRight = false,
    // Border
    this.borderColor,
    this.borderWidth = 1.5,
    // Animation
    this.scaleFactor = 0.96,
    this.animationDuration = const Duration(milliseconds: 100),
    // State
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _isPressed = false;

  bool get _isActive => !widget.isDisabled && !widget.isLoading;

  void _onTapDown(TapDownDetails details) {
    if (_isActive) setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    if (_isActive) setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    if (_isActive) setState(() => _isPressed = false);
  }

  void _onTap() {
    if (_isActive) widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Theme.of(context).primaryColor;
    final txtColor = widget.textColor ?? Colors.white;
    final icnColor = widget.iconColor ?? txtColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleFactor : 1.0,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: widget.isDisabled ? 0.5 : 1.0,
          duration: widget.animationDuration,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.borderColor != null
                  ? Border.all(
                color: widget.borderColor!,
                width: widget.borderWidth,
              )
                  : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                ),
              )
                  : _buildContent(txtColor, icnColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color txtColor, Color icnColor) {
    final textWidget = Text(
      widget.text,
      style: TextStyle(
        color: txtColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
    );

    if (widget.svgIcon == null) return textWidget;

    final iconWidget = SvgPicture.asset(
      widget.svgIcon!,
      width: widget.iconSize,
      height: widget.iconSize,
      colorFilter: ColorFilter.mode(icnColor, BlendMode.srcIn),
    );

    final children = widget.iconOnRight
        ? [textWidget, SizedBox(width: widget.iconSpacing), iconWidget]
        : [iconWidget, SizedBox(width: widget.iconSpacing), textWidget];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}