import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/project_detail_model.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../widgets/project_details/project_details.dart';

/// Premium Project Details Screen.
class ProjectDetailsScreen extends StatefulWidget {
  final String? projectId;

  const ProjectDetailsScreen({
    super.key,
    this.projectId,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  bool _isFavorite = false;

  // Mock data - in production, fetch from repository
  final ProjectDetailModel _project = const ProjectDetailModel(
    id: '1',
    name: 'Yuksalish Tower',
    location: 'Toshkent, Chilonzor tumani',
    imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
    status: 'building',
    deliveryDate: '2026 Q4',
    totalUnits: 240,
    soldUnits: 186,
    startPrice: '12 mln',
    ceilingHeight: '3.3 metr',
    constructionProgress: 65,
    description:
        "Yuksalish Tower - bu zamonaviy arxitektura va yuqori sifatli qurilish standartlarini o'zida mujassam etgan premium turar-joy majmuasi. Loyiha 18 qavatli ikkita blokdan iborat bo'lib, har bir kvartira keng va yorug' xonalar, zamonaviy kommunikatsiyalar bilan jihozlangan. Majmua hududida bolalar maydoni, sport zali, underground parking va 24/7 qo'riqlash xizmati mavjud.",
    galleryImages: [
      'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=400',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400',
      'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
      'https://images.unsplash.com/photo-1517581177682-a085bb7ffb15?w=400',
    ],
    floorPlans: [
      FloorPlanModel(
        id: '1',
        name: '1-xonali',
        area: '42 m\u00B2',
        imageUrl: 'https://via.placeholder.com/150',
        rooms: 1,
      ),
      FloorPlanModel(
        id: '2',
        name: '2-xonali',
        area: '64 m\u00B2',
        imageUrl: 'https://via.placeholder.com/150',
        rooms: 2,
      ),
      FloorPlanModel(
        id: '3',
        name: '3-xonali',
        area: '86 m\u00B2',
        imageUrl: 'https://via.placeholder.com/150',
        rooms: 3,
      ),
      FloorPlanModel(
        id: '4',
        name: '4-xonali',
        area: '112 m\u00B2',
        imageUrl: 'https://via.placeholder.com/150',
        rooms: 4,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectDetailsColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              ProjectDetailsSliverAppBar(
                title: _project.name,
                imageUrl: _project.imageUrl,
                isFavorite: _isFavorite,
                onBack: () => context.pop(),
                onShare: _onShareTap,
                onFavoriteToggle: () => setState(() => _isFavorite = !_isFavorite),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProjectTitleSection(
                        name: _project.name,
                        location: _project.location,
                        status: _project.status,
                      ),
                      SizedBox(height: 16.h),
                      ProjectStatisticsGrid(
                        deliveryDate: _project.deliveryDate,
                        startPrice: _project.startPrice,
                        totalUnits: _project.totalUnits,
                        ceilingHeight: _project.ceilingHeight,
                      ),
                      SizedBox(height: 16.h),
                      ProjectProgressSection(
                        constructionProgress: _project.constructionProgress,
                        soldUnits: _project.soldUnits,
                        totalUnits: _project.totalUnits,
                      ),
                      SizedBox(height: 16.h),
                      ProjectDescriptionSection(
                        description: _project.description,
                      ),
                      SizedBox(height: 16.h),
                      ProjectGallerySection(
                        images: _project.galleryImages,
                        onSeeAllTap: () {},
                        onImageTap: _openGallery,
                      ),
                      SizedBox(height: 16.h),
                      ProjectFloorPlansSection(
                        floorPlans: _project.floorPlans,
                        onFloorPlanTap: _onFloorPlanTap,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ProjectBottomActionBar(
            onCallCenterTap: _onCallCenterTap,
            onSelectApartmentTap: _onSelectApartmentTap,
          ),
        ],
      ),
    );
  }

  void _onShareTap() {
    CustomSnacbar.show(
      context,
      text: 'Ulashish: ${_project.name}',
    );
  }

  void _openGallery(int index) {
    CustomSnacbar.show(
      context,
      text: 'Galereya: Rasm ${index + 1}',
    );
  }

  void _onFloorPlanTap(FloorPlanModel plan) {
    CustomSnacbar.show(
      context,
      text: '${plan.name} - ${plan.area}',
    );
  }

  void _onCallCenterTap() {
    CustomSnacbar.show(
      context,
      text: 'Call Center: +998 71 123 45 67',
    );
  }

  void _onSelectApartmentTap() {
    CustomSnacbar.show(
      context,
      text: "Kvartira tanlash sahifasiga o'tish",
    );
  }
}
