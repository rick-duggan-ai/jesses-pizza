import 'package:flutter/material.dart';

/// Modal bottom sheet that lets the user pick a tip amount.
///
/// Returns the selected tip as a [double], or `null` if the user dismisses
/// the sheet without choosing.
class TipSelectionBottomSheet extends StatefulWidget {
  /// The cart subtotal used to calculate percentage-based tips.
  final double subtotal;

  const TipSelectionBottomSheet({super.key, required this.subtotal});

  /// Convenience helper to show the sheet and return the result.
  static Future<double?> show(BuildContext context, {required double subtotal}) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => TipSelectionBottomSheet(subtotal: subtotal),
    );
  }

  @override
  State<TipSelectionBottomSheet> createState() =>
      _TipSelectionBottomSheetState();
}

class _TipSelectionBottomSheetState extends State<TipSelectionBottomSheet> {
  bool _isCustom = false;
  final _customController = TextEditingController();

  static const _percentages = [0.20, 0.22, 0.25];
  static const _labels = ['20%', '22%', '25%'];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _selectPercentage(double pct) {
    final tip = (widget.subtotal * pct * 100).roundToDouble() / 100;
    Navigator.of(context).pop(tip);
  }

  void _selectNoTip() {
    Navigator.of(context).pop(0.0);
  }

  void _submitCustom() {
    final value = double.tryParse(_customController.text);
    if (value != null && value >= 0) {
      Navigator.of(context).pop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add a Tip',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Percentage buttons row
          Row(
            children: List.generate(_percentages.length, (i) {
              final amount =
                  (widget.subtotal * _percentages[i] * 100).roundToDouble() /
                      100;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 4,
                    right: i == _percentages.length - 1 ? 0 : 4,
                  ),
                  child: OutlinedButton(
                    onPressed: () => _selectPercentage(_percentages[i]),
                    child: Column(
                      children: [
                        Text(_labels[i]),
                        Text(
                          '\$${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          // Custom tip
          if (_isCustom) ...[
            TextField(
              controller: _customController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Custom tip amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitCustom(),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitCustom,
              child: const Text('Apply Tip'),
            ),
          ] else
            OutlinedButton(
              onPressed: () => setState(() => _isCustom = true),
              child: const Text('Custom'),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _selectNoTip,
            child: const Text('No Tip'),
          ),
        ],
      ),
    );
  }
}
