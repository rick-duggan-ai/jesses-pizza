import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Result returned from the tip selection bottom sheet.
/// A null result means the user cancelled.
class TipSelectionResult {
  final double amount;
  const TipSelectionResult(this.amount);
}

/// Shows a bottom sheet for tip selection.
///
/// Returns a [TipSelectionResult] with the chosen tip amount,
/// or null if the user cancelled.
Future<TipSelectionResult?> showTipSelectionBottomSheet({
  required BuildContext context,
  required double subtotal,
}) {
  return showModalBottomSheet<TipSelectionResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => TipSelectionBottomSheet(subtotal: subtotal),
  );
}

/// Bottom sheet widget that presents tip percentage options,
/// a custom amount option, and a no-tip option.
///
/// Mirrors the V1 Xamarin tip selection flow which used a
/// DisplayActionSheet with 20%, 22%, 25%, Custom, and No Tip.
class TipSelectionBottomSheet extends StatefulWidget {
  final double subtotal;

  const TipSelectionBottomSheet({super.key, required this.subtotal});

  @override
  State<TipSelectionBottomSheet> createState() =>
      _TipSelectionBottomSheetState();
}

class _TipSelectionBottomSheetState extends State<TipSelectionBottomSheet> {
  bool _showCustomInput = false;
  final _customController = TextEditingController();
  String? _customError;

  static const List<_TipOption> _percentageOptions = [
    _TipOption(label: '20%', percent: 0.20),
    _TipOption(label: '22%', percent: 0.22),
    _TipOption(label: '25%', percent: 0.25),
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double _calculateTip(double percent) {
    return double.parse((widget.subtotal * percent).toStringAsFixed(2));
  }

  void _selectPercentage(double percent) {
    Navigator.of(context).pop(TipSelectionResult(_calculateTip(percent)));
  }

  void _selectNoTip() {
    Navigator.of(context).pop(const TipSelectionResult(0.0));
  }

  void _submitCustomTip() {
    final text = _customController.text.trim();
    if (text.isEmpty) {
      setState(() => _customError = 'Please enter an amount');
      return;
    }
    final amount = double.tryParse(text);
    if (amount == null || amount < 0) {
      setState(() => _customError = 'Invalid tip amount');
      return;
    }
    Navigator.of(context)
        .pop(TipSelectionResult(double.parse(amount.toStringAsFixed(2))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Subtotal: \$${widget.subtotal.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ..._percentageOptions.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _TipOptionButton(
                  label: option.label,
                  amount: _calculateTip(option.percent),
                  onTap: () => _selectPercentage(option.percent),
                ),
              )),
          if (!_showCustomInput) ...[
            const SizedBox(height: 4),
            OutlinedButton(
              onPressed: () => setState(() => _showCustomInput = true),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Custom Amount'),
            ),
          ] else ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0.00',
                      errorText: _customError,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    autofocus: true,
                    onSubmitted: (_) => _submitCustomTip(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submitCustomTip,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
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

class _TipOptionButton extends StatelessWidget {
  final String label;
  final double amount;
  final VoidCallback onTap;

  const _TipOptionButton({
    required this.label,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text('$label - \$${amount.toStringAsFixed(2)}'),
    );
  }
}

/// Internal model for a percentage-based tip option.
class _TipOption {
  final String label;
  final double percent;
  const _TipOption({required this.label, required this.percent});
}
