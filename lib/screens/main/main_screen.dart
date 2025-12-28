import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../events/events_screen.dart';
import '../fees/fees_screen.dart';
import '../clearance/clearance_screen.dart';
import '../library/library_screen.dart';
import '../elections/elections_screen.dart';
import '../referendums/referendums_screen.dart';
import '../messages/messages_screen.dart';
import '../qr_code/qr_code_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const EventsScreen(),
    const FeesScreen(),
    const ClearanceScreen(),
    const MessagesScreen(),
  ];

  final List<NavigationDestination> _navItems = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Dashboard',
    ),
    const NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Events',
    ),
    const NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: 'Fees',
    ),
    const NavigationDestination(
      icon: Icon(Icons.description_outlined),
      selectedIcon: Icon(Icons.description),
      label: 'Clearance',
    ),
    const NavigationDestination(
      icon: Icon(Icons.message_outlined),
      selectedIcon: Icon(Icons.message),
      label: 'Messages',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(_getAppBarTitle()),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: _navItems,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Events';
      case 2:
        return 'My Fees';
      case 3:
        return 'My Clearance';
      case 4:
        return 'Messages';
      default:
        return 'Student Governance';
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.purple.shade600],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.blue.shade700,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Student Governance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'OMSC - Sablayan Campus',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          _buildDrawerItem(
            icon: Icons.calendar_today,
            title: 'Events',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 1);
            },
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            title: 'My Fees',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          _buildDrawerItem(
            icon: Icons.description,
            title: 'My Clearance',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 3);
            },
          ),
          _buildDrawerItem(
            icon: Icons.library_books,
            title: 'Document Library',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LibraryScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.how_to_vote,
            title: 'Elections',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ElectionsScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.ballot,
            title: 'Referendums',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferendumsScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.message,
            title: 'Messages',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 4);
            },
          ),
          _buildDrawerItem(
            icon: Icons.qr_code,
            title: 'My QR Code',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QRCodeScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

