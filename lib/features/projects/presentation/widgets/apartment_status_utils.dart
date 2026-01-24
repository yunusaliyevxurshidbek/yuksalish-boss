import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/apartment.dart';

/// Utility functions for apartment status display.
class ApartmentStatusUtils {
  ApartmentStatusUtils._();

  /// Gets the color associated with the apartment status.
  static Color getStatusColor(ApartmentStatus status) {
    switch (status) {
      case ApartmentStatus.available:
        return AppColors.success;
      case ApartmentStatus.reserved:
        return AppColors.warning;
      case ApartmentStatus.sold:
        return AppColors.primary;
      case ApartmentStatus.notForSale:
        return AppColors.textTertiary;
      case ApartmentStatus.handedOver:
        return AppColors.info;
    }
  }

  /// Builds a status badge widget for the apartment status.
  static Widget buildStatusBadge(ApartmentStatus status) {
    switch (status) {
      case ApartmentStatus.available:
        return StatusBadge.success(status.displayName);
      case ApartmentStatus.reserved:
        return StatusBadge.warning(status.displayName);
      case ApartmentStatus.sold:
        return StatusBadge.info(status.displayName);
      case ApartmentStatus.notForSale:
        return StatusBadge.neutral(status.displayName);
      case ApartmentStatus.handedOver:
        return StatusBadge.info(status.displayName);
    }
  }
}
