import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // mock profile data (swap with your auth data later)
  String name = 'Khio Ramos';
  String email = 'lebronjames@gmail.com';
  String avatar = 'assets/images/avatar.png';

  bool syncEnabled = false;
  bool hasSubscription = false;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF6B6B6B);
    const tileColor = Color(0xFF737373); // card gray

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
          children: [
            // header (3 dots + logo + title)
            Row(
              children: [
                const Icon(Icons.more_horiz, color: Colors.white70),
                const Spacer(),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Color Mix Lab',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: .2,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            // profile card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: tileColor.withOpacity(.85),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Colors.black26,
                        child: Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // menu tiles
            _SettingButton(
              label: 'Manage account',
              onTap: () => _toast('Open account management'),
            ),
            _SettingButton(
              label: 'Sign Out',
              icon: Icons.logout,
              onTap: _confirmSignOut, // <-- show confirm dialog
            ),

            // sync status (shows enabled/disabled + right icon)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: tileColor.withOpacity(.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Synchronization',
                            style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(
                          syncEnabled ? 'enabled' : 'disabled',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    syncEnabled ? Icons.cloud_sync : Icons.cloud_off,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),

            _SettingButton(
              label: syncEnabled ? 'Disable synchronization' : 'Enable synchronization',
              icon: Icons.sync,
              onTap: () {
                setState(() => syncEnabled = !syncEnabled);
                _toast('Sync ${syncEnabled ? 'enabled' : 'disabled'}');
              },
            ),

            // subscription section
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: tileColor.withOpacity(.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Text('Subscription',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  Icon(Icons.workspace_premium, color: Colors.white70),
                ],
              ),
            ),
            _SettingButton(
              label: hasSubscription ? 'Manage subscription' : 'Subscribe now',
              icon: Icons.credit_card,
              onTap: () {
                setState(() => hasSubscription = true);
                _toast('Thanks for subscribing!');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF6B6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // If you navigate Login -> MainAppScreen, this pops everything back to the first screen (Login)
      Navigator.of(context).popUntil((route) => route.isFirst);

      // If you use named routes, you can do this instead:
      // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}

/* --------------------------- small tile widget --------------------------- */

class _SettingButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _SettingButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF737373).withOpacity(.85),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(icon ?? Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
