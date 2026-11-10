import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/conversion_result.dart';
import '../services/conversion_engine.dart';

class ResultCard extends StatelessWidget {
  final ConversionResult? result;
  final Color categoryColor;
  final int precision;

  const ResultCard({
    super.key,
    required this.result,
    required this.categoryColor,
    required this.precision,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('Copied $label to clipboard!')),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calculate_outlined, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Enter a value and tap Convert',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final formattedTarget = ConversionEngine.formatNumber(
      result!.targetValue,
      precision: precision,
    );
    final formattedSource = ConversionEngine.formatNumber(
      result!.sourceValue,
      precision: precision,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.92),
            categoryColor.withValues(alpha: 0.72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Source Expression and Copy Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$formattedSource ${result!.sourceUnit.name} equals',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
                tooltip: 'Copy Result',
                onPressed: () => _copyToClipboard(
                  context,
                  '$formattedTarget ${result!.targetUnit.symbol}',
                  '$formattedTarget ${result!.targetUnit.symbol}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Main Converted Result TextView
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SelectableText(
                  formattedTarget,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  result!.targetUnit.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${result!.targetUnit.name})',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),

          // Formula & Step by Step
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  result!.formula,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (result!.stepByStepExplanation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                result!.stepByStepExplanation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

