import 'dart:math';

class MoonPhaseUtils {
  /// Calculate moon phase for a given date (0 = New Moon, 0.5 = Full Moon)
  static double calculateMoonPhase(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // Calculate days since known new moon (January 6, 2000)
    int c = 0, e = 0, jd = 0, b = 0;

    if (month < 3) {
      final year2 = year - 1;
      final month2 = month + 12;
      c = year2 ~/ 100;
      jd = (365.25 * year2).toInt();
      e = (30.6 * (month2 + 1)).toInt();
    } else {
      c = year ~/ 100;
      jd = (365.25 * year).toInt();
      e = (30.6 * (month + 1)).toInt();
    }

    b = 2 - c + (c ~/ 4);

    final jdn = jd + e + day + b - 694025.5;

    // Moon's phase calculation
    final phase = (jdn - 2451550.1) / 29.530588853;
    final phaseNormalized = phase - phase.floor();

    return phaseNormalized;
  }

  /// Get moon phase name from phase value
  static String getMoonPhaseName(double phase) {
    if (phase < 0.033 || phase > 0.967) {
      return 'New Moon';
    } else if (phase < 0.216) {
      return 'Waxing Crescent';
    } else if (phase < 0.283) {
      return 'First Quarter';
    } else if (phase < 0.467) {
      return 'Waxing Gibbous';
    } else if (phase < 0.533) {
      return 'Full Moon';
    } else if (phase < 0.716) {
      return 'Waning Gibbous';
    } else if (phase < 0.783) {
      return 'Last Quarter';
    } else {
      return 'Waning Crescent';
    }
  }

  /// Get moon illumination percentage
  static int getIlluminationPercent(double phase) {
    // Calculate illumination based on phase
    final illumination = (1 - cos(2 * pi * phase)) / 2;
    return (illumination * 100).round();
  }

  /// Get next moon phases
  static List<MoonPhaseInfo> getUpcomingPhases(DateTime currentDate) {
    final phases = <MoonPhaseInfo>[];
    final currentPhase = calculateMoonPhase(currentDate);

    // Define target phases (new moon, first quarter, full moon, last quarter)
    final targetPhases = [
      {'value': 0.0, 'name': 'New Moon'},
      {'value': 0.25, 'name': 'First Quarter'},
      {'value': 0.5, 'name': 'Full Moon'},
      {'value': 0.75, 'name': 'Last Quarter'},
    ];

    for (var target in targetPhases) {
      final targetPhase = target['value'] as double;
      final name = target['name'] as String;

      // Calculate days until this phase
      var daysUntil = (targetPhase - currentPhase) * 29.530588853;
      if (daysUntil < 0) {
        daysUntil += 29.530588853;
      }

      final phaseDate = currentDate.add(Duration(days: daysUntil.round()));

      phases.add(MoonPhaseInfo(
        name: name,
        date: phaseDate,
        daysUntil: daysUntil.round(),
      ));
    }

    // Sort by days until
    phases.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));

    return phases.take(3).toList();
  }

  /// Get moon emoji icon
  static String getMoonEmoji(double phase) {
    if (phase < 0.033 || phase > 0.967) {
      return '🌑';
    } else if (phase < 0.216) {
      return '🌒';
    } else if (phase < 0.283) {
      return '🌓';
    } else if (phase < 0.467) {
      return '🌔';
    } else if (phase < 0.533) {
      return '🌕';
    } else if (phase < 0.716) {
      return '🌖';
    } else if (phase < 0.783) {
      return '🌗';
    } else {
      return '🌘';
    }
  }
}

class MoonPhaseInfo {
  final String name;
  final DateTime date;
  final int daysUntil;

  MoonPhaseInfo({
    required this.name,
    required this.date,
    required this.daysUntil,
  });

  String getDaysText() {
    if (daysUntil == 0) return 'Today';
    if (daysUntil == 1) return 'Tomorrow';
    return 'in $daysUntil days';
  }
}
