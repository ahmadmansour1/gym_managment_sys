import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';
import '../datasources/tenant_local_datasource.dart';

class GymRepositoryImpl implements GymRepository {
  GymRepositoryImpl(this._dataSource);

  final TenantLocalDataSource _dataSource;

  @override
  String get tenantId => _dataSource.tenantId;

  @override
  Future<Result<Gym>> getCurrentGym() async {
    try {
      final snapshot = await _dataSource.loadTenant();
      return Result.ok(snapshot.gym);
    } catch (error) {
      return Result.err(Failure('Could not load this gym: $error'));
    }
  }
}
