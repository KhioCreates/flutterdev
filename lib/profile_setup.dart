import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import the welcome screen

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFced7e0), // Light blue-gray background
      body: SafeArea(
        child: Column(
          children: [
            // Top section with title and close button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Color(0xFF6B6B6B), // Dark gray header
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
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
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Title text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Let\'s\nFill\nYour\nProfile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // First Name
                    TextField(
                      controller: _firstNameController,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF6B6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Last Name
                    TextField(
                      controller: _lastNameController,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF6B6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Date of Birth
                    TextField(
                      controller: _dateOfBirthController,
                      style: TextStyle(color: Colors.black87),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.black54,
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF6B6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Email
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black87),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF6B6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    // Buttons
                    Row(
                      children: [
                        // Skip button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6B6B6B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              onPressed: () {
                                _handleSkip();
                              },
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // Continue button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6B6B6B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              onPressed: () {
                                _handleContinue();
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
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6B6B6B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
        "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _handleSkip() {
    // Navigate to welcome screen with default name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          firstName: 'User', // Default name for skipped profile
          lastName: '',
        ),
      ),
    );
  }

  void _handleContinue() {
    // Validate required fields
    if (_firstNameController.text.trim().isEmpty) {
      _showMessage('Please enter your first name');
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      _showMessage('Please enter your last name');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showMessage('Please enter a valid email');
      return;
    }

    // Navigate to welcome screen with user's actual name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF6B6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}