import '../../core/utils/date_format.dart';
import '../../domain/entities/brand_theme.dart';
import '../../domain/entities/gym.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/subscription.dart';

class BrandThemeModel {
  const BrandThemeModel(this.entity);

  final BrandTheme entity;

  factory BrandThemeModel.fromJson(Map<String, dynamic> json) {
    return BrandThemeModel(
      BrandTheme(
        brightness: json['brightness'] == 'light'
            ? ThemeBrightness.light
            : ThemeBrightness.dark,
        primaryHex: json['primary'] as String,
        secondaryHex: json['secondary'] as String,
        accentHex: json['accent'] as String,
        backgroundHex: json['background'] as String,
        surfaceHex: json['surface'] as String,
        surfaceVariantHex: json['surfaceVariant'] as String,
        onPrimaryHex: json['onPrimary'] as String,
        onBackgroundHex: json['onBackground'] as String,
        onSurfaceHex: json['onSurface'] as String,
        mutedHex: json['muted'] as String,
        successHex: json['success'] as String,
        errorHex: json['error'] as String,
        borderRadius: (json['borderRadius'] as num).toDouble(),
        buttonShape: _buttonShape(json['buttonShape'] as String?),
        cardStyle: _cardStyle(json['cardStyle'] as String?),
        titleStyle: _titleStyle(json['titleStyle'] as String?),
      ),
    );
  }

  static ButtonShape _buttonShape(String? value) {
    return switch (value) {
      'pill' => ButtonShape.pill,
      'square' => ButtonShape.square,
      _ => ButtonShape.rounded,
    };
  }

  static CardStyle _cardStyle(String? value) {
    return switch (value) {
      'elevated' => CardStyle.elevated,
      'outlined' => CardStyle.outlined,
      _ => CardStyle.filled,
    };
  }

  static TitleStyle _titleStyle(String? value) {
    return switch (value) {
      'elegant' => TitleStyle.elegant,
      'modern' => TitleStyle.modern,
      _ => TitleStyle.athletic,
    };
  }
}

class MembershipPlanModel {
  const MembershipPlanModel(this.entity);

  final MembershipPlan entity;

  factory MembershipPlanModel.fromJson(
    Map<String, dynamic> json, {
    required String gymId,
  }) {
    return MembershipPlanModel(
      MembershipPlan(
        id: json['id'] as String,
        gymId: gymId,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        currency: json['currency'] as String,
        durationMonths: json['durationMonths'] as int,
        durationDays: json['durationDays'] as int,
        features: (json['features'] as List<dynamic>).cast<String>(),
        isFeatured: json['isFeatured'] as bool? ?? false,
        isPopular: json['isPopular'] as bool? ?? false,
      ),
    );
  }
}

class MemberModel {
  const MemberModel({required this.entity, required this.password});

  final Member entity;
  final String password;

  factory MemberModel.fromJson(
    Map<String, dynamic> json, {
    required String gymId,
  }) {
    return MemberModel(
      entity: Member(
        id: json['id'] as String,
        gymId: gymId,
        name: json['name'] as String,
        email: json['email'] as String,
      ),
      password: json['password'] as String,
    );
  }
}

class SubscriptionModel {
  const SubscriptionModel(this.entity);

  final Subscription entity;

  factory SubscriptionModel.fromJson(
    Map<String, dynamic> json, {
    required String gymId,
  }) {
    final expiresAt = parseIsoDate(json['expiresAt'] as String);
    final statusName = json['status'] as String?;
    var status = statusName == 'expired'
        ? SubscriptionStatus.expired
        : SubscriptionStatus.active;
    final today = DateTime.now();
    final endOfExpiry = DateTime(
      expiresAt.year,
      expiresAt.month,
      expiresAt.day,
      23,
      59,
    );
    if (today.isAfter(endOfExpiry)) {
      status = SubscriptionStatus.expired;
    }

    return SubscriptionModel(
      Subscription(
        id: json['id'] as String,
        gymId: gymId,
        memberId: json['memberId'] as String,
        planId: json['planId'] as String,
        planName: json['planName'] as String,
        startsAt: parseIsoDate(json['startsAt'] as String),
        expiresAt: expiresAt,
        status: status,
      ),
    );
  }
}

class GymModel {
  const GymModel(this.entity);

  final Gym entity;

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      Gym(
        id: json['id'] as String,
        name: json['name'] as String,
        tagline: json['tagline'] as String,
        city: json['city'] as String,
        hours: json['hours'] as String,
        icon: json['icon'] as String,
        theme: BrandThemeModel.fromJson(
          json['theme'] as Map<String, dynamic>,
        ).entity,
      ),
    );
  }
}

class TenantSnapshot {
  TenantSnapshot({
    required this.gym,
    required this.plans,
    required this.members,
    required this.subscriptions,
  });

  final Gym gym;
  final List<MembershipPlan> plans;
  final List<MemberModel> members;
  final List<Subscription> subscriptions;
}
