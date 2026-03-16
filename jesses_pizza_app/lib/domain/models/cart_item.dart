class CartItem {
  final String menuItemId;
  final String name;
  final String sizeName;
  final double price;
  final int quantity;

  const CartItem({
    required this.menuItemId,
    required this.name,
    required this.sizeName,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuItemId: menuItemId,
      name: name,
      sizeName: sizeName,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
