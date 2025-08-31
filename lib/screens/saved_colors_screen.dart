import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import '../models/saved_color_item.dart'; // adjust if your path differs

class SavedColorsScreen extends StatefulWidget {
  final List<SavedColorItem> items;
  const SavedColorsScreen({super.key, required this.items});

  @override
  State<SavedColorsScreen> createState() => _SavedColorsScreenState();
}

class _SavedColorsScreenState extends State<SavedColorsScreen> {
  String query = '';

  // MM-dd-yy without intl
  String _formatDate(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final yy = (dt.year % 100).toString().padLeft(2, '0');
    return '$mm-$dd-$yy';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((item) {
      final q = query.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          item.hex.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF6B6B6B),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo + Title
            Column(
              children: [
                Image.asset('assets/images/logo.png', height: 60),
                const SizedBox(height: 8),
                const Text(
                  'Color Mix Lab',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search by name or hex code',
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Saved colors list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final item = filtered[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Color preview
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Text info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'HEX ${item.hex}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                'RGB ${item.rgb}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        // Copy button + date
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Copy HEX',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: item.hex),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied HEX to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, color: Colors.white70),
                            ),
                            Text(
                              _formatDate(item.savedAt), // <- no intl needed
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
