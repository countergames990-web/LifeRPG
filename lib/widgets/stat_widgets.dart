import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// Icon box displaying stat values in a grid (like items in the reference)
class StatIconBox extends StatefulWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color iconColor;
  final VoidCallback? onTap;

  const StatIconBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = MedievalColors.gold,
    this.onTap,
  });

  @override
  State<StatIconBox> createState() => _StatIconBoxState();
}

class _StatIconBoxState extends State<StatIconBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -3.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.iconColor.withOpacity(0.15)
                : MedievalColors.parchmentLight,
            border: Border.all(color: MedievalColors.inkBlack, width: 4),
            borderRadius: BorderRadius.zero, // Sharp pixel corners
            boxShadow: [
              // Pixel-style hard shadow
              BoxShadow(
                color: Colors.black,
                offset: Offset(_isHovered ? 6 : 4, _isHovered ? 6 : 4),
                blurRadius: 0, // No blur for pixel art
              ),
              if (_isHovered)
                BoxShadow(
                  color: widget.iconColor.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: _isHovered ? 40 : 36,
                color: widget.iconColor,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: MedievalColors.inkBrown,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.iconColor,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: MedievalColors.inkBlack, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: const Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  '${widget.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(1, 1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Character stats display with icons (left side of book)
class CharacterStatsBox extends StatelessWidget {
  final String characterName;
  final int level;
  final String? imageUrl;
  final Map<String, int> stats;

  const CharacterStatsBox({
    super.key,
    required this.characterName,
    required this.level,
    this.imageUrl,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Character name banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: MedievalColors.woodDark,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            characterName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MedievalColors.gold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Character portrait
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFFB8D4E8),
            border: Border.all(color: MedievalColors.woodDark, width: 4),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
        const SizedBox(height: 16),
        // Stats row with icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level icon
            _buildSmallStatBox(
              icon: Icons.star,
              value: level.toString(),
              color: MedievalColors.gold,
            ),
            const SizedBox(width: 8),
            // Health/total points
            _buildSmallStatBox(
              icon: Icons.favorite,
              value: '${stats.values.fold(0, (sum, val) => sum + val)}',
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            // Shield/defense
            _buildSmallStatBox(
              icon: Icons.shield,
              value: '${level * 2}',
              color: Colors.blue,
            ),
          ],
        ),
        const Spacer(),
        // Choose button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Character selection action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD2691E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Color(0xFF8B4513), width: 3),
              ),
            ),
            child: const Text(
              'Choose',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: MedievalColors.woodDark.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSmallStatBox({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MedievalColors.parchment,
        border: Border.all(color: MedievalColors.woodDark, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MedievalColors.inkBlack,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of attribute boxes (right side of book)
class AttributeGridBox extends StatelessWidget {
  final String title;
  final Map<String, AttributeData> attributes;
  final VoidCallback? onUpdateScores;

  const AttributeGridBox({
    super.key,
    required this.title,
    required this.attributes,
    this.onUpdateScores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: MedievalColors.woodDark,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MedievalColors.gold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Attributes grid (3x2)
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: attributes.length,
            itemBuilder: (context, index) {
              final entry = attributes.entries.elementAt(index);
              final attr = entry.value;
              return StatIconBox(
                icon: _getIconForAttribute(entry.key),
                label: attr.label,
                value: attr.value,
                iconColor: attr.color,
                onTap: onUpdateScores,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Info box at bottom
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MedievalColors.parchment,
            border: Border.all(color: MedievalColors.woodDark, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MedievalColors.inkBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your attributes daily to level up and unlock new abilities!',
                style: TextStyle(
                  fontSize: 11,
                  color: MedievalColors.inkBrown,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AttributeData {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  AttributeData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

IconData _getIconForAttribute(String attributeKey) {
  switch (attributeKey.toLowerCase()) {
    case 'kindness':
      return Icons.favorite;
    case 'creativity':
      return Icons.auto_fix_high;
    case 'consistency':
      return Icons.shield;
    case 'efficiency':
      return Icons.bolt;
    case 'healing':
      return Icons.healing;
    case 'relationship':
      return Icons.favorite_border;
    default:
      return Icons.star;
  }
}
