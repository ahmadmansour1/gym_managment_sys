import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/tenant_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final TenantLocalDataSource _dataSource;
  Member? _currentMember;

  @override
  Member? get currentMember => _currentMember;

  @override
  Future<Result<Member>> login({
    required String email,
    required String password,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final match = snapshot.members.where(
        (account) =>
            account.entity.email.toLowerCase() == email.toLowerCase() &&
            account.password == password,
      );
      if (match.isEmpty) {
        return Result.err(
          const AuthFailure('No member found with those details at this gym.'),
        );
      }
      _currentMember = match.first.entity;
      return Result.ok(_currentMember!);
    } catch (error) {
      return Result.err(Failure('Could not sign in: $error'));
    }
  }

  @override
  Future<Result<List<Member>>> demoMembers() async {
    try {
      final snapshot = await _dataSource.loadTenant();
      return Result.ok(
        snapshot.members.map((account) => account.entity).toList(),
      );
    } catch (error) {
      return Result.err(Failure('Could not load members: $error'));
    }
  }

  @override
  void logout() {
    _currentMember = null;
  }
}
