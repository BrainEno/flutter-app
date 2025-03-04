part of 'blog_by_bloc.dart';

@immutable
sealed class BlogByEvent {}

final class GetBlogByPosterEvent extends BlogByEvent {
  final String userId;

  GetBlogByPosterEvent({required this.userId});
}
