import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final events = await apiService.getEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: $e')),
        );
      }
    }
  }

  Color _getEventTypeColor(String? type) {
    switch (type) {
      case 'ssg':
        return Colors.blue;
      case 'club':
        return Colors.purple;
      case 'department':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: _events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No events available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                final eventDate = event['event_date'] != null
                    ? DateTime.parse(event['event_date'])
                    : null;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(event['event_type'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event,
                        color: _getEventTypeColor(event['event_type']),
                      ),
                    ),
                    title: Text(
                      event['title'] ?? 'Untitled Event',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eventDate != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM dd, yyyy').format(eventDate),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (event['location'] != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                event['location'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(event['event_type'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event['event_type']?.toUpperCase() ?? 'EVENT',
                        style: TextStyle(
                          color: _getEventTypeColor(event['event_type']),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to event details
                    },
                  ),
                );
              },
            ),
    );
  }
}

