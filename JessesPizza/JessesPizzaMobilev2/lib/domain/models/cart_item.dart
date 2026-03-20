class CartItem {
  final String menuItemId;
  final String name;
  final String? description;
  final String sizeName;
  final String? selectedSizeId;
  final double price;
  final int quantity;
  final String? imageUrl;

  /// Group selection data for the transaction payload.
  final bool requiredChoicesEnabled;
  final String? requiredChoices;
  final String? requiredDelimitedString;
  final bool optionalChoicesEnabled;
  final String? optionalChoices;
  final String? optionalDelimitedString;
  final bool instructionsEnabled;
  final String? instructions;

  const CartItem({
    required this.menuItemId,
    required this.name,
    this.description,
    required this.sizeName,
    this.selectedSizeId,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.requiredChoicesEnabled = false,
    this.requiredChoices,
    this.requiredDelimitedString,
    this.optionalChoicesEnabled = false,
    this.optionalChoices,
    this.optionalDelimitedString,
    this.instructionsEnabled = false,
    this.instructions,
  });

  double get lineTotal => price * quantity;

  CartItem copyWith({
    String? menuItemId,
    String? name,
    String? description,
    String? sizeName,
    String? selectedSizeId,
    double? price,
    int? quantity,
    String? imageUrl,
    bool? requiredChoicesEnabled,
    String? requiredChoices,
    String? requiredDelimitedString,
    bool? optionalChoicesEnabled,
    String? optionalChoices,
    String? optionalDelimitedString,
    bool? instructionsEnabled,
    String? instructions,
  }) {
    return CartItem(
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      sizeName: sizeName ?? this.sizeName,
      selectedSizeId: selectedSizeId ?? this.selectedSizeId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      requiredChoicesEnabled:
          requiredChoicesEnabled ?? this.requiredChoicesEnabled,
      requiredChoices: requiredChoices ?? this.requiredChoices,
      requiredDelimitedString:
          requiredDelimitedString ?? this.requiredDelimitedString,
      optionalChoicesEnabled:
          optionalChoicesEnabled ?? this.optionalChoicesEnabled,
      optionalChoices: optionalChoices ?? this.optionalChoices,
      optionalDelimitedString:
          optionalDelimitedString ?? this.optionalDelimitedString,
      instructionsEnabled: instructionsEnabled ?? this.instructionsEnabled,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          menuItemId == other.menuItemId &&
          name == other.name &&
          sizeName == other.sizeName &&
          price == other.price &&
          quantity == other.quantity &&
          selectedSizeId == other.selectedSizeId &&
          requiredChoices == other.requiredChoices &&
          optionalChoices == other.optionalChoices &&
          instructions == other.instructions;

  @override
  int get hashCode =>
      menuItemId.hashCode ^
      name.hashCode ^
      sizeName.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      selectedSizeId.hashCode ^
      requiredChoices.hashCode ^
      optionalChoices.hashCode ^
      instructions.hashCode;
}
