import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String firstName;
  final String lastName;

  const WelcomeScreen({
    Key? key,
    this.firstName = 'User', // Default name if skipped
    this.lastName = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create display name
    String displayName = firstName.isNotEmpty ? firstName : 'User';
    if (lastName.isNotEmpty) {
      displayName = '$firstName $lastName';
    }

    return Scaffold(
      backgroundColor: Color(0xFF6B6B6B), // Dark gray background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              // Top bar with menu and close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Close the app or navigate to main screen
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome message
                    Text(
                      'Welcome, ${displayName}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30),

                    // Description text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Your creative journey continues here in the ',
                          ),
                          TextSpan(
                            text: 'Color Mix Lab',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '. Get ready to blend, experiment, and unleash your artistic flair. Let\'s create some vibrant masterpieces together!',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50),

                    // Color wheel logo
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png', // Same logo as other screens
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 80),
                  ],
                ),
              ),

              // Continue button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.8),
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                  ),
                  onPressed: () {
                    _handleContinue(context);
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    // TODO: Navigate to the main app screen
    // For now, just show a message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome to Color Mix Lab!'),
        backgroundColor: Color(0xFF6B6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Navigate to your main app screen here
    // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainAppScreen()));

    // For demo purposes, go back to login
    Future.delayed(Duration(seconds: 1), () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }
}