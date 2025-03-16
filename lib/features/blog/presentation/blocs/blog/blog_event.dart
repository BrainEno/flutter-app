part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogFetchAllBlogs extends BlogEvent {
  final int page;
  final bool refresh;

  BlogFetchAllBlogs({this.page = 1, this.refresh = false});

  List<Object?> get props => [page, refresh];
}
