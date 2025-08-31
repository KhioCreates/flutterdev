import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Color Diary Screen (self-contained)
/// - Parent can call `openQuickAdd()` to open the Add Entry sheet
/// - You can still keep / remove the internal FAB if you want
/// ---------------------------------------------------------------------------
class ColorDiaryScreen extends StatefulWidget {
  const ColorDiaryScreen({super.key});

  @override
  ColorDiaryScreenState createState() => ColorDiaryScreenState();
}

class ColorDiaryScreenState extends State<ColorDiaryScreen>
    with SingleTickerProviderStateMixin {
  final List<DiaryEntry> _entries = []; // starts empty

  bool _fabOpen = false;
  late final AnimationController _menuCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _menuCtrl, curve: Curves.easeOut);

  @override
  void dispose() {
    _menuCtrl.dispose();
    super.dispose();
  }

  /// <-- PARENT CAN CALL THIS
  void openQuickAdd() {
    if (_fabOpen) {
      _fabOpen = false;
      _menuCtrl.reverse();
    }
    _openCreateSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B6B6B),
      // You may keep/remove this FAB. Parent also has a big global "+".
      floatingActionButton: _mainFab(),
      body: Stack(
        children: [
          _content(),
          if (_fabOpen)
            FadeTransition(
              opacity: _fade,
              child: GestureDetector(
                onTap: _toggleFab,
                child: Container(color: Colors.black38),
              ),
            ),
          _actionMenu(), // menu sits above bottom nav
        ],
      ),
    );
  }

  // ------------------------------ CONTENT ----------------------------------

  Widget _content() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // header row: ...   [logo + title]   (spacer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  color: Colors.white,
                  onSelected: (v) {
                    if (v == 'add') _openCreateSheet();
                    if (v == 'clear') setState(() => _entries.clear());
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'add', child: Text('Add entry')),
                    PopupMenuItem(value: 'clear', child: Text('Clear all')),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.30),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child:
                          Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Color Mix Lab',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _entries.isEmpty
                  ? const _EmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 140),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        mainAxisExtent: 300,
                      ),
                      itemCount: _entries.length,
                      itemBuilder: (_, i) => _DiaryCard(
                        entry: _entries[i],
                        onTap: () => _openDetail(_entries[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- FAB + MENU ---------------------------------

  Widget _mainFab() {
    return SizedBox(
      width: 72,
      height: 72,
      child: FloatingActionButton(
        onPressed: _toggleFab,
        backgroundColor: Colors.white.withOpacity(0.18),
        elevation: 0,
        shape: const CircleBorder(),
        child: RotationTransition(
          turns: Tween<double>(begin: 0, end: .125).animate(_menuCtrl),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child:
                const Center(child: Icon(Icons.add, size: 36, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _actionMenu() {
    final view = MediaQuery.of(context);
    final double bottomOffset =
        kBottomNavigationBarHeight + view.viewPadding.bottom + 24;

    return Positioned(
      left: 18,
      right: 18,
      bottom: bottomOffset + 72, // keep distance from big +
      child: IgnorePointer(
        ignoring: !_fabOpen,
        child: FadeTransition(
          opacity: _fade,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.30),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _miniAction(
                    icon: Icons.edit_note,
                    label: 'New Entry',
                    onTap: () {
                      _toggleFab();
                      _openCreateSheet();
                    },
                  ),
                  const SizedBox(width: 10),
                  _miniAction(
                    icon: Icons.copy_all,
                    label: 'Duplicate last',
                    onTap: () {
                      _toggleFab();
                      if (_entries.isNotEmpty) {
                        final e = _entries.first;
                        setState(() {
                          _entries.insert(
                            0,
                            DiaryEntry(
                              color: e.color,
                              note: e.note,
                              hashtag: e.hashtag,
                              when: DateTime.now(),
                            ),
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  _miniAction(
                    icon: Icons.delete_sweep,
                    label: 'Clear',
                    onTap: () {
                      _toggleFab();
                      setState(() => _entries.clear());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.90),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _toggleFab() {
    setState(() => _fabOpen = !_fabOpen);
    if (_fabOpen) {
      _menuCtrl.forward();
    } else {
      _menuCtrl.reverse();
    }
  }

  // ------------------------- CREATE & DETAIL -------------------------------

  void _openCreateSheet() async {
    final created = await showModalBottomSheet<DiaryEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateDiarySheet(),
    );
    if (created != null) {
      setState(() => _entries.insert(0, created));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Diary entry added')));
    }
  }

  void _openDetail(DiaryEntry e) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _DiaryDetailOverlay(entry: e),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }
}

// ------------------------------- UI PARTS ----------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No diary entries yet",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  const _DiaryCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Color',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 22)),
                const SizedBox(height: 14),
                Container(
                  height: 92,
                  decoration: BoxDecoration(
                    color: entry.color,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                const SizedBox(height: 14),
                Text(entry.note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 10),
                Text(entry.hashtag,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
                const Spacer(),
                Text(entry.longDate,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateDiarySheet extends StatefulWidget {
  @override
  State<_CreateDiarySheet> createState() => _CreateDiarySheetState();
}

class _CreateDiarySheetState extends State<_CreateDiarySheet> {
  Color _color = const Color(0xFF5EAB45);
  final _note = TextEditingController();
  final _hashtag = TextEditingController();
  DateTime _when = DateTime.now();
  double _r = 94, _g = 171, _b = 69;

  @override
  void dispose() {
    _note.dispose();
    _hashtag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Add Diary Entry',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              Container(
                  height: 54,
                  decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(18))),

              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  0xFF5EAB45,
                  0xFF3E63B8,
                  0xFFFF2E2E,
                  0xFFFFDD51,
                  0xFF000000,
                  0xFF7B7B7B,
                  0xFFB565A7,
                  0xFF8FD3FE,
                ]
                    .map((hex) => _Swatch(
                          color: Color(hex),
                          selected: _color.value == hex,
                          onTap: () => setState(() {
                            _color = Color(hex);
                            _r = _color.red.toDouble();
                            _g = _color.green.toDouble();
                            _b = _color.blue.toDouble();
                          }),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 12),
              const Text('Custom color',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _rgb('R', _r, (v) => setState(() {
                    _r = v;
                    _applyRGB();
                  })),
              _rgb('G', _g, (v) => setState(() {
                    _g = v;
                    _applyRGB();
                  })),
              _rgb('B', _b, (v) => setState(() {
                    _b = v;
                    _applyRGB();
                  })),

              const SizedBox(height: 14),
              TextField(
                  controller: _note,
                  maxLines: 3,
                  decoration: _field('Description (note)')),
              const SizedBox(height: 12),
              TextField(
                  controller: _hashtag,
                  decoration: _field('Hashtag (e.g. #happy)')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text('Date: ${_long(_when)}  ${_hhmm(_when)}',
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  TextButton(
                      onPressed: _pickDate, child: const Text('Pick date')),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A7A7A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyRGB() {
    _color = Color.fromARGB(255, _r.toInt(), _g.toInt(), _b.toInt());
  }

  Widget _rgb(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
            width: 26,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
        Expanded(
            child: Slider(min: 0, max: 255, value: value, onChanged: onChanged)),
        SizedBox(
            width: 38,
            child: Text(value.toInt().toString(), textAlign: TextAlign.right)),
      ],
    );
  }

  InputDecoration _field(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    setState(() {
      _when = DateTime(d.year, d.month, d.day, t?.hour ?? _when.hour,
          t?.minute ?? _when.minute);
    });
  }

  void _save() {
    if (_note.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a description')));
      return;
    }
    final entry = DiaryEntry(
      color: _color,
      note: _note.text.trim(),
      hashtag:
          _hashtag.text.trim().isEmpty ? '#color' : _hashtag.text.trim(),
      when: _when,
    );
    Navigator.pop(context, entry);
  }

  String _long(DateTime d) {
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${m[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
  }

  String _hhmm(DateTime d) {
    int h = d.hour;
    final mm = d.minute.toString().padLeft(2, '0');
    final am = h < 12;
    h = h % 12;
    if (h == 0) h = 12;
    return '$h:$mm ${am ? "AM" : "PM"}';
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _Swatch(
      {required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
              color: selected ? Colors.black : Colors.black12,
              width: selected ? 2 : 1),
        ),
      ),
    );
  }
}

class _DiaryDetailOverlay extends StatelessWidget {
  final DiaryEntry entry;
  const _DiaryDetailOverlay({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B6B6B).withOpacity(.98),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 96, 22, 22),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.35),
                        blurRadius: 16,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Title',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87)),
                            const Spacer(),
                            Text('${entry.longDate}   ${entry.hhmmA}',
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 66,
                          decoration: BoxDecoration(
                            color: entry.color,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerLeft,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.arrow_drop_down,
                              color: Colors.black87, size: 28),
                        ),
                        const SizedBox(height: 22),
                        const Text('Note',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87)),
                        const SizedBox(height: 10),
                        Text(entry.note,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5)),
                        const SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A7A7A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(.08)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 3,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('SAVE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // top dots and close
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Row(children: const [
                    _Dot(),
                    SizedBox(width: 6),
                    _Dot(),
                    SizedBox(width: 6),
                    _Dot()
                  ]),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Container(
      width: 8,
      height: 8,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
}

/// -------------------------- Minimal Model (inline) -------------------------
class DiaryEntry {
  final Color color;
  final String note;
  final String hashtag;
  final DateTime when;

  DiaryEntry({
    required this.color,
    required this.note,
    required this.hashtag,
    required this.when,
  });

  String get longDate {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[when.month - 1]} ${when.day.toString().padLeft(2, '0')}, ${when.year}';
  }

  String get hhmmA {
    int h = when.hour;
    final mm = when.minute.toString().padLeft(2, '0');
    final am = h < 12;
    h = h % 12;
    if (h == 0) h = 12;
    return '$h:$mm ${am ? "AM" : "PM"}';
  }
}
