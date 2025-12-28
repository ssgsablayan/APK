import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final messages = await apiService.getMessages();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load messages: $e')),
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
      onRefresh: _loadMessages,
      child: _messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No messages',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isRead = message['is_read'] == true;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isRead ? null : Colors.blue.shade50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.message,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    title: Text(
                      message['subject'] ?? 'No Subject',
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          message['body'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (message['created_at'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            message['created_at'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: isRead
                        ? null
                        : Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      // Navigate to message details
                    },
                  ),
                );
              },
            ),
    );
  }
}

