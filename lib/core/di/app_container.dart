import '../../data/datasources/tenant_local_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/gym_repository_impl.dart';
import '../../data/repositories/membership_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/gym_repository.dart';
import '../../domain/repositories/membership_repository.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../../domain/usecases/get_current_gym.dart';
import '../../domain/usecases/login_member.dart';
import '../../domain/usecases/membership_usecases.dart';

class AppContainer {
  AppContainer._({
    required this.gymRepository,
    required this.authRepository,
    required this.membershipRepository,
    required this.adminRepository,
    required this.getCurrentGym,
    required this.loginMember,
    required this.logoutMember,
    required this.getDemoMembers,
    required this.getMembershipPlans,
    required this.getMemberSubscription,
    required this.subscribeToPlan,
    required this.loginAdmin,
    required this.logoutAdmin,
    required this.getDemoAdmins,
    required this.listGymMembers,
    required this.getDashboardStats,
    required this.addGymMember,
    required this.assignMemberPlan,
    required this.cancelMemberPlan,
    required this.addGymPlan,
  });

  final GymRepository gymRepository;
  final AuthRepository authRepository;
  final MembershipRepository membershipRepository;
  final AdminRepository adminRepository;
  final GetCurrentGym getCurrentGym;
  final LoginMember loginMember;
  final LogoutMember logoutMember;
  final GetDemoMembers getDemoMembers;
  final GetMembershipPlans getMembershipPlans;
  final GetMemberSubscription getMemberSubscription;
  final SubscribeToPlan subscribeToPlan;
  final LoginAdmin loginAdmin;
  final LogoutAdmin logoutAdmin;
  final GetDemoAdmins getDemoAdmins;
  final ListGymMembers listGymMembers;
  final GetDashboardStats getDashboardStats;
  final AddGymMember addGymMember;
  final AssignMemberPlan assignMemberPlan;
  final CancelMemberPlan cancelMemberPlan;
  final AddGymPlan addGymPlan;

  factory AppContainer.bootstrap() {
    final dataSource = TenantLocalDataSource();
    final gymRepository = GymRepositoryImpl(dataSource);
    final authRepository = AuthRepositoryImpl(dataSource);
    final membershipRepository = MembershipRepositoryImpl(dataSource);
    final adminRepository = AdminRepositoryImpl(dataSource);

    return AppContainer._(
      gymRepository: gymRepository,
      authRepository: authRepository,
      membershipRepository: membershipRepository,
      adminRepository: adminRepository,
      getCurrentGym: GetCurrentGym(gymRepository),
      loginMember: LoginMember(authRepository),
      logoutMember: LogoutMember(authRepository),
      getDemoMembers: GetDemoMembers(authRepository),
      getMembershipPlans: GetMembershipPlans(membershipRepository),
      getMemberSubscription: GetMemberSubscription(membershipRepository),
      subscribeToPlan: SubscribeToPlan(membershipRepository),
      loginAdmin: LoginAdmin(adminRepository),
      logoutAdmin: LogoutAdmin(adminRepository),
      getDemoAdmins: GetDemoAdmins(adminRepository),
      listGymMembers: ListGymMembers(adminRepository),
      getDashboardStats: GetDashboardStats(adminRepository),
      addGymMember: AddGymMember(adminRepository),
      assignMemberPlan: AssignMemberPlan(adminRepository),
      cancelMemberPlan: CancelMemberPlan(adminRepository),
      addGymPlan: AddGymPlan(adminRepository),
    );
  }
}
