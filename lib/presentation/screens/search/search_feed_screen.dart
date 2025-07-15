import 'package:flutter/material.dart';
import 'package:frontend/data/services/search_service.dart';
import 'package:frontend/presentation/widgets/search/allsearch_results.dart';
import 'package:frontend/presentation/widgets/search/explore_feed.dart';
import 'package:frontend/presentation/widgets/search/segmant_divider.dart';

import 'package:frontend/presentation/widgets/search/searchbar.dart';

import 'package:frontend/presentation/widgets/search/category_selector.dart';

class SearchFeedScreen extends StatefulWidget {
  const SearchFeedScreen({Key? key}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _hasSearched = false;
  int _selectedSegment = 0;

  final List<String> _segments = [
    'All',
    'People',
    'Fanbases',
    'Song Posts',
    'Posts',
    'Profiles',
  ];

  final SearchService _searchService = SearchService();
  Map<String, List<Map<String, dynamic>>> _searchResults = {};
  bool _isLoading = false;
  String? _error;

  void _onSearchSubmitted(String query) async {
    setState(() {
      _query = query;
      _hasSearched = query.trim().isNotEmpty;
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _searchService.search(query);
      setState(() {
        _searchResults = {
          'users': List<Map<String, dynamic>>.from(results['users'] ?? []),
          'fanbases':
              List<Map<String, dynamic>>.from(results['fanbases'] ?? []),
          'posts': List<Map<String, dynamic>>.from(results['posts'] ?? []),
          'profiles':
              List<Map<String, dynamic>>.from(results['profiles'] ?? []),
          'songPosts':
              List<Map<String, dynamic>>.from(results['songPosts'] ?? []),
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _query = query;
    });
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items,
      String titleKey, String subtitleKey) {
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

  final List<String> _exploreImages = [
    'assets/images/hehe.png',
    'assets/images/hehe.png',
    'assets/images/hehe.png',
  ];

  final List<String> _categories = [
    'Trending',
    'Pop',
    'Superhits',
    'Kollywood',
    'Raps',
    'Kpop'
  ];
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final showResults = _hasSearched && _query.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: InstagramSearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (!showResults)
            CategorySelector(
              categories: _categories,
              selectedIndex: _selectedCategory,
              onCategorySelected: (index) {
                setState(() {
                  _selectedCategory = index;
                });
              },
            ),
          Expanded(
            child: showResults
                ? Column(
                    children: [
                      SegmentDivider(
                        segments: _segments,
                        selectedIndex: _selectedSegment,
                        onSegmentSelected: (index) {
                          setState(() {
                            _selectedSegment = index;
                          });
                        },
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _error != null
                                ? Center(child: Text('Error: $_error'))
                                : ListView(
                                    children: [
                                      if (_selectedSegment == 0)
                                        AllSearchResults(
                                          results: _searchResults,
                                          query: _query,
                                        ),
                                      if (_selectedSegment == 1)
                                        _buildSection(
                                            'People',
                                            _searchResults['users'] ?? [],
                                            'name',
                                            'email'),
                                      if (_selectedSegment == 2)
                                        _buildSection(
                                            'Fanbases',
                                            _searchResults['fanbases'] ?? [],
                                            'name',
                                            'description'),
                                      if (_selectedSegment == 3)
                                        _buildSection(
                                            'Song Posts',
                                            _searchResults['songPosts'] ?? [],
                                            'name',
                                            'artists'),
                                      if (_selectedSegment == 4)
                                        _buildSection(
                                            'Posts',
                                            _searchResults['posts'] ?? [],
                                            'songTitle',
                                            'artistName'),
                                      if (_selectedSegment == 5)
                                        _buildSection(
                                            'Profiles',
                                            _searchResults['profiles'] ?? [],
                                            'username',
                                            'bio'),
                                    ],
                                  ),
                      ),
                    ],
                  )
                : ExploreFeed(imageUrls: _exploreImages),
          ),
        ],
      ),
    );
  }
}
