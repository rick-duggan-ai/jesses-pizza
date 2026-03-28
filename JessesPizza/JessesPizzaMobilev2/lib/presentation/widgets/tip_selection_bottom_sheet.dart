import 'package:flutter/material.dart';

/// Result returned by the tip selection bottom sheet.
class TipResult {
  final double amount;
  const TipResult(this.amount);
}

/// Show the tip selection bottom sheet and return the result.
Future<TipResult?> showTipSelectionBottomSheet({
  required BuildContext context,
  required double subtotal,
}) {
  return showModalBottomSheet<TipResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => TipSelectionBottomSheet(subtotal: subtotal),
  );
}

/// Modal bottom sheet that lets the user pick a tip amount.
///
/// Returns the selected tip as a [TipResult], or `null` if the user dismisses
/// the sheet without choosing.
class TipSelectionBottomSheet extends StatefulWidget {
  /// The cart subtotal used to calculate percentage-based tips.
  final double subtotal;

  const TipSelectionBottomSheet({super.key, required this.subtotal});

  /// Convenience helper to show the sheet and return the result.
  static Future<TipResult?> show(BuildContext context,
      {required double subtotal}) {
    return showTipSelectionBottomSheet(context: context, subtotal: subtotal);
  }

  @override
  State<TipSelectionBottomSheet> createState() =>
      _TipSelectionBottomSheetState();
}

class _TipSelectionBottomSheetState extends State<TipSelectionBottomSheet> {
  bool _isCustom = false;
  final _customController = TextEditingController();
  String? _customError;

  static const _percentages = [0.20, 0.22, 0.25];
  static const _labels = ['20%', '22%', '25%'];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double _calcTip(double pct) {
    return double.parse((widget.subtotal * pct).toStringAsFixed(2));
  }

  void _selectPercentage(double pct) {
    final tip = _calcTip(pct);
    Navigator.of(context).pop(TipResult(tip));
  }

  void _selectNoTip() {
    Navigator.of(context).pop(TipResult(0.0));
  }

  void _submitCustom() {
    final text = _customController.text.trim();
    if (text.isEmpty) {
      setState(() => _customError = 'Please enter an amount');
      return;
    }
    final value = double.tryParse(text);
    if (value != null && value >= 0) {
      Navigator.of(context).pop(TipResult(value));
    } else {
      setState(() => _customError = 'Please enter a valid amount');
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
            'Add a tip?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Subtotal: \$${widget.subtotal.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Percentage buttons
          ...List.generate(_percentages.length, (i) {
            final amount = _calcTip(_percentages[i]);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: () => _selectPercentage(_percentages[i]),
                child: Text(
                    '${_labels[i]} - \$${amount.toStringAsFixed(2)}'),
              ),
            );
          }),
          const SizedBox(height: 4),
          // Custom tip
          if (_isCustom) ...[
            TextField(
              controller: _customController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Custom tip amount',
                prefixText: '\$ ',
                border: const OutlineInputBorder(),
                errorText: _customError,
              ),
              onSubmitted: (_) => _submitCustom(),
              onChanged: (_) {
                if (_customError != null) {
                  setState(() => _customError = null);
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitCustom,
              child: const Text('Add'),
            ),
          ] else
            OutlinedButton(
              onPressed: () => setState(() => _isCustom = true),
              child: const Text('Custom Amount'),
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
