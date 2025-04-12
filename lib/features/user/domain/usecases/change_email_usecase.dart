import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/core/error/failures.dart';
import 'package:belog/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangeEmailUseCase implements UseCase<void, String> {
  final UserRepository repository;

  const ChangeEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String newEmail) {
    return repository.changeEmail(newEmail);
  }
}
