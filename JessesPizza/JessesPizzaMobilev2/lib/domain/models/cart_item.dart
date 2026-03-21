import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/group_selection.dart';

part 'cart_item.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required String menuItemId,
    required String name,
    required String sizeName,
    required double price,
    required int quantity,
    @Default([]) List<SelectedGroupItem> selectedGroupItems,
    @Default('') String specialInstructions,
  }) = _CartItem;

  double get totalPrice {
    double total = price;
    for (final item in selectedGroupItems) {
      total += item.additionalPrice;
    }
    return total;
  }

  double get lineTotal => totalPrice * quantity;

  String get selectionsDescription {
    if (selectedGroupItems.isEmpty) return '';
    return selectedGroupItems.map((s) {
      final label = s.groupItem.name ?? '';
      final options = s.optionsLabel;
      return options.isEmpty ? label : '$label $options';
    }).join(', ');
  }
}
