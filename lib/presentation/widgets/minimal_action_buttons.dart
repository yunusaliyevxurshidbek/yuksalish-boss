import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuksalish_mobile/core/theme/app_theme.dart';

class MinimalActionButtons extends StatelessWidget {
  final VoidCallback? onPayTap;
  final VoidCallback? onScheduleTap;
  final VoidCallback? onHistoryTap;

  const MinimalActionButtons({
    super.key,
    this.onPayTap,
    this.onScheduleTap,
    this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MinimalActionItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Pay Now',
            onTap: onPayTap,
          ),
          _MinimalActionItem(
            icon: Icons.calendar_today_outlined,
            label: 'Schedule',
            onTap: onScheduleTap,
          ),
          _MinimalActionItem(
            icon: Icons.history_rounded,
            label: 'History',
            onTap: onHistoryTap,
          ),
          _MinimalActionItem(
            icon: Icons.receipt_long_outlined,
            label: 'Invoices',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MinimalActionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MinimalActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<_MinimalActionItem> createState() => _MinimalActionItemState();
}

class _MinimalActionItemState extends State<_MinimalActionItem>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Icon Container
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0F4FF), // Very light blue-grey
                border: Border.all(
                  color: AppColors.primaryNavy.withAlpha(26),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryNavy.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 24.sp,
                  color: AppColors.primaryNavy,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // Label
            Text(
              widget.label,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: AppColors.darkSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
