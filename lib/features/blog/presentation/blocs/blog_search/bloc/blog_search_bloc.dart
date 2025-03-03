import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/domain/usecase/search_blogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_search_event.dart';
part 'blog_search_state.dart';

class BlogSearchBloc extends Bloc<BlogSearchEvent, BlogSearchState> {
  final SearchBlogs _searchBlogs;

  BlogSearchBloc({required SearchBlogs searchBlogs})
      : _searchBlogs = searchBlogs,
        super(BlogSearchInitial()) {
    on<SearchBlogsEvent>(_onSearchBlogs);
  }

  void _onSearchBlogs(
      SearchBlogsEvent event, Emitter<BlogSearchState> emit) async {
    emit(BlogSearchLoading());
    final res = await _searchBlogs(SearchBlogsParams(query: event.query));

    res.fold(
      (failure) => emit(BlogSearchFailure(error: failure.message)),
      (blogs) => emit(BlogSearchSuccess(blogs: blogs)),
    );
  }
}
