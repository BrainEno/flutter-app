part of 'user_edit_bloc.dart';

abstract class UserEditEvent extends Equatable {
  const UserEditEvent();

  @override
  List<Object> get props => [];
}

class UserEditSubmitted extends UserEditEvent {
  final String name;
  final String email;
  final String? website;
  final File? avatar;

  const UserEditSubmitted({
    required this.name,
    required this.email,
    this.website,
    this.avatar,
  });

  @override
  List<Object> get props => [name, email, avatar ?? '', website ?? ''];
}
