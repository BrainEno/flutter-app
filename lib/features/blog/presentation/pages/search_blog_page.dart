import 'package:belog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class SearchBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SearchBlogPage());
  const SearchBlogPage({super.key});

  @override
  State<SearchBlogPage> createState() => _SearchBlogPageState();
}

class _SearchBlogPageState extends State<SearchBlogPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _onSearchChanged(String query) {
    // Simulate search results (replace with your actual search logic)
    setState(() {
      if (query.isNotEmpty) {
        _searchResults = [
          'Result for "$query" 1',
          'Result for "$query" 2',
          'Another Result for "$query"',
          'Related Result for "$query"',
        ];
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: '搜索...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppPallete.whiteColor.withAlpha(70)),
          ),
          style: TextStyle(color: AppPallete.whiteColor),
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchResults = [];
                });
              },
            ),
        ],
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: Text(
                'Search for blogs...',
                style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                  // Add onTap or other actions as needed
                );
              },
            ),
    );
  }
}
