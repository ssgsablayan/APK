import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final data = await apiService.getDashboard();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dashboard: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = _dashboardData?['stats'] ?? {};
    final user = _dashboardData?['user'] ?? {};

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['first_name'] ?? 'Student',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Grid
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  title: 'Pending Clearances',
                  value: '${stats['pendingClearances'] ?? 0}',
                  icon: Icons.description,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Unpaid Fees',
                  value: '${stats['unpaidFees'] ?? 0}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.red,
                ),
                StatCard(
                  title: 'Ongoing Elections',
                  value: '${stats['ongoingElections'] ?? 0}',
                  icon: Icons.how_to_vote,
                  color: Colors.purple,
                ),
                StatCard(
                  title: 'Unread Messages',
                  value: '${stats['unreadMessages'] ?? 0}',
                  icon: Icons.message,
                  color: Colors.cyan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

