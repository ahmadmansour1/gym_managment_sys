import '../../core/utils/result.dart';
import '../entities/member.dart';

abstract class AuthRepository {
  Future<Result<Member>> login({
    required String email,
    required String password,
  });

  Future<Result<List<Member>>> demoMembers();

  Member? get currentMember;

  void logout();
}
