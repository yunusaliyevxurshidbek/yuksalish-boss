/// Route name constants for the Boss App.
///
/// Centralized route definitions for consistent navigation.
/// Use these constants with GoRouter navigation methods.
abstract class RouteNames {
  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH ROUTES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Splash screen route
  static const String splash = '/splash';

  /// Login screen route
  static const String login = '/login';

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN SHELL ROUTES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main shell (bottom navigation wrapper)
  static const String main = '/';

  /// Dashboard tab
  static const String dashboard = '/dashboard';

  /// Analytics tab
  static const String analytics = '/analytics';

  /// Projects list tab
  static const String projects = '/projects';

  /// Project detail screen (singular path to avoid shell route conflict)
  static const String projectDetail = '/project/:id';

  /// Project details premium screen
  static const String projectDetailsPremium = '/project/details/:id';

  /// Finance tab
  static const String finance = '/finance';

  /// Approvals tab
  static const String approvals = '/approvals';

  /// Approval detail screen
  static const String approvalDetail = '/approvals/:id';

  // ═══════════════════════════════════════════════════════════════════════════
  // SECONDARY ROUTES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Notifications screen
  static const String notifications = '/notifications';

  /// Revenue details screen
  static const String revenueDetails = '/revenue-details';

  /// Sold apartments details screen
  static const String soldApartments = '/sold-apartments';

  /// Sales dynamics screen
  static const String salesDynamics = '/sales-dynamics';

  /// Funnel analysis screen
  static const String funnelAnalysis = '/funnel-analysis';

  /// All payments screen
  static const String allPayments = '/all-payments';

  /// Settings screen
  static const String settings = '/settings';

  /// Leads screen
  static const String leads = '/leads';

  /// Lead details screen
  static const String leadDetails = '/leads/:id';

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE ROUTES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Profile screen
  static const String profile = '/profile';

  /// Edit profile screen
  static const String editProfile = '/profile/edit';

  /// Company info screen
  static const String companyInfo = '/profile/company';

  /// PIN change screen
  static const String pinChange = '/profile/pin-change';

  /// Devices screen
  static const String devices = '/profile/devices';

  /// Session timeout screen
  static const String sessionTimeout = '/profile/session-timeout';

  /// Language screen
  static const String language = '/profile/language';

  /// About screen
  static const String about = '/profile/about';

  /// Support screen
  static const String support = '/profile/support';

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get project detail route with ID (uses singular /project to avoid shell conflict)
  static String projectDetailPath(String id) => '/project/$id';

  /// Get project details premium route with ID
  static String projectDetailsPremiumPath(String id) => '/project/details/$id';

  /// Get approval detail route with ID
  static String approvalDetailPath(String id) => '/approvals/$id';

  /// Get lead details route with ID
  static String leadDetailsPath(int id) => '/leads/$id';

  /// Apartment detail screen
  static const String apartmentDetail = '/apartment/:id';

  /// Get apartment detail route with ID
  static String apartmentDetailPath(int id) => '/apartment/$id';
}

/// Navigation tab indices for bottom navigation
abstract class NavTabIndex {
  static const int dashboard = 0;
  static const int analytics = 1;
  static const int projects = 2;
  static const int finance = 3;
  static const int approvals = 4;
}
