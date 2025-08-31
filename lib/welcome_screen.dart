import 'package:flutter/material.dart';
import 'main_app_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String firstName;
  final String lastName;

  const WelcomeScreen({
    super.key,
    this.firstName = 'User',
    this.lastName = '',
  });

  @override
  Widget build(BuildContext context) {
    String displayName = firstName.isNotEmpty ? firstName : 'User';
    if (lastName.isNotEmpty) displayName = '$firstName $lastName';

    return Scaffold(
      backgroundColor: const Color(0xFF6B6B6B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                  GestureDetector(
                    onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ],
              ),

              // center content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // subtle fade-in + slide
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOut,
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, t, child) => Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * 16),
                          child: child,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Welcome, $displayName!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                              children: [
                                TextSpan(text: 'Your creative journey continues here in the '),
                                TextSpan(
                                  text: 'Color Mix Lab',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      '. Get ready to blend, experiment, and unleash your artistic flair!',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),

                    // logo (hero matches earlier screens)
                    Hero(
                      tag: 'app-logo',
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),

              // continue button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                  ),
                  onPressed: () => _handleContinue(context),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    // Go straight to the bottom-nav app
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainAppScreen()),
    );
  }
}
