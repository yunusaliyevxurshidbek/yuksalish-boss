import 'models/navigation_item.dart';

/// Configuration for main navigation items.
class NavigationConfig {
  static List<NavigationItem> getMainItems() {
    return const [
      NavigationItem(
        label: 'Home',
        icon: 'assets/icons/home.svg',
        activeIcon: 'assets/icons/home_filled.svg',
        route: '/dashboard',
      ),
      NavigationItem(
        label: 'Profile',
        icon: 'assets/icons/profile.svg',
        activeIcon: 'assets/icons/profile_filled.svg',
        route: '/profile',
      ),
    ];
  }
}
