import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/group_selection.dart';

part 'cart_item.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required String menuItemId,
    required String name,
    String? description,
    required String sizeName,
    String? selectedSizeId,
    String? imageUrl,
    required double price,
    required int quantity,
    @Default([]) List<SelectedGroupItem> selectedGroupItems,
    @Default('') String specialInstructions,
    @Default(false) bool requiredChoicesEnabled,
    String? requiredChoices,
    String? requiredDelimitedString,
    @Default(false) bool optionalChoicesEnabled,
    String? optionalChoices,
    String? optionalDelimitedString,
    @Default(false) bool instructionsEnabled,
    String? instructions,
  }) = _CartItem;

  double get totalPrice {
    double total = price;
    for (final item in selectedGroupItems) {
      total += item.additionalPrice;
    }
    return total;
  }

  double get lineTotal => totalPrice * quantity;

  /// Serialize scalar fields for local cart persistence.
  /// Note: selectedGroupItems are not persisted (they reference complex menu models).
  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'name': name,
        'description': description,
        'sizeName': sizeName,
        'selectedSizeId': selectedSizeId,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'specialInstructions': specialInstructions,
        'requiredChoicesEnabled': requiredChoicesEnabled,
        'requiredChoices': requiredChoices,
        'requiredDelimitedString': requiredDelimitedString,
        'optionalChoicesEnabled': optionalChoicesEnabled,
        'optionalChoices': optionalChoices,
        'optionalDelimitedString': optionalDelimitedString,
        'instructionsEnabled': instructionsEnabled,
        'instructions': instructions,
      };

  /// Deserialize from JSON for local cart persistence.
  static CartItem fromJson(Map<String, dynamic> json) => CartItem(
        menuItemId: json['menuItemId'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        sizeName: json['sizeName'] as String,
        selectedSizeId: json['selectedSizeId'] as String?,
        imageUrl: json['imageUrl'] as String?,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        specialInstructions: json['specialInstructions'] as String? ?? '',
        requiredChoicesEnabled: json['requiredChoicesEnabled'] as bool? ?? false,
        requiredChoices: json['requiredChoices'] as String?,
        requiredDelimitedString: json['requiredDelimitedString'] as String?,
        optionalChoicesEnabled: json['optionalChoicesEnabled'] as bool? ?? false,
        optionalChoices: json['optionalChoices'] as String?,
        optionalDelimitedString: json['optionalDelimitedString'] as String?,
        instructionsEnabled: json['instructionsEnabled'] as bool? ?? false,
        instructions: json['instructions'] as String?,
      );

  String get selectionsDescription {
    if (selectedGroupItems.isEmpty) return '';
    return selectedGroupItems.map((s) {
      final label = s.groupItem.name ?? '';
      final options = s.optionsLabel;
      return options.isEmpty ? label : '$label $options';
    }).join(', ');
  }
}
