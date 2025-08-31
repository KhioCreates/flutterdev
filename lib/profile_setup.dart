import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl  = TextEditingController();
  final _dobCtrl   = TextEditingController();
  final _emailCtrl = TextEditingController();

  final _firstFocus = FocusNode();
  final _lastFocus  = FocusNode();
  final _emailFocus = FocusNode();

  DateTime? _dob;
  bool _submitting = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label is required' : null;

  String? _email(String? v) {
    final base = _required(v, 'Email');
    if (base != null) return base;
    final ok = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v!.trim());
    return ok ? null : 'Enter a valid email';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6B6B6B),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        // simple dd/MM/yyyy without intl
        _dobCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      // TODO: save profile locally / call backend here
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(
            firstName: _firstCtrl.text.trim(),
            lastName: _lastCtrl.text.trim(),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _skip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(firstName: 'User', lastName: ''),
      ),
    );
  }

  InputDecoration _decor({
    required String hint,
    IconData? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
      prefixIcon: prefix != null ? Icon(prefix, color: Colors.black54) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
        borderSide: const BorderSide(color: Color(0xFF6B6B6B), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: const Color(0xFFced7e0),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            children: [
              // header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's\nFill\nYour\nProfile",
                        style: TextStyle(
                          color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _firstCtrl,
                          focusNode: _firstFocus,
                          textInputAction: TextInputAction.next,
                          validator: (v) => _required(v, 'First name'),
                          onFieldSubmitted: (_) => _lastFocus.requestFocus(),
                          style: const TextStyle(color: Colors.black87),
                          decoration: _decor(hint: 'First Name', prefix: Icons.person_outline),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _lastCtrl,
                          focusNode: _lastFocus,
                          textInputAction: TextInputAction.next,
                          validator: (v) => _required(v, 'Last name'),
                          onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                          style: const TextStyle(color: Colors.black87),
                          decoration: _decor(hint: 'Last Name', prefix: Icons.person_outline),
                        ),
                        const SizedBox(height: 20),

                        // DOB (read-only field opens date picker)
                        TextFormField(
                          controller: _dobCtrl,
                          readOnly: true,
                          validator: (v) => (v == null || v.isEmpty) ? 'Date of birth is required' : null,
                          onTap: _pickDate,
                          style: const TextStyle(color: Colors.black87),
                          decoration: _decor(
                            hint: 'Date of Birth',
                            prefix: Icons.calendar_today_outlined,
                            suffix: const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emailCtrl,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: _email,
                          onFieldSubmitted: (_) => _continue(),
                          style: const TextStyle(color: Colors.black87),
                          decoration: _decor(hint: 'Email', prefix: Icons.email_outlined),
                        ),

                        const SizedBox(height: 28),

                        // buttons
                        Row(
                          children: [
                            Expanded(
                              child: _PillButton(
                                label: 'Skip',
                                onPressed: _submitting ? null : _skip,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _PillButton(
                                label: 'Continue',
                                onPressed: _submitting ? null : _continue,
                                loading: _submitting,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const _PillButton({required this.label, this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B6B6B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: loading
            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
