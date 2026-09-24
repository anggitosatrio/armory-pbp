import 'user.dart';

enum AppPermission {
  viewDashboard,
  viewInventory,
  viewProductDetail,
  viewProfile,
  viewCategories,
  viewSettings,
}

abstract final class RolePermissions {
  static const Map<UserRole, Set<AppPermission>> permissions = {
    UserRole.administrator: {
      AppPermission.viewDashboard,
      AppPermission.viewInventory,
      AppPermission.viewProductDetail,
      AppPermission.viewProfile,
      AppPermission.viewCategories,
      AppPermission.viewSettings,
    },

    UserRole.operator: {
      AppPermission.viewDashboard,
      AppPermission.viewInventory,
      AppPermission.viewProductDetail,
      AppPermission.viewProfile,
    },

    UserRole.viewer: {
      AppPermission.viewDashboard,
      AppPermission.viewInventory,
      AppPermission.viewProductDetail,
      AppPermission.viewProfile,
    },
  };

  static bool can(
    UserRole role,
    AppPermission permission,
  ) {
    return permissions[role]?.contains(permission) ?? false;
  }

  static bool canAccess(
    User? user,
    AppPermission permission,
  ) {
    if (user == null) {
      return false;
    }

    return can(user.role, permission);
  }
}