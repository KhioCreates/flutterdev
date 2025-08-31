import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'models/saved_color_item.dart'; // shared model (color, name, savedAt)
import 'screens/saved_colors_screen.dart';
import 'screens/color_diary_screen.dart';
import 'screens/weather_screen.dart'; // your weather screen
import 'screens/account_screen.dart';


/* -------------------------------------------------------------------------- */
/*                               MAIN APP SHELL                               */
/* -------------------------------------------------------------------------- */

const double kCustomBottomBarHeight = 128;

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _index = 0;

  final List<SavedColorItem> _saved = [];

  // Use a generic-less GlobalKey so we don't depend on the private state type
  final GlobalKey _diaryKey = GlobalKey();

  void _addSaved(Color c) {
    setState(() {
      _saved.insert(
        0,
        SavedColorItem(
          color: c,
          name: _nameFromHex(c),
          savedAt: DateTime.now(),
        ),
      );
      _index = 1; // jump to Saved Colors
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to collection')),
    );
  }

  String _nameFromHex(Color c) =>
      '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();

  @override
  Widget build(BuildContext context) {
    // Order: Mixer(0), Saved(1), Diary(2), Weather(3), Account(4)
    final pages = <Widget>[
      _ColorMixerExactBody(onSave: _addSaved),
      SavedColorsScreen(items: _saved),

      // Pass the key in so we can call openQuickAdd() from here
      ColorDiaryScreen(key: _diaryKey),
      const WeatherScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF6B6B6B),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: pages[_index]),

            // Floating “+” only on the Color Diary tab
            if (_index == 2)
              Positioned(
                right: 18,
                bottom: kCustomBottomBarHeight +
                    MediaQuery.of(context).viewPadding.bottom +
                    16,
                child: GestureDetector(
                  onTap: () {
                    // Call the state's method without importing its private type
                    (_diaryKey.currentState as dynamic)?.openQuickAdd();
                  },
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B8B8B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.35),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 36),
                  ),
                ),
              ),

            // Bottom bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: kCustomBottomBarHeight,
                child: _BottomBar(
                  items: const [
                    _BottomItem('assets/images/colormixer.png',       'Color Mixer'),
                    _BottomItem('assets/images/savedcolor.png', 'Saved Colors'),
                    _BottomItem('assets/images/colordiary.png', 'Color Diary'),
                    _BottomItem('assets/images/weather.png',    'Weather'),
                    _BottomItem('assets/images/account.png',    'Account'),
                  ],
                  selectedIndex: _index,
                  onTap: (i) => setState(() => _index = i),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              MIXER (MATCHED UI)                            */
/* -------------------------------------------------------------------------- */

class _ColorMixerExactBody extends StatefulWidget {
  final ValueChanged<Color> onSave;
  const _ColorMixerExactBody({required this.onSave});

  @override
  State<_ColorMixerExactBody> createState() => _ColorMixerExactBodyState();
}

class _ColorMixerExactBodyState extends State<_ColorMixerExactBody> {
  Color c1 = const Color(0xFFFF3131);
  Color c2 = const Color(0xFF38B6FF);
  Color? mixed;

  String hex(Color c) =>
      '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  String rgb(Color c) => '(${c.red}, ${c.green}, ${c.blue})';

  Color mix(Color a, Color b, [double t = .5]) {
    final r = (a.red * (1 - t) + b.red * t).round().clamp(0, 255);
    final g = (a.green * (1 - t) + b.green * t).round().clamp(0, 255);
    final b2 = (a.blue * (1 - t) + b.blue * t).round().clamp(0, 255);
    return Color.fromARGB(255, r, g, b2);
  }

  void _openPicker(Color current, ValueChanged<Color> onChanged) {
    Color temp = current;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: current,
            onColorChanged: (c) => temp = c,
            enableAlpha: false,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              onChanged(temp);
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const panel = Color(0xFF757575);
    const card = Color(0xFF676767);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: kCustomBottomBarHeight +
            MediaQuery.of(context).viewPadding.bottom +
            60,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              const Text(
                'Color Mix Lab',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .3,
                  shadows: [Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Panel with two pickers
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 22),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const _PanelTitle('Pick First Color'),
                const SizedBox(height: 12),
                _ColorBar(color: c1, onTap: () => _openPicker(c1, (c) => setState(() => c1 = c))),
                const SizedBox(height: 10),
                _SmallSpec(label: 'HEX', value: hex(c1)),
                _SmallSpec(label: 'RGB', value: rgb(c1)),
                const SizedBox(height: 26),

                const _PanelTitle('Pick Second Color'),
                const SizedBox(height: 12),
                _ColorBar(color: c2, onTap: () => _openPicker(c2, (c) => setState(() => c2 = c))),
                const SizedBox(height: 10),
                _SmallSpec(label: 'HEX', value: hex(c2)),
                _SmallSpec(label: 'RGB', value: rgb(c2)),
              ],
            ),
          ),

          const SizedBox(height: 22),

          _PillOutlineButton(
            label: 'MIX',
            onPressed: () => setState(() => mixed = mix(c1, c2, .5)),
          ),

          const SizedBox(height: 24),

          const _CardHeader('Mixed Color'),
          const SizedBox(height: 8),

          // Mixed color card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: 150,
                  decoration: BoxDecoration(
                    color: mixed ?? const Color(0xFFC48A9E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rosy Brown',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'HEX ${hex(mixed ?? const Color(0xFFC48A9E))}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'RGB ${rgb(mixed ?? const Color(0xFFC48A9E))}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final v = hex(mixed ?? const Color(0xFFC48A9E));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Copied $v')));
                  },
                  icon: const Icon(Icons.content_paste, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          _PillOutlineButton(
            label: 'SAVE',
            onPressed: () {
              final colorToSave = mixed ?? const Color(0xFFC48A9E);
              widget.onSave(colorToSave);
            },
          ),
        ],
      ),
    );
  }
}

/* --------------------------- Mixer sub-widgets ----------------------------- */

class _PanelTitle extends StatelessWidget {
  final String text;
  const _PanelTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ColorBar extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _ColorBar({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.20),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallSpec extends StatelessWidget {
  final String label;
  final String value;
  const _SmallSpec({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label : $value',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: .3,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String text;
  const _CardHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _PillOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PillOutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
              side: BorderSide(color: Colors.white.withOpacity(.9), width: 2.5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: .6,
            ),
          ),
        ),
      ),
    );
  }
}

/* ------------------------------ Placeholder account ------------------------ */
class _AccountBody extends StatelessWidget {
  const _AccountBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Account (coming soon)', style: TextStyle(color: Colors.white)),
    );
  }
}

/* -------------------------------- Bottom bar ------------------------------ */
/* -------------------------------- Bottom bar ------------------------------ */
class _BottomBar extends StatelessWidget {
  final List<_BottomItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kCustomBottomBarHeight,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
      decoration: const BoxDecoration(
        color: Color(0xFF595959),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < items.length; i++)
            _BottomButton(
              item: items[i],
              selected: i == selectedIndex,
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _BottomItem {
  final String assetPath;
  final String label;
  const _BottomItem(this.assetPath, this.label);
}

class _BottomButton extends StatelessWidget {
  final _BottomItem item;
  final bool selected;
  final VoidCallback onTap;

  const _BottomButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF7A7A7A) : const Color(0xFF4F4F4F),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.35), blurRadius: 8, offset: const Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8), // smaller padding = bigger image
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.asset(
            item.assetPath,
            width: 64, // force bigger
            height: 64,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.white),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bubble,
          const SizedBox(height: 6),
          Text(item.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}



