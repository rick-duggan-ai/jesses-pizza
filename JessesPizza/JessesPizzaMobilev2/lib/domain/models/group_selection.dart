import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

class SelectedGroupItem {
  final MenuGroupItem groupItem;
  final int sizeIndex;
  final int sideIndex;

  const SelectedGroupItem({required this.groupItem, this.sizeIndex = 0, this.sideIndex = 0});

  MenuItemSize? get selectedSize => groupItem.sizes.isNotEmpty ? groupItem.sizes[sizeIndex] : null;
  GroupItemOption? get selectedSide => groupItem.sides.isNotEmpty ? groupItem.sides[sideIndex] : null;

  double get additionalPrice {
    double total = 0.0;
    if (selectedSize != null) total += selectedSize!.price;
    if (selectedSide != null) total += selectedSide!.price;
    return total;
  }

  String get optionsLabel {
    final parts = <String>[];
    if (selectedSize != null && groupItem.sizes.length > 1) parts.add(selectedSize!.name);
    if (selectedSide != null && groupItem.sides.length > 1) parts.add(selectedSide!.name);
    return parts.isEmpty ? '' : '(${parts.join(', ')})';
  }

  SelectedGroupItem copyWith({int? sizeIndex, int? sideIndex}) {
    return SelectedGroupItem(groupItem: groupItem, sizeIndex: sizeIndex ?? this.sizeIndex, sideIndex: sideIndex ?? this.sideIndex);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SelectedGroupItem &&
      runtimeType == other.runtimeType && groupItem.id == other.groupItem.id &&
      sizeIndex == other.sizeIndex && sideIndex == other.sideIndex;

  @override
  int get hashCode => groupItem.id.hashCode ^ sizeIndex.hashCode ^ sideIndex.hashCode;
}

class GroupSelection {
  final MenuGroup group;
  final List<SelectedGroupItem> selectedItems;

  const GroupSelection({required this.group, this.selectedItems = const []});

  bool get isValid {
    if (!group.isRequired) return true;
    switch (group.groupTypeEnum) {
      case GroupType.single: return selectedItems.isNotEmpty;
      case GroupType.multiple: return selectedItems.isNotEmpty;
      case GroupType.minMax: return selectedItems.length >= group.min && (group.max == 0 || selectedItems.length <= group.max);
    }
  }

  double get totalAdditionalPrice => selectedItems.fold(0.0, (sum, item) => sum + item.additionalPrice);
  bool isItemSelected(MenuGroupItem item) => selectedItems.any((s) => s.groupItem.id == item.id);

  String? get validationMessage {
    if (isValid) return null;
    if (group.groupTypeEnum == GroupType.minMax) {
      return group.max > 0 ? '${group.name}: select ${group.min}-${group.max} items' : '${group.name}: select at least ${group.min} items';
    }
    return '${group.name}: selection required';
  }

  GroupSelection copyWith({List<SelectedGroupItem>? selectedItems}) {
    return GroupSelection(group: group, selectedItems: selectedItems ?? this.selectedItems);
  }

  GroupSelection toggleItem(MenuGroupItem item) {
    final isSelected = isItemSelected(item);
    switch (group.groupTypeEnum) {
      case GroupType.single:
        if (isSelected) return copyWith(selectedItems: selectedItems.where((s) => s.groupItem.id != item.id).toList());
        return copyWith(selectedItems: [_createSelectedItem(item)]);
      case GroupType.multiple:
        if (isSelected) return copyWith(selectedItems: selectedItems.where((s) => s.groupItem.id != item.id).toList());
        return copyWith(selectedItems: [...selectedItems, _createSelectedItem(item)]);
      case GroupType.minMax:
        if (isSelected) return copyWith(selectedItems: selectedItems.where((s) => s.groupItem.id != item.id).toList());
        if (group.max == 0 || selectedItems.length < group.max) return copyWith(selectedItems: [...selectedItems, _createSelectedItem(item)]);
        return this;
    }
  }

  GroupSelection updateSizeIndex(String itemId, int newSizeIndex) {
    return copyWith(selectedItems: selectedItems.map((s) => s.groupItem.id == itemId ? s.copyWith(sizeIndex: newSizeIndex) : s).toList());
  }

  GroupSelection updateSideIndex(String itemId, int newSideIndex) {
    return copyWith(selectedItems: selectedItems.map((s) => s.groupItem.id == itemId ? s.copyWith(sideIndex: newSideIndex) : s).toList());
  }

  SelectedGroupItem _createSelectedItem(MenuGroupItem item) {
    int sizeIndex = 0;
    if (item.sizes.isNotEmpty) { final di = item.sizes.indexWhere((s) => s.isDefault); if (di >= 0) sizeIndex = di; }
    int sideIndex = 0;
    if (item.sides.isNotEmpty) { final di = item.sides.indexWhere((s) => s.isDefault); if (di >= 0) sideIndex = di; }
    return SelectedGroupItem(groupItem: item, sizeIndex: sizeIndex, sideIndex: sideIndex);
  }
}
