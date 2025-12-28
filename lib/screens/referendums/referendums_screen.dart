import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class ReferendumsScreen extends StatelessWidget {
  const ReferendumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referendums'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Provider.of<ApiService>(context, listen: false).getReferendums(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error loading referendums'),
                ],
              ),
            );
          }
          
          final referendums = snapshot.data ?? [];
          
          if (referendums.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ballot, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No referendums available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: referendums.length,
            itemBuilder: (context, index) {
              final referendum = referendums[index];
              final isActive = referendum['is_active'] == true;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.indigo.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.ballot,
                      color: isActive ? Colors.indigo : Colors.grey,
                    ),
                  ),
                  title: Text(
                    referendum['title'] ?? 'Referendum',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    referendum['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isActive
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    // Navigate to referendum details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

