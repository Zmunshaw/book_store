import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/books_view.dart';
import '../views/collections_view.dart';
import '../views/login_view.dart';
import '../views/settings_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<NavigationTab> _tabs = [
    NavigationTab(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      view: const HomeView(),
    ),
    NavigationTab(
      label: 'Books',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
      view: const BooksView(),
    ),
    NavigationTab(
      label: 'Collections',
      icon: Icons.collections_bookmark_outlined,
      selectedIcon: Icons.collections_bookmark,
      view: const CollectionsView(),
    ),
    NavigationTab(
      label: 'Account',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      view: const LoginView(),
    ),
    NavigationTab(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      view: const SettingsView(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Browser-style tab bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                tabs: _tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isSelected = index == _currentIndex;

                  return Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? tab.selectedIcon : tab.icon,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(tab.label),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) => tab.view).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationTab {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget view;

  NavigationTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.view,
  });
}
