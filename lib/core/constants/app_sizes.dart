/// App-wide size constants for consistent spacing, radii, and dimensions.
///
/// Use these constants throughout the app to maintain visual consistency.
/// All values are in logical pixels and should be used with ScreenUtil
/// extensions (.w, .h, .r, .sp) for responsive scaling.
abstract class AppSizes {
  // ═══════════════════════════════════════════════════════════════════════════
  // PADDING / SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra small padding - 4px
  static const double p4 = 4.0;

  /// Small padding - 8px
  static const double p8 = 8.0;

  /// Medium-small padding - 12px
  static const double p12 = 12.0;

  /// Medium padding - 16px (default)
  static const double p16 = 16.0;

  /// Medium-large padding - 20px
  static const double p20 = 20.0;

  /// Large padding - 24px
  static const double p24 = 24.0;

  /// Extra large padding - 32px
  static const double p32 = 32.0;

  /// XXL padding - 40px
  static const double p40 = 40.0;

  /// XXXL padding - 48px
  static const double p48 = 48.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small radius - 8px (buttons, small chips)
  static const double radiusS = 8.0;

  /// Medium radius - 12px (cards, inputs)
  static const double radiusM = 12.0;

  /// Large radius - 16px (modals, large cards)
  static const double radiusL = 16.0;

  /// Extra large radius - 24px (bottom sheets, special containers)
  static const double radiusXL = 24.0;

  /// Full/circular radius - 100px (pills, circular elements)
  static const double radiusFull = 100.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON SIZES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small icon - 16px (inline icons, badges)
  static const double iconS = 16.0;

  /// Medium icon - 20px (list item icons)
  static const double iconM = 20.0;

  /// Large icon - 24px (navigation, primary actions)
  static const double iconL = 24.0;

  /// Extra large icon - 32px (empty states, headers)
  static const double iconXL = 32.0;

  /// XXL icon - 48px (large empty states)
  static const double iconXXL = 48.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPONENT HEIGHTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard button height - 48px
  static const double buttonHeight = 48.0;

  /// Small button height - 36px
  static const double buttonHeightS = 36.0;

  /// Large button height - 56px
  static const double buttonHeightL = 56.0;

  /// Input field height - 48px
  static const double inputHeight = 48.0;

  /// App bar height - 56px
  static const double appBarHeight = 56.0;

  /// Bottom navigation bar height - 80px
  static const double bottomNavHeight = 80.0;

  /// List item height - 72px
  static const double listItemHeight = 72.0;

  /// Metric card height - 120px
  static const double metricCardHeight = 120.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR / THUMBNAIL SIZES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small avatar - 32px
  static const double avatarS = 32.0;

  /// Medium avatar - 40px
  static const double avatarM = 40.0;

  /// Large avatar - 56px
  static const double avatarL = 56.0;

  /// Extra large avatar - 80px
  static const double avatarXL = 80.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER WIDTHS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Thin border - 1px
  static const double borderThin = 1.0;

  /// Medium border - 1.5px
  static const double borderMedium = 1.5;

  /// Thick border - 2px
  static const double borderThick = 2.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ELEVATION / SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  /// No elevation
  static const double elevation0 = 0.0;

  /// Low elevation - subtle shadow
  static const double elevation1 = 2.0;

  /// Medium elevation - cards
  static const double elevation2 = 4.0;

  /// High elevation - modals, dialogs
  static const double elevation3 = 8.0;

  /// Highest elevation - floating elements
  static const double elevation4 = 16.0;
}
