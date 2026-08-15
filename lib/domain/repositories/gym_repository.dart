import '../../core/utils/result.dart';
import '../entities/gym.dart';

abstract class GymRepository {
  Future<Result<Gym>> getCurrentGym();

  String get tenantId;
}
