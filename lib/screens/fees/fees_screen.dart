import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  List<dynamic> _fees = [];
  bool _isLoading = true;
  int _totalFees = 0;
  int _paidFees = 0;
  int _unpaidFees = 0;
  double _totalAmount = 0;
  double _paidAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  Future<void> _loadFees() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final fees = await apiService.getMyFees();
      
      final paid = fees.where((f) => f['is_paid'] == true).toList();
      final unpaid = fees.where((f) => f['is_paid'] == false).toList();
      
      setState(() {
        _fees = fees;
        _totalFees = fees.length;
        _paidFees = paid.length;
        _unpaidFees = unpaid.length;
        _totalAmount = fees.fold<double>(
          0,
          (sum, fee) => sum + (fee['amount'] ?? 0.0),
        );
        _paidAmount = paid.fold<double>(
          0,
          (sum, fee) => sum + (fee['amount'] ?? 0.0),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load fees: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadFees,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    '$_totalFees',
                    Colors.blue,
                    Icons.receipt,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Paid',
                    '$_paidFees',
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Unpaid',
                    '$_unpaidFees',
                    Colors.red,
                    Icons.pending,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Amount Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount:',
                            style: TextStyle(color: Colors.grey[600])),
                        Text(
                          NumberFormat.currency(symbol: '₱').format(_totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paid Amount:',
                            style: TextStyle(color: Colors.grey[600])),
                        Text(
                          NumberFormat.currency(symbol: '₱').format(_paidAmount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Remaining:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          NumberFormat.currency(symbol: '₱')
                              .format(_totalAmount - _paidAmount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Fees List
            Text(
              'Fee Events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _fees.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No fees available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _fees.length,
                    itemBuilder: (context, index) {
                      final fee = _fees[index];
                      final isPaid = fee['is_paid'] == true;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isPaid
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isPaid ? Icons.check_circle : Icons.pending,
                              color: isPaid ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            fee['name'] ?? 'Fee',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Amount: ${NumberFormat.currency(symbol: '₱').format(fee['amount'] ?? 0)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              if (fee['due_date'] != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Due: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(fee['due_date']))}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isPaid ? 'PAID' : 'UNPAID',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
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

