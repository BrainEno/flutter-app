import 'package:belog/core/error/failures.dart';
import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class IsBlogLiked implements UseCase<bool, IsBlogLikedParams> {
  final BlogRepository blogRepository;
  const IsBlogLiked(this.blogRepository);

  @override
  Future<Either<Failure, bool>> call(IsBlogLikedParams params) {
    return blogRepository.isBlogLiked(params.userId, params.blogId);
  }
}

class IsBlogLikedParams {
  final String userId;
  final String blogId;

  IsBlogLikedParams({required this.userId, required this.blogId});
}
