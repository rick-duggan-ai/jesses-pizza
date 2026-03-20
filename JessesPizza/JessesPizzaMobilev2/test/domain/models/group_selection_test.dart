import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/group_selection.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

void main() {
  MenuGroupItem makeItem(String id, {double sizePrice = 0, int sideCount = 0}) {
    return MenuGroupItem(id: id, name: 'Item $id',
      sizes: [MenuItemSize(name: 'Regular', price: sizePrice, isDefault: true), if (sizePrice > 0) MenuItemSize(name: 'Large', price: sizePrice + 1.0)],
      sides: List.generate(sideCount, (i) => GroupItemOption(name: 'Side $i', price: i * 0.5, isDefault: i == 0)));
  }
  MenuGroup makeGroup({required String id, required int groupType, bool isRequired = false, int min = 0, int max = 0, List<MenuGroupItem>? items}) {
    return MenuGroup(id: id, name: 'Group $id', groupType: groupType, isRequired: isRequired, min: min, max: max, items: items ?? [makeItem('a'), makeItem('b'), makeItem('c')]);
  }

  group('GroupType extension', () {
    test('maps integer groupType to enum', () {
      expect(const MenuGroup(id: '1', name: 'G', groupType: 0).groupTypeEnum, GroupType.single);
      expect(const MenuGroup(id: '1', name: 'G', groupType: 1).groupTypeEnum, GroupType.multiple);
      expect(const MenuGroup(id: '1', name: 'G', groupType: 2).groupTypeEnum, GroupType.minMax);
      expect(const MenuGroup(id: '1', name: 'G', groupType: 99).groupTypeEnum, GroupType.single);
    });
  });
  group('SelectedGroupItem', () {
    test('additionalPrice sums size and side prices', () {
      final item = makeItem('x', sizePrice: 2.0, sideCount: 3);
      final selected = SelectedGroupItem(groupItem: item, sizeIndex: 0, sideIndex: 1);
      expect(selected.additionalPrice, 2.5);
    });
    test('optionsLabel shows size and side when multiple options', () {
      final item = makeItem('x', sizePrice: 2.0, sideCount: 2);
      final selected = SelectedGroupItem(groupItem: item, sizeIndex: 1, sideIndex: 1);
      expect(selected.optionsLabel, contains('Large'));
      expect(selected.optionsLabel, contains('Side 1'));
    });
  });
  group('GroupSelection - Single type', () {
    late MenuGroup g;
    setUp(() { g = makeGroup(id: 'g1', groupType: 0, isRequired: true); });
    test('toggleItem selects one item', () { var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); expect(gs.selectedItems.length, 1); });
    test('toggleItem replaces selection', () { var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); gs = gs.toggleItem(g.items[1]); expect(gs.selectedItems.length, 1); expect(gs.isItemSelected(g.items[1]), true); });
    test('toggleItem deselects same item', () { var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); gs = gs.toggleItem(g.items[0]); expect(gs.selectedItems.length, 0); });
    test('isValid requires selection when isRequired', () { var gs = GroupSelection(group: g); expect(gs.isValid, false); gs = gs.toggleItem(g.items[0]); expect(gs.isValid, true); });
    test('isValid always true when not required', () { final og = makeGroup(id: 'g2', groupType: 0); expect(GroupSelection(group: og).isValid, true); });
  });
  group('GroupSelection - Multiple type', () {
    late MenuGroup g;
    setUp(() { g = makeGroup(id: 'g1', groupType: 1, isRequired: true); });
    test('allows selecting multiple items', () { var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); gs = gs.toggleItem(g.items[1]); expect(gs.selectedItems.length, 2); });
    test('deselects individual items', () { var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); gs = gs.toggleItem(g.items[1]); gs = gs.toggleItem(g.items[0]); expect(gs.selectedItems.length, 1); });
  });
  group('GroupSelection - MinMax type', () {
    late MenuGroup g;
    setUp(() { g = makeGroup(id: 'g1', groupType: 2, isRequired: true, min: 2, max: 3); });
    test('isValid checks min and max', () {
      var gs = GroupSelection(group: g);
      expect(gs.isValid, false);
      gs = gs.toggleItem(g.items[0]); expect(gs.isValid, false);
      gs = gs.toggleItem(g.items[1]); expect(gs.isValid, true);
      gs = gs.toggleItem(g.items[2]); expect(gs.isValid, true);
    });
    test('validationMessage returns message when invalid', () { expect(GroupSelection(group: g).validationMessage, contains('2-3')); });
  });
  group('GroupSelection - size/side updates', () {
    test('updateSizeIndex changes size', () {
      final g = makeGroup(id: 'g1', groupType: 1, items: [makeItem('a', sizePrice: 1.0)]);
      var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]);
      gs = gs.updateSizeIndex('a', 1);
      expect(gs.selectedItems[0].selectedSize?.name, 'Large');
    });
    test('updateSideIndex changes side', () {
      final g = makeGroup(id: 'g1', groupType: 1, items: [makeItem('a', sideCount: 3)]);
      var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]);
      gs = gs.updateSideIndex('a', 2);
      expect(gs.selectedItems[0].selectedSide?.name, 'Side 2');
    });
  });
  group('GroupSelection - price calculation', () {
    test('totalAdditionalPrice sums all', () {
      final g = makeGroup(id: 'g1', groupType: 1, items: [makeItem('a', sizePrice: 1.5), makeItem('b', sizePrice: 2.0)]);
      var gs = GroupSelection(group: g); gs = gs.toggleItem(g.items[0]); gs = gs.toggleItem(g.items[1]);
      expect(gs.totalAdditionalPrice, 3.5);
    });
  });
}
