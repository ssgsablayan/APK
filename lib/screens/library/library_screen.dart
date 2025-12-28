import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Library'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Provider.of<ApiService>(context, listen: false).getDocuments(),
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
                  Text('Error loading documents'),
                ],
              ),
            );
          }
          
          final documents = snapshot.data ?? [];
          
          if (documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No documents available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.description,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: Text(
                    doc['name'] ?? 'Document',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doc['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // Download document
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

