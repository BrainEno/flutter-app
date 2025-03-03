part of 'blog_search_bloc.dart';

abstract class BlogSearchEvent {
  final String query;

  BlogSearchEvent({required this.query});
}

class SearchBlogsEvent extends BlogSearchEvent {
  SearchBlogsEvent({required super.query});
}
