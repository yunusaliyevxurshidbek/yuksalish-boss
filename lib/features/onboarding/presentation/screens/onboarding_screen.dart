import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/my_shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../presentation/widgets/custom_button_universal.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  void _onGetStarted() {
    MySharedPreferences.setFirstLaunchCompleted(true);
    context.push('/profile/language', extra: {'showContinueButton': true});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/splash_main.jpg',
            fit: BoxFit.cover,
          ),

          // gradient_bg:
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.onboardingGradientStart.withAlpha(120),
                  AppColors.onboardingGradientEnd.withAlpha(240),
                ],
              ),
            ),
          ),

          // main_body:
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // logo section
                  Image.asset(
                    'assets/images/logo_for_dark.png',
                  ),

                  SizedBox(height: 20.h),

                  // page_view_texts:
                  Expanded(
                    flex: 4,
                    child: PageView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        OnboardingPageItem(
                          title: 'onboarding_slide_1_title'.tr(),
                          description: 'onboarding_slide_1_description'.tr(),
                        ),
                        OnboardingPageItem(
                          title: 'onboarding_slide_2_title'.tr(),
                          description: 'onboarding_slide_2_description'.tr(),
                        ),
                        OnboardingPageItem(
                          title: 'onboarding_slide_3_title'.tr(),
                          description: 'onboarding_slide_3_description'.tr(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // page_view_buttons:
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: AppColors.mediumGrey,
                      activeDotColor: AppColors.white,
                    ),
                    onDotClicked: (index) {},
                  ),

                  SizedBox(height: 16.h),

                  // get_started_button:
                  PressableButton(
                    text: 'onboarding_get_started'.tr(),
                    svgIcon: 'assets/icons/arrow_right.svg',
                    backgroundColor: AppColors.white,
                    textColor: AppColors.primaryNavy,
                    iconColor: AppColors.primaryNavy,
                    iconOnRight: true,
                    borderRadius: 20,
                    onTap: _onGetStarted,
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
