import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class ClearanceScreen extends StatefulWidget {
  const ClearanceScreen({super.key});

  @override
  State<ClearanceScreen> createState() => _ClearanceScreenState();
}

class _ClearanceScreenState extends State<ClearanceScreen> {
  List<dynamic> _clearances = [];
  bool _isLoading = true;
  int _pendingCount = 0;
  int _approvedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadClearances();
  }

  Future<void> _loadClearances() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final clearances = await apiService.getClearances();
      
      setState(() {
        _clearances = clearances;
        _pendingCount = clearances.where((c) => c['status'] == 'pending').length;
        _approvedCount = clearances.where((c) => c['status'] == 'approved').length;
        _rejectedCount = clearances.where((c) => c['status'] == 'rejected').length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load clearances: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadClearances,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    '$_pendingCount',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Approved',
                    '$_approvedCount',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Rejected',
                    '$_rejectedCount',
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Action Button
            ElevatedButton.icon(
              onPressed: () {
                // Request all clearances
              },
              icon: const Icon(Icons.add),
              label: const Text('Request All Clearances'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
            const SizedBox(height: 24),
            
            // Clearances List
            Text(
              'My Clearances',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _clearances.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Icon(Icons.description,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No clearance requests',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _clearances.length,
                    itemBuilder: (context, index) {
                      final clearance = _clearances[index];
                      final status = clearance['status'] ?? 'pending';
                      final statusColor = _getStatusColor(status);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getStatusIcon(status),
                              color: statusColor,
                            ),
                          ),
                          title: Text(
                            clearance['organization_name'] ?? 'Organization',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${status.toUpperCase()}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (clearance['requested_at'] != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Requested: ${clearance['requested_at']}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

