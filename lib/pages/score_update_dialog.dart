import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/game_state_provider.dart';
import '../theme/rpg_theme.dart';

class ScoreUpdateDialog extends StatefulWidget {
  final String characterId;

  const ScoreUpdateDialog({super.key, required this.characterId});

  @override
  State<ScoreUpdateDialog> createState() => _ScoreUpdateDialogState();
}

class _ScoreUpdateDialogState extends State<ScoreUpdateDialog> {
  DateTime _selectedDate = DateTime.now();
  final Map<String, int> _scores = {
    'kindness': 0,
    'creativity': 0,
    'consistency': 0,
    'efficiency': 0,
    'healing': 0,
    'relationship': 0,
  };

  int _getMaxValue(String key) {
    return key == 'relationship' ? 5 : 50;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: ScrollContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MedievalText.title('Update Daily Scores'),
              const SizedBox(height: 16),
              MedievalDivider(),
              const SizedBox(height: 24),

              // Date Selector
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RPGTheme.scrollTan,
                  border: Border.all(color: RPGTheme.ornateGold, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MedievalText.body(
                      DateFormat('MMMM d, yyyy').format(_selectedDate),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: RPGTheme.darkWood),
                      onPressed: _selectDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Score Sliders
              Expanded(
                child: ListView(
                  children: [
                    _buildScoreSlider('Kindness', 'kindness', RPGTheme.kindnessRed, Icons.favorite),
                    _buildScoreSlider('Creativity', 'creativity', RPGTheme.creativityPurple, Icons.brush),
                    _buildScoreSlider('Consistency', 'consistency', RPGTheme.consistencyBlue, Icons.loop),
                    _buildScoreSlider('Efficiency', 'efficiency', RPGTheme.efficiencyOrange, Icons.bolt),
                    _buildScoreSlider('Healing', 'healing', RPGTheme.healingGreen, Icons.spa),
                    _buildScoreSlider('Love', 'relationship', RPGTheme.loveRose, Icons.favorite_border),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: MedievalText.body('CANCEL'),
                  ),
                  const SizedBox(width: 8),
                  OrnateButton(
                    text: 'SAVE',
                    icon: Icons.check,
                    onPressed: _saveScores,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSlider(String label, String key, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  MedievalText.body(label),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  border: Border.all(color: color, width: 2),
                ),
                child: MedievalText.heading(
                  '${_scores[key]}',
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.3),
              thumbColor: RPGTheme.ornateGold,
              overlayColor: color.withOpacity(0.2),
            ),
            child: Slider(
              value: _scores[key]!.toDouble(),
              min: 0,
              max: _getMaxValue(key).toDouble(),
              divisions: _getMaxValue(key),
              onChanged: (value) {
                setState(() {
                  _scores[key] = value.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveScores() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);

    // Save daily scores
    await gameState.addDailyScore(widget.characterId, _selectedDate, _scores);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scores updated successfully!')),
      );
    }
  }
}
