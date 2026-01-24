import 'package:equatable/equatable.dart';

import '../../../dashboard/data/models/crm_stats_model.dart';
import '../../data/models/apartment_model.dart';
import '../../data/models/builder_stats_model.dart';

/// Combined statistics for sold apartments
class SoldApartmentsStats extends Equatable {
  final int soldCount;
  final double soldValue;
  final double averagePrice;
  final double soldPercentage;
  final int totalUnits;
  final int availableUnits;
  final int reservedUnits;
  final int activeProjects;
  final int completedProjects;
  final Map<int, int> roomDistribution; // rooms -> count
  final Map<String, int> projectDistribution; // projectName -> count
  final double apartmentsTrend; // From CRM stats

  const SoldApartmentsStats({
    required this.soldCount,
    required this.soldValue,
    required this.averagePrice,
    required this.soldPercentage,
    required this.totalUnits,
    required this.availableUnits,
    required this.reservedUnits,
    required this.activeProjects,
    required this.completedProjects,
    required this.roomDistribution,
    required this.projectDistribution,
    required this.apartmentsTrend,
  });

  factory SoldApartmentsStats.empty() {
    return const SoldApartmentsStats(
      soldCount: 0,
      soldValue: 0,
      averagePrice: 0,
      soldPercentage: 0,
      totalUnits: 0,
      availableUnits: 0,
      reservedUnits: 0,
      activeProjects: 0,
      completedProjects: 0,
      roomDistribution: {},
      projectDistribution: {},
      apartmentsTrend: 0,
    );
  }

  @override
  List<Object?> get props => [
        soldCount,
        soldValue,
        averagePrice,
        soldPercentage,
        totalUnits,
        availableUnits,
        reservedUnits,
        activeProjects,
        completedProjects,
        roomDistribution,
        projectDistribution,
        apartmentsTrend,
      ];
}

/// State for sold apartments screen
class SoldApartmentsState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final SoldApartmentsStats stats;
  final BuilderStats? builderStats;
  final List<Apartment> recentSoldApartments;
  final List<MonthlySalesModel> monthlySales;
  final bool isLoadingMore;
  final bool hasMoreApartments;
  final int currentPage;

  const SoldApartmentsState({
    this.isLoading = true,
    this.hasError = false,
    this.errorMessage,
    this.stats = const SoldApartmentsStats(
      soldCount: 0,
      soldValue: 0,
      averagePrice: 0,
      soldPercentage: 0,
      totalUnits: 0,
      availableUnits: 0,
      reservedUnits: 0,
      activeProjects: 0,
      completedProjects: 0,
      roomDistribution: {},
      projectDistribution: {},
      apartmentsTrend: 0,
    ),
    this.builderStats,
    this.recentSoldApartments = const [],
    this.monthlySales = const [],
    this.isLoadingMore = false,
    this.hasMoreApartments = false,
    this.currentPage = 1,
  });

  SoldApartmentsState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    SoldApartmentsStats? stats,
    BuilderStats? builderStats,
    List<Apartment>? recentSoldApartments,
    List<MonthlySalesModel>? monthlySales,
    bool? isLoadingMore,
    bool? hasMoreApartments,
    int? currentPage,
  }) {
    return SoldApartmentsState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      stats: stats ?? this.stats,
      builderStats: builderStats ?? this.builderStats,
      recentSoldApartments: recentSoldApartments ?? this.recentSoldApartments,
      monthlySales: monthlySales ?? this.monthlySales,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreApartments: hasMoreApartments ?? this.hasMoreApartments,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        stats,
        builderStats,
        recentSoldApartments,
        monthlySales,
        isLoadingMore,
        hasMoreApartments,
        currentPage,
      ];
}
