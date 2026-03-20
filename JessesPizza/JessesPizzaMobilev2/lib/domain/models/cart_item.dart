import 'package:jesses_pizza_app/domain/models/group_selection.dart';

class CartItem {
  final String menuItemId;
  final String name;
  final String sizeName;
  final double price;
  final int quantity;
  final List<SelectedGroupItem> selectedGroupItems;
  final String specialInstructions;

  const CartItem({required this.menuItemId, required this.name, required this.sizeName,
    required this.price, required this.quantity,
    this.selectedGroupItems = const [], this.specialInstructions = ''});

  double get totalPrice {
    double total = price;
    for (final item in selectedGroupItems) { total += item.additionalPrice; }
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

  CartItem copyWith({int? quantity, List<SelectedGroupItem>? selectedGroupItems, String? specialInstructions}) {
    return CartItem(menuItemId: menuItemId, name: name, sizeName: sizeName, price: price,
      quantity: quantity ?? this.quantity,
      selectedGroupItems: selectedGroupItems ?? this.selectedGroupItems,
      specialInstructions: specialInstructions ?? this.specialInstructions);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CartItem &&
      runtimeType == other.runtimeType && menuItemId == other.menuItemId &&
      name == other.name && sizeName == other.sizeName && price == other.price &&
      quantity == other.quantity && specialInstructions == other.specialInstructions;

  @override
  int get hashCode => menuItemId.hashCode ^ name.hashCode ^ sizeName.hashCode ^
      price.hashCode ^ quantity.hashCode ^ specialInstructions.hashCode;
}
