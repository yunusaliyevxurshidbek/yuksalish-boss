import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/funnel_models.dart';

/// List of clients in a funnel stage.
class FunnelClientList extends StatelessWidget {
  final List<FunnelClient> clients;
  final Color accentColor;
  final int maxItems;

  const FunnelClientList({
    super.key,
    required this.clients,
    required this.accentColor,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        children: clients.take(maxItems).map((client) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: accentColor.withValues(alpha: 0.12),
                  child: Text(
                    client.name.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    client.name,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                Text(
                  client.price,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
