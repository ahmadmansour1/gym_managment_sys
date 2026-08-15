import '../../data/datasources/tenant_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/gym_repository_impl.dart';
import '../../data/repositories/membership_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/gym_repository.dart';
import '../../domain/repositories/membership_repository.dart';
import '../../domain/usecases/get_current_gym.dart';
import '../../domain/usecases/login_member.dart';
import '../../domain/usecases/membership_usecases.dart';

class AppContainer {
  AppContainer._({
    required this.gymRepository,
    required this.authRepository,
    required this.membershipRepository,
    required this.getCurrentGym,
    required this.loginMember,
    required this.logoutMember,
    required this.getDemoMembers,
    required this.getMembershipPlans,
    required this.getMemberSubscription,
    required this.subscribeToPlan,
  });

  final GymRepository gymRepository;
  final AuthRepository authRepository;
  final MembershipRepository membershipRepository;
  final GetCurrentGym getCurrentGym;
  final LoginMember loginMember;
  final LogoutMember logoutMember;
  final GetDemoMembers getDemoMembers;
  final GetMembershipPlans getMembershipPlans;
  final GetMemberSubscription getMemberSubscription;
  final SubscribeToPlan subscribeToPlan;

  factory AppContainer.bootstrap() {
    final dataSource = TenantLocalDataSource();
    final gymRepository = GymRepositoryImpl(dataSource);
    final authRepository = AuthRepositoryImpl(dataSource);
    final membershipRepository = MembershipRepositoryImpl(dataSource);

    return AppContainer._(
      gymRepository: gymRepository,
      authRepository: authRepository,
      membershipRepository: membershipRepository,
      getCurrentGym: GetCurrentGym(gymRepository),
      loginMember: LoginMember(authRepository),
      logoutMember: LogoutMember(authRepository),
      getDemoMembers: GetDemoMembers(authRepository),
      getMembershipPlans: GetMembershipPlans(membershipRepository),
      getMemberSubscription: GetMemberSubscription(membershipRepository),
      subscribeToPlan: SubscribeToPlan(membershipRepository),
    );
  }
}
