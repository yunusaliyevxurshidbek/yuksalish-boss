import 'package:flutter/material.dart';

/// App-wide color palette (consolidated).
abstract class AppColors {
  AppColors._();

  // Core palette (former AppColors).
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E2A5E);

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color disabled = Color(0xFFE2E8F0);
  static const Color disabledText = Color(0xFF94A3B8);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color chartBlue = Color(0xFF3B82F6);
  static const Color chartGreen = Color(0xFF22C55E);
  static const Color chartGreenDark = Color(0xFF059669);
  static const Color chartYellow = Color(0xFFF59E0B);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartPurple = Color(0xFF8B5CF6);
  static const Color chartIndigo = Color(0xFF6366F1);
  static const Color chartCyan = Color(0xFF06B6D4);
  static const Color chartOrange = Color(0xFFF97316);
  static const Color chartPink = Color(0xFFEC4899);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  // Onboarding gradients.
  static const Color onboardingGradientStart = Color(0xFF2855AE);
  static const Color onboardingGradientEnd = Color(0xFF002147);

  // Legacy/auth palette (former AppColors in app_theme.dart).
  static const Color primaryNavy = Color(0xFF003366);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softGrey = Color(0xFFF5F7FA);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey900 = Color(0xFF0F172A);
  static const Color mediumGrey = Color(0xFF94A3B8);
  static const Color secondaryText = grey500;
  static const Color darkSlate = Color(0xFF1E293B);

  static const Color cardBackground = white;
  static const Color badgeForSale = primaryNavy;
  static const Color badgeReady = Color(0xFF10B981);
  static const Color badgeRent = Color(0xFF8B5CF6);
  static const Color heartBackground = Color(0x80FFFFFF);
  static const Color heartActive = Color(0xFFEF4444);
  static const Color heartInactive = white;
  static const Color priceColor = primaryNavy;
  static const Color filterActive = primaryNavy;
  static const Color filterInactive = white;
  static const Color filterBorder = grey300;

  // Compatibility aliases used across features.
  static const Color primaryColor = primary;
  static const Color primaryLightColor = primaryLight;
  static const Color backgroundColor = background;
  static const Color surfaceColor = surface;
  static const Color cardColor = surface;
  static const Color unreadCardColor = background;
  static const Color borderColor = border;
  static const Color dividerColor = divider;
  static const Color shadowColor = border;
  static const Color successColor = success;
  static const Color warningColor = warning;
  static const Color errorColor = error;
  static const Color infoColor = info;

  // Sales dynamics palette derived from dashboard visuals.
  static const Color salesPrimary = Color(0xFF4C7EFF);
  static const Color salesBackground = Color(0xFFF5F6FA);
  static const Color salesCard = Color(0xFFFFFFFF);
  static const Color salesBorder = Color(0xFFE6EAF2);
  static const Color salesShadow = Color(0xFF1C2B5A);
  static const Color salesTextPrimary = Color(0xFF1F2A44);
  static const Color salesTextSecondary = Color(0xFF7B8499);
  static const Color salesTextMuted = Color(0xFFB0B7C3);
  static const Color salesTarget = Color(0xFFB3C6FF);
  static const Color salesSuccess = Color(0xFF27AE60);
  static const Color salesSuccessLight = Color(0xFFE7F9ED);
  static const Color salesWarning = Color(0xFFF2C94C);
  static const Color salesWarningLight = Color(0xFFFFF4E0);
  static const Color salesError = Color(0xFFEB5757);
  static const Color salesErrorLight = Color(0xFFFDECEC);
  static const Color salesTabInactive = Color(0xFFE9ECF3);

  // Funnel analysis palette.
  static const Color funnelBackground = Color(0xFFF5F6FA);
  static const Color funnelCard = Color(0xFFFFFFFF);
  static const Color funnelNew = Color(0xFF1a5f7a); // Dark teal
  static const Color funnelContacted = Color(0xFF3498db); // Blue
  static const Color funnelQualified = Color(0xFFf39c12); // Orange
  static const Color funnelShowing = Color(0xFF9b59b6); // Purple
  static const Color funnelNegotiation = Color(0xFF27ae60); // Green
  static const Color funnelReservation = Color(0xFFe74c3c); // Red
  static const Color funnelContract = Color(0xFF95a5a6); // Gray
  static const Color funnelWon = Color(0xFF2ecc71); // Light green

  // Payments palette.
  static const Color paymentBackground = Color(0xFFF5F6FA);
  static const Color paymentCard = Color(0xFFFFFFFF);
  static const Color paymentIdBlue = Color(0xFF4C7EFF);
  static const Color paymentAmountDark = Color(0xFF1A1D26);
  static const Color paymentSuccessBg = Color(0xFFE8FCF1);
  static const Color paymentSuccessText = Color(0xFF27AE60);
  static const Color paymentPendingBg = Color(0xFFFFF8E1);
  static const Color paymentPendingText = Color(0xFFFFA000);
  static const Color paymentRejectedBg = Color(0xFFFFEBEE);
  static const Color paymentRejectedText = Color(0xFFD32F2F);

  // ===========================================================================
  // DARK THEME COLORS
  // ===========================================================================

  // Dark theme backgrounds
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceElevated = Color(0xFF334155);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkScaffoldBackground = Color(0xFF0F172A);

  // Dark theme borders & dividers
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF475569);

  // Dark theme text colors
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Dark theme primary (slightly brighter for visibility)
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkPrimaryLight = Color(0xFF60A5FA);

  // Dark theme status colors (adjusted for dark backgrounds)
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkSuccessLight = Color(0xFF166534);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkWarningLight = Color(0xFF854D0E);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkErrorLight = Color(0xFF7F1D1D);
  static const Color darkInfo = Color(0xFF3B82F6);
  static const Color darkInfoLight = Color(0xFF1E3A8A);

  // Dark theme disabled states
  static const Color darkDisabled = Color(0xFF475569);
  static const Color darkDisabledText = Color(0xFF64748B);

  // Dark theme input fields
  static const Color darkInputBackground = Color(0xFF1E293B);
  static const Color darkInputBorder = Color(0xFF475569);
  static const Color darkInputFocusedBorder = Color(0xFF3B82F6);

  // Dark theme card shadows (for elevated surfaces)
  static const Color darkShadow = Color(0xFF000000);

  // Dark theme navigation
  static const Color darkNavBackground = Color(0xFF1E293B);
  static const Color darkNavSelected = Color(0xFF3B82F6);
  static const Color darkNavUnselected = Color(0xFF64748B);

  // Dark theme payments palette
  static const Color darkPaymentBackground = Color(0xFF1E293B);
  static const Color darkPaymentCard = Color(0xFF334155);
  static const Color darkPaymentSuccessBg = Color(0xFF14532D);
  static const Color darkPaymentPendingBg = Color(0xFF713F12);
  static const Color darkPaymentRejectedBg = Color(0xFF7F1D1D);

  // Dark theme sales palette
  static const Color darkSalesBackground = Color(0xFF1E293B);
  static const Color darkSalesCard = Color(0xFF334155);
  static const Color darkSalesTextPrimary = Color(0xFFF1F5F9);
  static const Color darkSalesTextSecondary = Color(0xFF94A3B8);

  // Dark theme profile menu colors
  static const Color darkProfileMenuBg = Color(0xFF1E293B);
  static const Color darkProfileMenuIcon = Color(0xFF94A3B8);
}
