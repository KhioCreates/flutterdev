import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus  = FocusNode();
  final _scroll = ScrollController();

  bool _agree = false;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String? _emailOrPhoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email or phone';
    final s = v.trim();
    if (s.contains('@')) {
      final ok = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(s);
      if (!ok) return 'Enter a valid email address';
    } else {
      // loose “phone” check: at least 7 digits
      final digits = s.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 7) return 'Enter a valid phone number';
    }
    return null;
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Please create a password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _submit() async {
    if (!_agree) {
      _snack('Please agree to the Terms & Privacy to continue.');
      return;
    }
    final form = _formKey.currentState!;
    if (!form.validate()) {
      await Future.delayed(Duration.zero);
      _scroll.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      return;
    }

    setState(() => _loading = true);
    try {
      // TODO: sign-up API here with _emailCtrl.text, _passCtrl.text
      if (!mounted) return;
      Navigator.pushNamed(context, '/setup');
    } catch (e) {
      if (!mounted) return;
      _snack('Sign up failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFFced7e0),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 24),

                        // Logo
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                            shadows: [Shadow(offset: Offset(1,1), blurRadius: 3, color: Colors.black26)],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email/Phone
                        TextFormField(
                          controller: _emailCtrl,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          validator: _emailOrPhoneValidator,
                          onFieldSubmitted: (_) => _passFocus.requestFocus(),
                          decoration: InputDecoration(
                            labelText: 'Email or Phone',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.person, color: Colors.black54),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Password
                        TextFormField(
                          controller: _passCtrl,
                          focusNode: _passFocus,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.white),
                          validator: _passwordValidator,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                              color: Colors.black54,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Terms & Privacy
                        Row(
                          children: [
                            Checkbox(
                              value: _agree,
                              onChanged: (v) => setState(() => _agree = v ?? false),
                              activeColor: const Color(0xFF646464),
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            Flexible(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text('I agree to the ',
                                      style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
                                  GestureDetector(
                                    onTap: () {/* TODO: open terms */},
                                    child: const Text('Terms',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                  ),
                                  const Text(' & ', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
                                  GestureDetector(
                                    onTap: () {/* TODO: open privacy */},
                                    child: const Text('Privacy',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sign up button (disabled until agree)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (_agree && !_loading) ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF646464),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 3,
                            ),
                            child: _loading
                                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OR divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('or continue with', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Social sign-in
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialBtn(
                              color: const Color(0xFF1877F2),
                              child: const Icon(Icons.facebook, color: Colors.white, size: 28),
                              onTap: () => _snack('Facebook login pressed'),
                            ),
                            const SizedBox(width: 16),
                            _SocialBtn(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFe0e0e0)),
                              child: const Text('G',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF4285F4))),
                              onTap: () => _snack('Google login pressed'),
                            ),
                            const SizedBox(width: 16),
                            _SocialBtn(
                              color: Colors.black,
                              child: const Icon(Icons.apple, color: Colors.white, size: 28),
                              onTap: () => _snack('Apple login pressed'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Already have an account
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                              children: [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF646464),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
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

class _SocialBtn extends StatelessWidget {
  final Widget child;
  final Color color;
  final Border? border;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.child,
    required this.color,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: border, boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
          ]),
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
