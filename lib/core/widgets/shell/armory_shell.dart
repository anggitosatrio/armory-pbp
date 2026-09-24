import 'package:flutter/material.dart';

import '../../../features/auth/auth_scope.dart';
import '../../../features/auth/models/permissions.dart';
import '../../../features/auth/models/user.dart';
import '../../../features/categories/screens/categories_screen.dart';
import '../../../features/dashboard/screens/dashboard_screen.dart';
import '../../../features/inventory/screens/inventory_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../features/settings/screens/settings_screen.dart';
import '../../responsive/responsive_layout.dart';
import 'desktop_sidebar.dart';

class ArmoryShell extends StatefulWidget {
  const ArmoryShell({super.key});

  @override
  State<ArmoryShell> createState() => _ArmoryShellState();
}

class _ArmoryShellState extends State<ArmoryShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    InventoryScreen(),
    ProfileScreen(),
    CategoriesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = auth.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return ResponsiveLayout(
      mobile: _buildMobile(user),
      tablet: _buildTablet(user),
      desktop: _buildDesktop(user),
    );
  }

  Widget _buildDesktop(User user) {
    return Scaffold(
      body: Row(
        children: [
          DesktopSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: _onNavigationSelected,
            role: user.role,
          ),
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildTablet(User user) {
    return Scaffold(
      body: Row(
        children: [
          DesktopSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: _onNavigationSelected,
            role: user.role,
          ),
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(User user) {
  final destinations = _buildPrimaryMobileDestinations(user.role);

  final selectedDestinationIndex = _getMobileSelectedIndex(
    destinations,
  );

  return Scaffold(
    appBar: AppBar(
      title: const Text('ARMORY'),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More',
          onPressed: () {
            _showMoreMenu(user);
          },
        ),
      ],
    ),
    body: pages[selectedIndex],
    bottomNavigationBar: NavigationBar(
      selectedIndex: selectedDestinationIndex,
      onDestinationSelected: (destinationIndex) {
        final pageIndex = destinations[destinationIndex].pageIndex;

        _onNavigationSelected(pageIndex);
      },
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
          ),
      ],
    ),
  );
}

  List<_MobileDestination> _buildPrimaryMobileDestinations(
  UserRole role,
) {
  final destinations = <_MobileDestination>[];

  if (RolePermissions.can(
    role,
    AppPermission.viewDashboard,
  )) {
    destinations.add(
      const _MobileDestination(
        pageIndex: 0,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Home',
      ),
    );
  }

  if (RolePermissions.can(
    role,
    AppPermission.viewInventory,
  )) {
    destinations.add(
      const _MobileDestination(
        pageIndex: 1,
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Inventory',
      ),
    );
  }

  if (RolePermissions.can(
    role,
    AppPermission.viewProfile,
  )) {
    destinations.add(
      const _MobileDestination(
        pageIndex: 2,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    );
  }

  return destinations;
}

void _showMoreMenu(User user) {
  final canViewCategories = RolePermissions.can(
    user.role,
    AppPermission.viewCategories,
  );

  final canViewSettings = RolePermissions.can(
    user.role,
    AppPermission.viewSettings,
  );

  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'More',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (canViewCategories)
              ListTile(
                leading: const Icon(
                  Icons.category_outlined,
                ),
                title: const Text('Categories'),
                onTap: () {
                  Navigator.of(context).pop();
                  _onNavigationSelected(3);
                },
              ),

            if (canViewSettings)
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                ),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  _onNavigationSelected(4);
                },
              ),
          ],
        ),
      );
    },
  );
}

  int _getMobileSelectedIndex(
    List<_MobileDestination> destinations,
  ) {
    final index = destinations.indexWhere(
      (destination) => destination.pageIndex == selectedIndex,
    );

    return index == -1 ? 0 : index;
  }

  void _onNavigationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class _MobileDestination {
  final int pageIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _MobileDestination({
    required this.pageIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}