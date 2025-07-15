import 'package:flutter/material.dart';

class AllSearchResults extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> results;
  final String? query;

  const AllSearchResults({
    Key? key,
    required this.results,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allResults = results.values.expand((list) => list).toList();

    if (allResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            query == null || query!.isEmpty
                ? 'Start typing to search...'
                : 'No results found for "$query"',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      children: [
        _buildSection('Users', results['users'] ?? [], 'username', 'email'),
        _buildSection('Profiles', results['profiles'] ?? [], 'username', 'bio'),
        _buildSection('Fanbases', results['fanbases'] ?? [], 'name', 'description'),
        _buildSection('Posts', results['posts'] ?? [], 'songTitle', 'artistName'),
        _buildSection('Song Posts', results['songPosts'] ?? [], 'songName', 'artists'),
      ],
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items, String titleKey, String subtitleKey) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/hehe.png'),
              ),
              title: Text(item[titleKey] ?? ''),
              subtitle: Text(item[subtitleKey] ?? ''),
              onTap: () {},
            )),
        const Divider(),
      ],
    );
  }
}
