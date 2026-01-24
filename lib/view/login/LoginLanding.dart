import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/AppColor.dart';
import '../../viewModel/Landing Viewmodel.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandingViewModel(),
      child: Consumer<LandingViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.blue100,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// ---------- TOP WHITE CONTAINER ----------
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          /// IMAGE SLIDER
                          Expanded(
                            child: PageView.builder(
                              controller: viewModel.pageController,
                              itemCount: viewModel.images.length,
                              onPageChanged: viewModel.onPageChanged,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset(
                                    viewModel.images[index],
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                          ),

                          /// DOT INDICATOR
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              viewModel.images.length,
                                  (index) => GestureDetector(
                                onTap: () => viewModel.goToPage(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: viewModel.currentIndex == index ? 12 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: viewModel.currentIndex == index
                                        ? AppColors.blue100
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// TITLE
                          Text(
                            'Welcome To Public Hospital',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// SUBTITLE
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Search doctor, manage appointments, and access healthcare services easily.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// ---------- BUTTON SECTION ----------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      child: Row(
                        children: [
                          /// LOGIN BUTTON
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.whiteColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          /// SIGN UP BUTTON
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blue100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}