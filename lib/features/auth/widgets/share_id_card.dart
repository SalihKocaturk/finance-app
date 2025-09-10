import 'package:flutter/material.dart';

class ShareIdCard extends StatelessWidget {
  const ShareIdCard({
    super.key,
    required this.label,
    required this.shareIdText,
    required this.onCopy,
    required this.onShare,
  });

  final String label;
  final String shareIdText;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).dividerColor.withOpacity(0.4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(blurRadius: 14, offset: Offset(0, 6), color: Color(0x11000000)),
        ],
      ),
      child: Row(
        children: [
          // Sol taraf: label + code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  shareIdText,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 2,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Kopyala',
            onPressed: onCopy,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Paylaş',
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}
