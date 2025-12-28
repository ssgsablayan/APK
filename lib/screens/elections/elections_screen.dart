import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class ElectionsScreen extends StatelessWidget {
  const ElectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elections'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Provider.of<ApiService>(context, listen: false).getElections(),
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
                  Text('Error loading elections'),
                ],
              ),
            );
          }
          
          final elections = snapshot.data ?? [];
          
          if (elections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.how_to_vote, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No elections available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: elections.length,
            itemBuilder: (context, index) {
              final election = elections[index];
              final isActive = election['is_active'] == true;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.purple.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.how_to_vote,
                      color: isActive ? Colors.purple : Colors.grey,
                    ),
                  ),
                  title: Text(
                    election['title'] ?? 'Election',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    election['description'] ?? '',
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
                            color: Colors.purple,
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
                    // Navigate to election details
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

