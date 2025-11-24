import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/character_profile.dart';
import '../theme/rpg_theme.dart';

class WeeklyStatsPage extends StatelessWidget {
  final CharacterProfile character;

  const WeeklyStatsPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final weeklyScores = character.getWeeklyScores();

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
                      child: MedievalText.title('${character.name}\'s Stats'),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Charts for each attribute
                    _buildAttributeChart(
                      'Kindness',
                      'kindness',
                      RPGTheme.kindnessRed,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeChart(
                      'Creativity',
                      'creativity',
                      RPGTheme.creativityPurple,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeChart(
                      'Consistency',
                      'consistency',
                      RPGTheme.consistencyBlue,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeChart(
                      'Efficiency',
                      'efficiency',
                      RPGTheme.efficiencyOrange,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeChart(
                      'Healing',
                      'healing',
                      RPGTheme.healingGreen,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeChart(
                      'Love',
                      'relationship',
                      RPGTheme.loveRose,
                      weeklyScores,
                    ),
                    const SizedBox(height: 24),

                    // Summary stats
                    _buildSummaryStats(weeklyScores),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeChart(
    String label,
    String attribute,
    Color color,
    List<DailyScore> weeklyScores,
  ) {
    return ScrollContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MedievalText.heading(label),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: RPGTheme.textBrown.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return MedievalText.body(
                          value.toInt().toString(),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < weeklyScores.length) {
                          final date = weeklyScores[value.toInt()].date;
                          return MedievalText.body(
                            '${date.month}/${date.day}',
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: RPGTheme.ornateGold),
                ),
                minX: 0,
                maxX: (weeklyScores.length - 1).toDouble(),
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyScores.asMap().entries.map((entry) {
                      final value =
                          entry.value.scores[attribute]?.toDouble() ?? 0.0;
                      return FlSpot(entry.key.toDouble(), value);
                    }).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(List<DailyScore> weeklyScores) {
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

    return ScrollContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MedievalText.heading('Weekly Totals'),
          const SizedBox(height: 8),
          MedievalDivider(),
          const SizedBox(height: 16),
          _buildStatRow('Kindness', totals['kindness']!, RPGTheme.kindnessRed),
          _buildStatRow('Creativity', totals['creativity']!, RPGTheme.creativityPurple),
          _buildStatRow('Consistency', totals['consistency']!, RPGTheme.consistencyBlue),
          _buildStatRow('Efficiency', totals['efficiency']!, RPGTheme.efficiencyOrange),
          _buildStatRow('Healing', totals['healing']!, RPGTheme.healingGreen),
          _buildStatRow('Love', totals['relationship']!, RPGTheme.loveRose),
          const SizedBox(height: 8),
          MedievalDivider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MedievalText.heading('Total Score:'),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: RPGTheme.scrollTan,
                  border: Border.all(color: RPGTheme.ornateGold, width: 2),
                ),
                child: MedievalText.title(
                  '$totalScore',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MedievalText.body(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              border: Border.all(color: color, width: 2),
            ),
            child: MedievalText.heading(
              '$value',
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
