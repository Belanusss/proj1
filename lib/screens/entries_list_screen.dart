import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entries_provider.dart';
import '../widgets/entry_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import 'add_entry_screen.dart';
import 'settings_screen.dart';

class EntriesListScreen extends StatefulWidget {
  const EntriesListScreen({super.key});

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.microtask(
      () => context.read<EntriesProvider>().fetchEntries(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EntriesProvider>(
        builder: (context, provider, child) {
          
          if (provider.isLoading && provider.entries.isEmpty) {
            return const LoadingIndicator(message: 'Uploading entries...');
          }

          
          if (provider.error != null && provider.entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Download error',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.fetchEntries(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          
          if (provider.entries.isEmpty) {
            return const EmptyState(
              icon: Icons.note_add,
              title: 'No entries',
              message: 'Add the first entry by clicking on the button. +',
            );
          }

          
          return RefreshIndicator(
            onRefresh: () => provider.fetchEntries(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.entries.length,
              itemBuilder: (context, index) {
                return EntryCard(entry: provider.entries[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEntryScreen(),
            ),
          );
          
          
          if (result == true) {
            if (mounted) {
              context.read<EntriesProvider>().fetchEntries();
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
