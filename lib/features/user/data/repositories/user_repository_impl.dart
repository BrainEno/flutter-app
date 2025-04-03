import 'dart:io';

import 'package:belog/core/common/entities/user.dart';
import 'package:belog/core/error/exceptions.dart';
import 'package:belog/core/error/failures.dart';
import 'package:belog/core/network/connection_checker.dart';
import 'package:belog/features/auth/data/models/user_model.dart';
import 'package:belog/features/user/data/datasources/user_remote_data_source.dart';

import 'package:belog/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const UserRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> editUserInfo({
    required String userId,
    required String name,
    required String email,
    required String website,
    required File? avatar,
  }) async {
    if (!await (connectionChecker.isConnected)) {
      return left(Failure('无法连接到网络'));
    }
    try {
      UserModel userToUpdate = await remoteDataSource.getUserById(userId);

      if (avatar != null) {
        final imageUrl =
            await remoteDataSource.uploadAvatar(userId: userId, image: avatar);
        userToUpdate = userToUpdate.copyWith(avatarUrl: imageUrl);
      }
      userToUpdate = userToUpdate.copyWith(
          id: userId,
          name: name,
          email: email,
          website: website,
          updatedAt: DateTime.now());

      final userUpdated = await remoteDataSource.editUserInfo(userToUpdate);
      return right(userUpdated);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
