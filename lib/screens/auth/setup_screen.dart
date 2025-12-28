import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedDepartment;
  String? _selectedYearLevel;
  String? _selectedSection;
  List<String> _selectedClubs = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.completeSetup({
        'password': _newPasswordController.text,
        'department_id': _selectedDepartment,
        'year_level': _selectedYearLevel,
        'section': _selectedSection,
        'club_ids': _selectedClubs,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Password Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Profile Setup Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Setup',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('Department 1')),
                          DropdownMenuItem(value: '2', child: Text('Department 2')),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedDepartment = value);
                        },
                        validator: (value) {
                          if (value == null) return 'Please select a department';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedYearLevel,
                        decoration: const InputDecoration(
                          labelText: 'Year Level',
                          prefixIcon: Icon(Icons.grade),
                        ),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('1st Year')),
                          DropdownMenuItem(value: '2', child: Text('2nd Year')),
                          DropdownMenuItem(value: '3', child: Text('3rd Year')),
                          DropdownMenuItem(value: '4', child: Text('4th Year')),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedYearLevel = value);
                        },
                        validator: (value) {
                          if (value == null) return 'Please select year level';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSection,
                        decoration: const InputDecoration(
                          labelText: 'Section',
                          prefixIcon: Icon(Icons.group),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'A', child: Text('Section A')),
                          DropdownMenuItem(value: 'B', child: Text('Section B')),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedSection = value);
                        },
                        validator: (value) {
                          if (value == null) return 'Please select section';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Club Memberships',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildClubChip('Club 1'),
                          _buildClubChip('Club 2'),
                          _buildClubChip('Club 3'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSetup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Complete Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClubChip(String club) {
    final isSelected = _selectedClubs.contains(club);
    return FilterChip(
      label: Text(club),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedClubs.add(club);
          } else {
            _selectedClubs.remove(club);
          }
        });
      },
    );
  }
}

