import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../data/models/apartment.dart';
import '../../data/repositories/projects_repository.dart';
import '../widgets/apartment_detail_cards.dart';
import '../widgets/apartment_detail_states.dart';

class ApartmentDetailScreen extends StatefulWidget {
  final int apartmentId;

  const ApartmentDetailScreen({
    super.key,
    required this.apartmentId,
  });

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> {
  final ProjectsRepository _repository = GetIt.I<ProjectsRepository>();

  Apartment? _apartment;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadApartment();
  }

  Future<void> _loadApartment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apartment = await _repository.getApartmentById(widget.apartmentId);
      if (mounted) {
        setState(() {
          _apartment = apartment;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final backButton = ApartmentBackButton(
      onPressed: () => Navigator.of(context).pop(),
    );

    if (_isLoading) {
      return ApartmentDetailLoadingState(backButton: backButton);
    }

    if (_error != null) {
      return ApartmentDetailErrorState(
        error: _error,
        onRetry: _loadApartment,
        onBack: () => Navigator.of(context).pop(),
      );
    }

    if (_apartment == null) {
      return ApartmentDetailEmptyState(
        onBack: () => Navigator.of(context).pop(),
      );
    }

    return _buildContent(_apartment!);
  }

  Widget _buildContent(Apartment apartment) {
    return CustomScrollView(
      slivers: [
        ApartmentDetailSliverAppBar(
          apartment: apartment,
          backButton: ApartmentBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApartmentDetailHeader(apartment: apartment),
                SizedBox(height: 24.h),
                ApartmentMainInfoCard(apartment: apartment),
                SizedBox(height: 16.h),
                ApartmentPriceCard(apartment: apartment),
                SizedBox(height: 16.h),
                ApartmentDetailsCard(apartment: apartment),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

