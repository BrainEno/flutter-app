import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/presentation/blocs/blog_search/bloc/blog_search_bloc.dart';
import 'package:belog/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SearchBlogPage());
  const SearchBlogPage({super.key});

  @override
  State<SearchBlogPage> createState() => _SearchBlogPageState();
}

class _SearchBlogPageState extends State<SearchBlogPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Blog> _searchResults = [];

  void _onSearch(String query) {
    // Simulate search results (replace with your actual search logic)
    setState(() {
      if (query.isNotEmpty) {
        context.read<BlogSearchBloc>().add(SearchBlogsEvent(
              query: query,
            ));
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage('assets/images/icon.png'),
                  size: 30,
                ),
                SizedBox(
                  width: 7,
                ),
                const Text('Bottom Think'),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppPallete.greyColor.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _onSearch,
                decoration: InputDecoration(
                  hintText: '搜索',
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: AppPallete.whiteColor.withAlpha(70)),
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
                autofocus: false,
              ),
            ),
          ],
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
              ? BlocConsumer<BlogSearchBloc, BlogSearchState>(
                  listener: (context, state) {
                    if (state is BlogSearchFailure) {
                      showSnackBar(context, state.error);
                    } else if (state is BlogSearchSuccess) {
                      setState(() {
                        _searchResults = state.blogs;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: Text(
                        '加载中...',
                        style: TextStyle(
                            fontSize: 18, color: AppPallete.greyColor),
                      ),
                    );
                  },
                )
              : ListView.separated(
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _searchResults[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text('发布者：${_searchResults[index].posterName}'),
                      leading: Icon(Icons.article),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlogViewerPage(blog: _searchResults[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
