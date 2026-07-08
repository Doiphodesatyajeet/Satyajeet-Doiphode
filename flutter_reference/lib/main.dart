import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const AgeCalculatorApp());
}

class AgeCalculatorApp extends StatefulWidget {
  const AgeCalculatorApp({super.key});

  @override
  State<AgeCalculatorApp> createState() => _AgeCalculatorAppState();
}

class _AgeCalculatorAppState extends State<AgeCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6750A4),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFE8DEF8),
          onPrimaryContainer: Color(0xFF1D192B),
          background: Color(0xFFFFFBFF),
          onBackground: Color(0xFF1C1B1F),
          surface: Color(0xFFFDF8FD),
          onSurface: Color(0xFF1C1B1F),
          surfaceVariant: Color(0xFFE7E0EC),
          onSurfaceVariant: Color(0xFF49454F),
          outline: Color(0xFF79747E),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD0BCFF),
          onPrimary: Color(0xFF381E72),
          primaryContainer: Color(0xFF4A4458),
          onPrimaryContainer: Color(0xFFE8DEF8),
          background: Color(0xFF1C1B1F),
          onBackground: Color(0xFFE6E1E5),
          surface: Color(0xFF2B2930),
          onSurface: Color(0xFFE6E1E5),
          surfaceVariant: Color(0x3349454F),
          onSurfaceVariant: Color(0xFFCAC4D0),
          outline: Color(0xFF49454F),
        ),
      ),
      home: AgeCalculatorScreen(onThemeToggle: toggleTheme, themeMode: _themeMode),
    );
  }
}

class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int totalWeeks;
  final int totalMonths;
  final String dayOfWeek;
  final int daysToNextBirthday;
  final int monthsToNextBirthday;
  final int remainingDaysToNextBirthday;
  final String nextBirthdayDayOfWeek;
  final bool isBirthdayToday;

  AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.totalWeeks,
    required this.totalMonths,
    required this.dayOfWeek,
    required this.daysToNextBirthday,
    required this.monthsToNextBirthday,
    required this.remainingDaysToNextBirthday,
    required this.nextBirthdayDayOfWeek,
    required this.isBirthdayToday,
  });
}

class AgeCalculatorScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const AgeCalculatorScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _birthDate;
  DateTime _calculationDate = DateTime.now();
  AgeResult? _result;

  void _calculateAge() {
    if (_birthDate == null) return;

    final birth = _birthDate!;
    final target = _calculationDate;

    if (birth.isAfter(target)) {
      setState(() {
        _result = null;
      });
      return;
    }

    // Exact years, months, days
    int years = target.year - birth.year;
    int months = target.month - birth.month;
    int days = target.day - birth.day;

    if (days < 0) {
      final prevMonthDate = DateTime(target.year, target.month, 0);
      days += prevMonthDate.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    final totalDays = target.difference(birth).inDays;
    final totalWeeks = totalDays ~/ 7;
    
    int totalMonths = (target.year - birth.year) * 12 + target.month - birth.month;
    if (target.day < birth.day) {
      totalMonths--;
    }

    final dayOfWeek = DateFormat('EEEE').format(birth);
    final isBirthdayToday = birth.month == target.month && birth.day == target.day;

    DateTime nextBirthday = DateTime(target.year, birth.month, birth.day);
    if (nextBirthday.isBefore(target) || nextBirthday.isAtSameMomentAs(target)) {
      nextBirthday = DateTime(target.year + 1, birth.month, birth.day);
    }

    final daysToNextBirthday = nextBirthday.difference(target).inDays;
    
    int nextMonths = nextBirthday.month - target.month;
    int nextDays = nextBirthday.day - target.day;

    if (nextDays < 0) {
      final prevMonthDate = DateTime(nextBirthday.year, nextBirthday.month, 0);
      nextDays += prevMonthDate.day;
      nextMonths--;
    }
    if (nextMonths < 0) {
      nextMonths += 12;
    }

    final nextBirthdayDayOfWeek = DateFormat('EEEE').format(nextBirthday);

    setState(() {
      _result = AgeResult(
        years: years,
        months: months,
        days: days,
        totalDays: totalDays,
        totalWeeks: totalWeeks,
        totalMonths: totalMonths,
        dayOfWeek: dayOfWeek,
        daysToNextBirthday: daysToNextBirthday,
        monthsToNextBirthday: nextMonths,
        remainingDaysToNextBirthday: nextDays,
        nextBirthdayDayOfWeek: nextBirthdayDayOfWeek,
        isBirthdayToday: isBirthdayToday,
      );
    });
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _calculateAge();
    }
  }

  Future<void> _selectCalculationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _calculationDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _calculationDate) {
      setState(() {
        _calculationDate = picked;
      });
      _calculateAge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.Center,
              child: Icon(Icons.calendar_today, color: colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              'Age Calculator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: widget.onThemeToggle,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [colorScheme.background, colorScheme.surfaceVariant.withOpacity(0.05)]
                : [colorScheme.background, colorScheme.surfaceVariant.withOpacity(0.15)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date of Birth Section (Geometric Balance style)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                color: colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DATE OF BIRTH',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Icon(Icons.calendar_today, color: colorScheme.primary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _birthDate == null
                                    ? 'Select Birthdate'
                                    : DateFormat('MMM dd, yyyy').format(_birthDate!),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _birthDate == null
                                    ? '---'
                                    : DateFormat('EEEE').format(_birthDate!),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _selectBirthDate(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('CHANGE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Calculate Age At Section
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                color: colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CALCULATE AGE AT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Icon(Icons.event, color: colorScheme.primary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy').format(_calculationDate),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('EEEE').format(_calculationDate),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _selectCalculationDate(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('CHANGE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Results Dashboard
              if (_result != null) ...[
                if (_result!.isBirthdayToday)
                  Card(
                    color: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '🎉 Happy Birthday! Enjoy your special day! 🎂',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Primary Current Age
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                  color: colorScheme.surfaceVariant.withOpacity(0.2),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT AGE',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_result!.years}',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.bottom(12.0),
                              child: Text(
                                'Years',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                color: colorScheme.surface,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'MONTHS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _result!.months.toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                color: colorScheme.surface,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DAYS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _result!.days.toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: colorScheme.outline),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEXT BIRTHDAY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _result!.daysToNextBirthday == 0
                                      ? 'It is today! 🎉'
                                      : 'In ${_result!.daysToNextBirthday} Days',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: _result!.daysToNextBirthday == 0
                                        ? 1.0
                                        : (365 - _result!.daysToNextBirthday) / 365,
                                    color: colorScheme.primary,
                                    backgroundColor: colorScheme.primary.withOpacity(0.3),
                                    strokeWidth: 3,
                                  ),
                                ),
                                Text(
                                  '${(_result!.daysToNextBirthday == 0 ? 100 : ((365 - _result!.daysToNextBirthday) / 365 * 100)).toInt()}%',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Detailed Metrics
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  color: colorScheme.surface,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DETAILED METRICS',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow('Day of Birth', _result!.dayOfWeek, Icons.schedule, colorScheme.primary),
                        Divider(color: colorScheme.outline.withOpacity(0.5)),
                        _buildStatRow('Total Months lived', '${NumberFormat('#,###').format(_result!.totalMonths)} months', Icons.calendar_today, colorScheme.primary),
                        Divider(color: colorScheme.outline.withOpacity(0.5)),
                        _buildStatRow('Total Weeks lived', '${NumberFormat('#,###').format(_result!.totalWeeks)} weeks', Icons.view_week, colorScheme.primary),
                        Divider(color: colorScheme.outline.withOpacity(0.5)),
                        _buildStatRow('Total Days lived', '${NumberFormat('#,###').format(_result!.totalDays)} days', Icons.today, colorScheme.primary),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 32),
                Icon(
                  Icons.info_outline,
                  size: 48,
                  color: colorScheme.primary.withOpacity(0.6),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No Birth Date Selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap \'CHANGE\' inside the Date of Birth card above to select your birthday.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 80), // Prevent Ad overlap
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        color: colorScheme.background,
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                'AdMob Banner Placement',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            Divider(color: colorScheme.outline, height: 1),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.calculate, color: colorScheme.primary),
                      ),
                      const SizedBox(height: 4),
                      Text('Calculate', style: TextStyle(color: colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: colorScheme.onSurfaceVariant),
                      const SizedBox(height: 4),
                      Text('History', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: colorScheme.onSurfaceVariant),
                      const SizedBox(height: 4),
                      Text('Premium', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
