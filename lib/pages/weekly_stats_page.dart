import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/character_profile.dart';
import '../theme/rpg_theme.dart';

class WeeklyStatsPage extends StatefulWidget {
  final CharacterProfile character;

  const WeeklyStatsPage({super.key, required this.character});

  @override
  State<WeeklyStatsPage> createState() => _WeeklyStatsPageState();
}

class _WeeklyStatsPageState extends State<WeeklyStatsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String _selectedTab = 'summary';

  final List<Map<String, dynamic>> _attributeTabs = [
    {'label': 'Summary', 'key': 'summary', 'icon': Icons.emoji_events, 'color': Color(0xFFD4AF37)},
    {'label': 'Kindness', 'key': 'kindness', 'icon': Icons.favorite, 'color': Color(0xFFB71C1C)},
    {'label': 'Creativity', 'key': 'creativity', 'icon': Icons.brush, 'color': Color(0xFF6A1B9A)},
    {'label': 'Consistency', 'key': 'consistency', 'icon': Icons.loop, 'color': Color(0xFF1565C0)},
    {'label': 'Efficiency', 'key': 'efficiency', 'icon': Icons.bolt, 'color': Color(0xFFE65100)},
    {'label': 'Healing', 'key': 'healing', 'icon': Icons.spa, 'color': Color(0xFF2E7D32)},
    {'label': 'Love', 'key': 'relationship', 'icon': Icons.favorite_border, 'color': Color(0xFFC2185B)},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyScores = widget.character.getWeeklyScores();

    return Scaffold(
      backgroundColor: RPGTheme.darkWood,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              RPGTheme.mediumWood,
              RPGTheme.darkWood,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RPGTheme.mediumWood,
                border: Border(
                  bottom: BorderSide(color: RPGTheme.ornateGold, width: 2),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: RPGTheme.ornateGold,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.auto_stories, color: RPGTheme.ornateGold, size: 28),
                          const SizedBox(width: 12),
                          MedievalText.title('Spell Book of Stats'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Scroll Tabs
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: RPGTheme.mediumWood,
                border: Border(
                  bottom: BorderSide(color: RPGTheme.ornateGold, width: 2),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _attributeTabs.length,
                itemBuilder: (context, index) {
                  final tab = _attributeTabs[index];
                  final isSelected = _selectedTab == tab['key'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildScrollTab(
                      label: tab['label'],
                      key: tab['key'],
                      icon: tab['icon'],
                      color: tab['color'],
                      isSelected: isSelected,
                    ),
                  );
                },
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _buildSelectedContent(weeklyScores),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollTab({
    required String label,
    required String key,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = key;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? RPGTheme.scrollTan : RPGTheme.parchment.withValues(alpha: 0.7),
            border: Border.all(
              color: isSelected ? color : RPGTheme.ornateGold,
              width: isSelected ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? color : RPGTheme.textBrown, size: 24),
              const SizedBox(width: 8),
              MedievalText.body(
                label,
                color: isSelected ? RPGTheme.textBrown : RPGTheme.parchmentDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(List<DailyScore> weeklyScores) {
    if (_selectedTab == 'summary') {
      return _buildSummaryCard(weeklyScores);
    }
    
    final tab = _attributeTabs.firstWhere((t) => t['key'] == _selectedTab);
    return _buildAttributeDetail(
      tab['label'],
      tab['key'],
      tab['color'],
      tab['icon'],
      weeklyScores,
    );
  }

  Widget _buildSummaryCard(List<DailyScore> weeklyScores) {
    final Map<String, int> totals = {
      'kindness': 0,
      'creativity': 0,
      'consistency': 0,
      'efficiency': 0,
      'healing': 0,
      'relationship': 0,
    };

    for (final score in weeklyScores) {
      score.scores.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }

    final totalScore = totals.values.fold(0, (sum, value) => sum + value);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: RPGTheme.scrollTan,
          border: Border.all(color: RPGTheme.ornateGold, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: CustomPaint(
          painter: OrnateBorderPainter(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 32, color: RPGTheme.ornateGold),
                    const SizedBox(width: 12),
                    MedievalText.heading('Weekly Summary', color: RPGTheme.textBrown),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RPGTheme.ornateGold.withValues(alpha: 0.2),
                    border: Border.all(color: RPGTheme.ornateGold, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MedievalText.heading('Total Power: ', color: RPGTheme.textBrown),
                      MedievalText.title('$totalScore', color: RPGTheme.ornateGold),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeDetail(
    String label,
    String attribute,
    Color color,
    IconData icon,
    List<DailyScore> weeklyScores,
  ) {
    final total = weeklyScores.fold<int>(
      0,
      (sum, score) => sum + (score.scores[attribute] ?? 0),
    );

    return Container(
      decoration: BoxDecoration(
        color: RPGTheme.scrollTan,
        border: Border.all(color: color, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomPaint(
        painter: OrnateBorderPainter(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, size: 32, color: color),
                  const SizedBox(width: 12),
                  MedievalText.heading(label, color: RPGTheme.textBrown),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: MedievalText.heading('$total', color: color),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: _buildChart(attribute, weeklyScores, color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(
    String attribute,
    List<DailyScore> weeklyScores,
    Color color,
  ) {
    if (weeklyScores.isEmpty) {
      return Center(
        child: MedievalText.body(
          'No data available for this week',
          color: RPGTheme.parchmentDark,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: RPGTheme.parchmentDark.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: RPGTheme.textBrown,
                      fontSize: 12,
                      fontFamily: 'Crimson Text',
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < weeklyScores.length) {
                    final date = weeklyScores[value.toInt()].date;
                    return Text(
                      '${date.day}/${date.month}',
                      style: TextStyle(
                        color: RPGTheme.textBrown,
                        fontSize: 10,
                        fontFamily: 'Crimson Text',
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: color, width: 2),
          ),
          minY: 0,
          maxX: (weeklyScores.length - 1).toDouble(),
          maxY: attribute == 'relationship' ? 5 : 50,
          lineBarsData: [
            LineChartBarData(
              spots: weeklyScores.asMap().entries.map((entry) {
                final value = entry.value.scores[attribute]?.toDouble() ?? 0.0;
                return FlSpot(entry.key.toDouble(), value);
              }).toList(),
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: RPGTheme.parchment,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
