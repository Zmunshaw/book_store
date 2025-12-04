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
                          if (_tabs.length > 1) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _closeTab(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTabDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Tab'),
      ),
    );
  }

  void _closeTab(int index) {
    if (_tabs.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot close the last tab'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _tabs.removeAt(index);

      // Adjust current index if needed
      if (_currentIndex >= _tabs.length) {
        _currentIndex = _tabs.length - 1;
      } else if (index < _currentIndex) {
        _currentIndex--;
      }

      // Recreate tab controller
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
        initialIndex: _currentIndex,
      );
      _tabController.addListener(_handleTabChange);
    });
  }

  void _showAddTabDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open New Tab'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTabOption(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () {
                _addTab(NavigationTab(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  view: const HomeView(),
                ));
                Navigator.pop(context);
              },
            ),
            _buildTabOption(
              icon: Icons.menu_book_outlined,
              label: 'Books',
              onTap: () {
                _addTab(NavigationTab(
                  label: 'Books',
                  icon: Icons.menu_book_outlined,
                  selectedIcon: Icons.menu_book,
                  view: const BooksView(),
                ));
                Navigator.pop(context);
              },
            ),
            _buildTabOption(
              icon: Icons.collections_bookmark_outlined,
              label: 'Collections',
              onTap: () {
                _addTab(NavigationTab(
                  label: 'Collections',
                  icon: Icons.collections_bookmark_outlined,
                  selectedIcon: Icons.collections_bookmark,
                  view: const CollectionsView(),
                ));
                Navigator.pop(context);
              },
            ),
            _buildTabOption(
              icon: Icons.person_outline,
              label: 'Account',
              onTap: () {
                _addTab(NavigationTab(
                  label: 'Account',
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  view: const LoginView(),
                ));
                Navigator.pop(context);
              },
            ),
            _buildTabOption(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                _addTab(NavigationTab(
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  view: const SettingsView(),
                ));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }

  void _addTab(NavigationTab tab) {
    setState(() {
      _tabs.add(tab);
      _currentIndex = _tabs.length - 1;

      // Recreate tab controller
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
        initialIndex: _currentIndex,
      );
      _tabController.addListener(_handleTabChange);
    });
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
