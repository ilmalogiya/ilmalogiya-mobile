import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:flutter_svg/flutter_svg.dart";

import "../../cubit/auth/auth_cubit.dart";
import "../../generated/assets/assets.gen.dart";
import "../../utils/constants/routes.dart";
import "../../utils/extensions/color_extensions.dart";
import "../../utils/ui/app_colors.dart";
import "widgets/feature_card_item.dart";
import "widgets/quote_card_widget.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Logo in circle with book badge
              // Brain logo in circular container
              Center(
                child: Container(
                  width: 106,
                  height: 106,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCF7EF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFEADBCE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B4226).withOpacityCustom(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Assets.images.brain.image(
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Title
              const Text(
                "Ilmalogiya olamiga xush\nkelibsiz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2C1E16),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "Eng sara ilmiy, falsafiy va zamonaviy\nmaqolalarni bir joyda mutolaa qiling.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D6C5D),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              // 3 Feature Cards
              const FeatureCardItem(
                icon: Icons.edit_note_rounded,
                title: "Mualliflik maqolalari va tahlillar",
                subtitle: "Ekspertlar tomonidan chuqur yoritilgan mavzular",
              ),
              const FeatureCardItem(
                icon: Icons.alarm_on_rounded,
                title: "Kunlik mutolaa odati va eslatmalar",
                subtitle: "Har kuni 15 daqiqalik ma'naviy oziq",
              ),
              const FeatureCardItem(
                icon: Icons.headphones_rounded,
                title: "Oflayn rejimda audio va matn",
                subtitle: "Yo'lda ham qulay tinglash imkoniyati",
              ),

              const SizedBox(height: 16),

              // Google orqali kirish button
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8DACB),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4226).withOpacityCustom(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.read<AuthCubit>().signInWithGoogle(
                        context: context,
                        onSuccess: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.articlesRoute,
                          );
                        },
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.google,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Google orqali kirish",
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C1E16),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Mehmon sifatida davom etish
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  context.read<AuthCubit>().continueAsGuest(
                    onDone: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteNames.articlesRoute,
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Mehmon sifatida davom etish",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Quote Card
              const QuoteCardWidget(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
