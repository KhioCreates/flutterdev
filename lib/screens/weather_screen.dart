import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Pretty, card-stacked weather screen with cloudy photo background.
/// Data source: open-meteo.com (no API key required).
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _loading = true;
  String _error = '';

  // display values
  String locationLabel = 'Philippines';
  int currentTemp = 0;
  String currentDesc = '';
  double humidity = 0;
  double pressure = 0;
  double wind = 0;

  // next 6 hours
  List<_HourItem> hours = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      // Manila coords; change here if you want another default
      const lat = 14.5995;
      const lon = 120.9842;

      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,pressure_msl,windspeed_10m,weather_code'
        '&hourly=temperature_2m,relative_humidity_2m,pressure_msl,windspeed_10m,weather_code'
        '&timezone=auto',
      );

      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final json = jsonDecode(resp.body);

      // current
      final cur = json['current'] as Map<String, dynamic>;
      currentTemp = (cur['temperature_2m'] as num).round();
      humidity = (cur['relative_humidity_2m'] as num).toDouble();
      pressure = (cur['pressure_msl'] as num).toDouble();
      wind = (cur['windspeed_10m'] as num).toDouble();
      currentDesc = _weatherCodeToText(cur['weather_code'] as int);

      // hourly (next 6 entries from now index)
      final times = (json['hourly']['time'] as List).cast<String>();
      final temps = (json['hourly']['temperature_2m'] as List).cast<num>();
      final codes = (json['hourly']['weather_code'] as List).cast<num>();
      final nowIso = DateTime.now().toUtc().toIso8601String().substring(0, 13);
      int start = times.indexWhere((t) => t.startsWith(nowIso.substring(0, 13)));
      if (start < 0) start = 0;

      hours = [];
      for (var i = start; i < start + 6 && i < times.length; i++) {
        final t = DateTime.parse(times[i]);
        final label = _formatHour(t);
        hours.add(_HourItem(
          label: label,
          temp: temps[i].round(),
          code: codes[i].toInt(),
        ));
      }

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load weather';
      });
    }
  }

  String _formatHour(DateTime dt) {
    int hour = dt.hour;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:00';
  }

  String _weatherCodeToText(int code) {
    // tiny mapping (enough for demo)
    if ({0}.contains(code)) return 'clear sky';
    if ({1, 2}.contains(code)) return 'partly cloudy';
    if ({3}.contains(code)) return 'overcast';
    if ({45, 48}.contains(code)) return 'fog';
    if ({51, 53, 55, 56, 57}.contains(code)) return 'drizzle';
    if ({61, 63, 65}.contains(code)) return 'moderate rain';
    if ({66, 67}.contains(code)) return 'freezing rain';
    if ({71, 73, 75, 77, 85, 86}.contains(code)) return 'snow';
    if ({80, 81, 82}.contains(code)) return 'rain showers';
    if ({95, 96, 99}.contains(code)) return 'Thunderstorm';
    return 'cloudy';
  }

  IconData _codeToIcon(int code) {
    if ({0}.contains(code)) return Icons.wb_sunny_outlined;
    if ({1, 2}.contains(code)) return Icons.cloud_queue;
    if ({3}.contains(code)) return Icons.cloud;
    if ({61, 63, 65, 80, 81, 82}.contains(code)) return Icons.umbrella;
    if ({71, 73, 75, 77, 85, 86}.contains(code)) return Icons.ac_unit;
    if ({95, 96, 99}.contains(code)) return Icons.bolt;
    return Icons.cloud;
    }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cloudy background photo (optional, add asset below)
        Positioned.fill(
          child: Image.asset(
            'assets/images/weather_bg.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.6),
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        // dark overlay for readability
        Positioned.fill(
          child: Container(color: const Color(0xFF6B6B6B).withOpacity(0.35)),
        ),

        // content
        SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off, color: Colors.white70),
                          const SizedBox(height: 8),
                          Text(_error, style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 12),
                          FilledButton(onPressed: _load, child: const Text('Retry')),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                      child: Column(
                        children: [
                          // logo + title
                          Column(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Color Mix Lab',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .3,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // big current card
                          _bigCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      locationLabel,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.favorite, color: Colors.white, size: 18),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$currentTemp°',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 72,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        currentDesc,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // metric chips row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _metricChip('${humidity.toStringAsFixed(0)}%', 'Humidity', Icons.water_drop),
                              _metricChip('${pressure.toStringAsFixed(0)} hPa', 'Pressure', Icons.speed),
                              _metricChip('${wind.toStringAsFixed(2)} m/s', 'Wind', Icons.air),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // hourly forecast card
                          _bigCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hourly Forecast',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18)),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 108,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: hours.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                                    itemBuilder: (_, i) {
                                      final h = hours[i];
                                      return _hourPill(
                                          icon: _codeToIcon(h.code),
                                          temp: '${h.temp}°',
                                          time: h.label);
                                    },
                                  ),
                                ),

                                const SizedBox(height: 18),
                                // "Yesterday" mini strip
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.water_drop, color: Colors.white),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Yesterday\nLight Rain Showers',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Text('↗ 17°  ↘ 10°',
                                          style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // pager dots (dummy UI)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dot(true),
                              _dot(false),
                              _dot(false),
                              _dot(false),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Next 30 Days placeholder
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Next 30 Days',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.9),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _bigCard(
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              child: const Text(
                                'Coming soon',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  // ------------------- UI helpers -------------------

  Widget _bigCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }

  Widget _metricChip(String value, String label, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _hourPill({required IconData icon, required String temp, required String time}) {
    return Container(
      width: 78,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 22, color: Colors.black54),
          Text(temp, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white24,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HourItem {
  final String label;
  final int temp;
  final int code;
  _HourItem({required this.label, required this.temp, required this.code});
}
