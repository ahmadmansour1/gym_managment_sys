import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/member.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/subscription.dart';
import '../models/tenant_models.dart';

class TenantLocalDataSource {
  TenantLocalDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  TenantSnapshot? _snapshot;
  String? _tenantId;

  static const configPath = 'assets/mock/app_config.json';

  String get tenantId {
    final id = _tenantId;
    if (id == null) {
      throw StateError('Tenant has not been loaded yet.');
    }
    return id;
  }

  Future<TenantSnapshot> loadTenant() async {
    if (_snapshot != null) return _snapshot!;

    final configRaw = await _bundle.loadString(configPath);
    final config = jsonDecode(configRaw) as Map<String, dynamic>;
    final id = config['tenantId'] as String;
    _tenantId = id;

    final gymRaw = await _bundle.loadString('assets/mock/gyms/$id.json');
    final json = jsonDecode(gymRaw) as Map<String, dynamic>;
    final gym = GymModel.fromJson(json).entity;

    final plans = (json['plans'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((plan) => MembershipPlanModel.fromJson(plan, gymId: gym.id).entity)
        .toList();

    final members = (json['members'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((member) => MemberModel.fromJson(member, gymId: gym.id))
        .toList();

    final admins = (json['admins'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map((admin) => StaffModel.fromJson(admin, gymId: gym.id))
        .toList();

    final subscriptions = (json['subscriptions'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (subscription) =>
              SubscriptionModel.fromJson(subscription, gymId: gym.id).entity,
        )
        .toList();

    _snapshot = TenantSnapshot(
      gym: gym,
      plans: plans,
      members: members,
      admins: admins,
      subscriptions: subscriptions,
    );
    return _snapshot!;
  }

  void upsertSubscription(Subscription subscription) {
    final snapshot = _snapshot;
    if (snapshot == null) return;
    snapshot.subscriptions.removeWhere(
      (item) => item.memberId == subscription.memberId,
    );
    snapshot.subscriptions.add(subscription);
  }

  void addMember(MemberModel member) {
    _snapshot?.members.add(member);
  }

  void addPlan(MembershipPlan plan) {
    _snapshot?.plans.add(plan);
  }

  Member? memberById(String id) {
    final match = _snapshot?.members.where((item) => item.entity.id == id);
    if (match == null || match.isEmpty) return null;
    return match.first.entity;
  }
}
