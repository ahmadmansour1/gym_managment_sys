import '../../core/utils/result.dart';
import '../entities/gym.dart';
import '../repositories/gym_repository.dart';

class GetCurrentGym {
  const GetCurrentGym(this._repository);

  final GymRepository _repository;

  Future<Result<Gym>> call() => _repository.getCurrentGym();
}
