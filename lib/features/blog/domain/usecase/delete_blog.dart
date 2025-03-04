import 'package:belog/core/error/failures.dart';
import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<bool, DeleteBlogParams> {
  final BlogRepository blogRepository;

  const DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, bool>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({required this.blogId});
}
