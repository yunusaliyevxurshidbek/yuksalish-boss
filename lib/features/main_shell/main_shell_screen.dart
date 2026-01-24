import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_icons.dart';
import '../../core/router/route_names.dart';
import '../notifications/notifications.dart';

/// Main app shell with floating glassmorphic bottom navigation.
///
/// Uses a Stack-based layout where the page content extends behind
/// the floating navigation bar for an immersive VisionOS-inspired design.
class MainShellScreen extends ConsumerWidget {
  /// Child widget from router (current tab content)
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _calculateSelectedIndex(context);

    // Use BlocProvider.value for singleton Cubit to prevent closing on dispose
    final notificationsCubit = GetIt.I<NotificationsCubit>();
    // Only load if not already loaded or in error state
    if (notificationsCubit.state.status == NotificationsStatus.initial ||
        notificationsCubit.state.status == NotificationsStatus.error) {
      notificationsCubit.loadNotifications();
    }

    return BlocProvider.value(
      value: notificationsCubit,
      child: Scaffold(
        // Let body extend behind navbar
        extendBody: true,
        body: Stack(
          children: [
            // Layer 1: Page Content
            child,

            // Layer 2: Floating Glass Navbar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomGlassNavBar(
                currentIndex: currentIndex,
                onTap: (index) => _onTabTapped(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith(RouteNames.dashboard)) return NavTabIndex.dashboard;
    if (location.startsWith(RouteNames.analytics)) return NavTabIndex.analytics;
    if (location.startsWith(RouteNames.projects)) return NavTabIndex.projects;
    if (location.startsWith(RouteNames.finance)) return NavTabIndex.finance;
    if (location.startsWith(RouteNames.approvals)) return NavTabIndex.approvals;

    return NavTabIndex.dashboard;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case NavTabIndex.dashboard:
        context.go(RouteNames.dashboard);
        break;
      case NavTabIndex.analytics:
        context.go(RouteNames.analytics);
        break;
      case NavTabIndex.projects:
        context.go(RouteNames.projects);
        break;
      case NavTabIndex.finance:
        context.go(RouteNames.finance);
        break;
      case NavTabIndex.approvals:
        context.go(RouteNames.approvals);
        break;
    }
  }
}

/// VisionOS-inspired floating glassmorphic navigation bar.
///
/// Features:
/// - Floating design with 24px margin from bottom
/// - Glassmorphism effect with BackdropFilter blur
/// - Soft shadow for depth
/// - Animated scale on active state
/// - Haptic feedback on tap
class CustomGlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Calculate safe area padding for iPhone home indicator
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 12.w + bottomPadding,
      ),
      // Outer container with shadow (shadow needs to be outside ClipRRect)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          // Primary colored shadow for depth
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFF1E3A8A).withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          // Secondary soft shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              // Glassmorphism with subtle gradient - theme aware
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF1E293B).withValues(alpha: 0.95),
                        const Color(0xFF0F172A).withValues(alpha: 0.98),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.98),
                        const Color(0xFFF8FAFF).withValues(alpha: 0.95),
                      ],
              ),
              borderRadius: BorderRadius.circular(30.r),
              // Visible border for definition
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GlassNavItem(
                  iconSvg: AppIcons.home,
                  activeIconSvg: AppIcons.homeFilled,
                  label: 'Bosh sahifa',
                  isSelected: currentIndex == NavTabIndex.dashboard,
                  onTap: () => onTap(NavTabIndex.dashboard),
                ),
                _GlassNavItem(
                  iconSvg: AppIcons.chart,
                  activeIconSvg: AppIcons.chartFilled,
                  label: 'Tahlil',
                  isSelected: currentIndex == NavTabIndex.analytics,
                  onTap: () => onTap(NavTabIndex.analytics),
                ),
                _GlassNavItem(
                  iconSvg: AppIcons.building,
                  activeIconSvg: AppIcons.buildingFilled,
                  label: 'Loyihalar',
                  isSelected: currentIndex == NavTabIndex.projects,
                  isCentralItem: true,
                  onTap: () => onTap(NavTabIndex.projects),
                ),
                _GlassNavItem(
                  iconSvg: AppIcons.wallet,
                  activeIconSvg: AppIcons.walletFilled,
                  label: 'finance_title'.tr(),
                  isSelected: currentIndex == NavTabIndex.finance,
                  onTap: () => onTap(NavTabIndex.finance),
                ),
                _GlassNavItem(
                  iconSvg: AppIcons.checkCircle,
                  activeIconSvg: AppIcons.checkCircleFilled,
                  label: 'approvals_title'.tr(),
                  isSelected: currentIndex == NavTabIndex.approvals,
                  onTap: () => onTap(NavTabIndex.approvals),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual glass navigation item with animations.
class _GlassNavItem extends StatefulWidget {
  final String iconSvg;
  final String activeIconSvg;
  final String label;
  final bool isSelected;
  final bool isCentralItem;
  final VoidCallback onTap;

  const _GlassNavItem({
    required this.iconSvg,
    required this.activeIconSvg,
    required this.label,
    required this.isSelected,
    this.isCentralItem = false,
    required this.onTap,
  });

  @override
  State<_GlassNavItem> createState() => _GlassNavItemState();
}

class _GlassNavItemState extends State<_GlassNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    // Haptic feedback
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final activeColor = isDark
        ? const Color(0xFFF1F5F9) // Light text on dark
        : const Color(0xFF1A1D26); // Dark text on light
    final inactiveColor = isDark
        ? const Color(0xFF64748B) // Muted on dark
        : const Color(0xFFB0B0B0); // Muted on light

    final color = widget.isSelected ? activeColor : inactiveColor;
    final iconSize = widget.isSelected ? 26.w : 24.w;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon scale
              AnimatedScale(
                scale: widget.isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: SvgPicture.string(
                  widget.isSelected ? widget.activeIconSvg : widget.iconSvg,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              SizedBox(height: 4.h),
              // Label with animated color
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
