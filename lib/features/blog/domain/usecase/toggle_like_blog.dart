import 'package:belog/core/error/failures.dart';
import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class ToggleLikeBlog implements UseCase<bool, ToggleLikeParams> {
  final BlogRepository blogRepository;
  const ToggleLikeBlog(this.blogRepository);

  @override
  Future<Either<Failure, bool>> call(ToggleLikeParams params) {
    return blogRepository.toggleLikeBlog(params.userId, params.blogId);
  }
}

class ToggleLikeParams {
  final String userId;
  final String blogId;

  ToggleLikeParams({required this.userId, required this.blogId});
}
