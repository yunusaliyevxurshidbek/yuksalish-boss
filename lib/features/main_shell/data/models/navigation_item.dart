/// Model representing a navigation item in the main shell.
class NavigationItem {
  final String label;
  final String icon;
  final String activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
