import '../../../../core/constants/app_colors.dart';
import '../models/funnel_models.dart';

/// Mock data for funnel analysis page.
class FunnelMockData {
  FunnelMockData._();

  // Note: Mock stage names should be replaced with translation keys when displaying
  // For now, stage names are kept in Uzbek for the mock data
  static const List<FunnelStage> stages = [
    FunnelStage(
      name: 'Yangi',
      count: 40,
      color: AppColors.funnelNew,
      clients: [
        FunnelClient(name: 'Abbos Tursunov', price: '320 mln'),
        FunnelClient(name: 'Dilshod Ergashev', price: '410 mln'),
        FunnelClient(name: 'Malika Karimova', price: '290 mln'),
      ],
    ),
    FunnelStage(
      name: "Bog'lanildi",
      count: 28,
      color: AppColors.funnelContacted,
      clients: [
        FunnelClient(name: 'Aziza Abdukarimova', price: '360 mln'),
        FunnelClient(name: 'Sardor Aliyev', price: '275 mln'),
        FunnelClient(name: 'Lola Yusufova', price: '330 mln'),
      ],
    ),
    FunnelStage(
      name: 'Kvalifikatsiya',
      count: 24,
      color: AppColors.funnelQualified,
      clients: [
        FunnelClient(name: 'Nodira Saidova', price: '520 mln'),
        FunnelClient(name: 'Oybek Ismoilov', price: '450 mln'),
        FunnelClient(name: 'Zarina Mirzoeva', price: '390 mln'),
      ],
    ),
    FunnelStage(
      name: "Ko'rsatuv",
      count: 22,
      color: AppColors.funnelShowing,
      clients: [
        FunnelClient(name: 'Temur Temirov', price: '610 mln'),
        FunnelClient(name: 'Sevara Usmonova', price: '470 mln'),
        FunnelClient(name: 'Jasur Rakhimov', price: '510 mln'),
      ],
    ),
    FunnelStage(
      name: 'Muzokara',
      count: 18,
      color: AppColors.funnelNegotiation,
      clients: [
        FunnelClient(name: 'Behruz Toirov', price: '740 mln'),
        FunnelClient(name: 'Nilufar Madrahimova', price: '660 mln'),
        FunnelClient(name: 'Ulugbek Hamidov', price: '590 mln'),
      ],
    ),
    FunnelStage(
      name: 'Bron',
      count: 20,
      color: AppColors.funnelReservation,
      clients: [
        FunnelClient(name: 'Shahzoda Qodirova', price: '820 mln'),
        FunnelClient(name: 'Ilhom Rasulov', price: '710 mln'),
        FunnelClient(name: 'Kamola Uralova', price: '680 mln'),
      ],
    ),
  ];

  static const List<FunnelKpi> kpis = [
    FunnelKpi(
      label: 'dashboard_funnel_kpi_conversion',
      value: '18%',
      valueColor: AppColors.funnelReservation,
    ),
    FunnelKpi(
      label: "dashboard_funnel_kpi_lost",
      value: '12',
      valueColor: AppColors.errorColor,
    ),
    FunnelKpi(
      label: "dashboard_funnel_kpi_average_time",
      value: '3 kun',
      valueColor: AppColors.funnelNew,
    ),
  ];
}
