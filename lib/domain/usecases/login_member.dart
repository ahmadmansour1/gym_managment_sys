import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/member.dart';
import '../repositories/auth_repository.dart';

class LoginMember {
  const LoginMember(this._repository);

  final AuthRepository _repository;

  Future<Result<Member>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return Future.value(
        Result.err(const ValidationFailure('Email and password are required.')),
      );
    }
    return _repository.login(email: email.trim(), password: password);
  }
}

class LogoutMember {
  const LogoutMember(this._repository);

  final AuthRepository _repository;

  void call() => _repository.logout();
}

class GetDemoMembers {
  const GetDemoMembers(this._repository);

  final AuthRepository _repository;

  Future<Result<List<Member>>> call() => _repository.demoMembers();
}
