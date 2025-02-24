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
        title: Container(
          decoration: BoxDecoration(
            color: AppPallete.greyColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: '搜索',
              border: InputBorder.none,
              hintStyle: TextStyle(color: AppPallete.whiteColor.withAlpha(70)),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: Icon(Icons.search,
                  color: AppPallete.whiteColor.withAlpha(70)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppPallete.whiteColor),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchResults = [];
                        });
                      },
                    )
                  : null,
            ),
            style: TextStyle(color: AppPallete.whiteColor),
            autofocus: true,
          ),
        ),
      ),
      body: _searchController.text.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: AppPallete.greyColor),
                  SizedBox(height: 16),
                  Text(
                    '查找文章...',
                    style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
                  ),
                ],
              ),
            )
          : _searchResults.isEmpty
              ? Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
                  ),
                )
              : ListView.separated(
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _searchResults[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text('Subtitle for ${_searchResults[index]}'),
                      leading: Icon(Icons.article),
                    );
                  },
                ),
    );
  }
}
