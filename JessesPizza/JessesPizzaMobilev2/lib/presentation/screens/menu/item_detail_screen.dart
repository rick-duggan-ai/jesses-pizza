import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/group_selection.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem item;
  /// When editing an existing cart item, pass the cart item and its index.
  final CartItem? existingCartItem;
  final int? existingCartIndex;
  const ItemDetailScreen({super.key, required this.item, this.existingCartItem, this.existingCartIndex});
  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _selectedSizeIndex = 0;
  int _quantity = 1;
  String _specialInstructions = '';
  late List<GroupSelection> _groupSelections;
  bool _showValidationErrors = false;
  bool _isAddingToCart = false;
  late final TextEditingController _instructionsController;

  bool get _isEditMode => widget.existingCartItem != null;

  @override
  void initState() {
    super.initState();
    _groupSelections = [];
    final sizes = widget.item.sizes;
    final existing = widget.existingCartItem;
    if (existing != null) {
      // Pre-fill from existing cart item
      _quantity = existing.quantity;
      _specialInstructions = existing.specialInstructions;
      final sizeIdx = sizes.indexWhere((s) => s.name == existing.sizeName);
      if (sizeIdx >= 0) _selectedSizeIndex = sizeIdx;
    } else if (sizes.isNotEmpty) {
      final defaultIdx = sizes.indexWhere((s) => s.isDefault);
      if (defaultIdx >= 0) _selectedSizeIndex = defaultIdx;
    }
    _instructionsController = TextEditingController(text: _specialInstructions);
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  List<MenuGroup> _getGroupsForSize(List<MenuGroup> allGroups) {
    final sizes = widget.item.sizes;
    if (sizes.isEmpty || _selectedSizeIndex >= sizes.length) return [];
    final selectedSize = sizes[_selectedSizeIndex];
    if (selectedSize.groupIds.isEmpty) return [];
    return allGroups.where((g) => selectedSize.groupIds.contains(g.id)).toList();
  }

  bool _groupsInitializedFromCart = false;

  void _updateGroupSelections(List<MenuGroup> groups) {
    final existingMap = {for (final gs in _groupSelections) gs.group.id: gs};

    // On first call in edit mode, pre-select items from the existing cart item.
    if (_isEditMode && !_groupsInitializedFromCart && groups.isNotEmpty) {
      _groupsInitializedFromCart = true;
      final cartSelections = widget.existingCartItem!.selectedGroupItems;
      final cartItemIds = {for (final s in cartSelections) s.groupItem.id: s};
      _groupSelections = groups.map((g) {
        final preSelected = <SelectedGroupItem>[];
        for (final gi in g.items) {
          if (cartItemIds.containsKey(gi.id)) {
            final saved = cartItemIds[gi.id]!;
            preSelected.add(SelectedGroupItem(
              groupItem: gi,
              sizeIndex: saved.sizeIndex,
              sideIndex: saved.sideIndex,
            ));
          }
        }
        return GroupSelection(group: g, selectedItems: preSelected);
      }).toList();
      return;
    }

    _groupSelections = groups.map((g) {
      if (existingMap.containsKey(g.id)) return existingMap[g.id]!;
      return GroupSelection(group: g);
    }).toList();
  }

  double _calculateTotal() {
    final sizes = widget.item.sizes;
    if (sizes.isEmpty) return 0;
    double total = sizes[_selectedSizeIndex].price;
    for (final gs in _groupSelections) { total += gs.totalAdditionalPrice; }
    return total * _quantity;
  }

  bool _validateSelections() => _groupSelections.every((gs) => gs.isValid);

  List<String> _getValidationErrors() {
    return _groupSelections.map((gs) => gs.validationMessage).where((msg) => msg != null).cast<String>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final sizes = item.sizes;
    return Scaffold(
      appBar: AppBar(title: Text(item.name ?? '')),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, menuState) {
          bool isStoreOpen = true;
          List<MenuGroup> allGroups = [];
          if (menuState is MenuLoaded) {
            isStoreOpen = menuState.isStoreOpen;
            allGroups = menuState.groups;
          }
          final sizeGroups = _getGroupsForSize(allGroups);
          _updateGroupSelections(sizeGroups);
          final total = _calculateTotal();
          return Column(children: [
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _buildImage(item),
                const SizedBox(height: 16),
                Text(item.name ?? '', style: Theme.of(context).textTheme.headlineSmall),
                if (item.description != null) ...[const SizedBox(height: 8), Text(item.description!, style: Theme.of(context).textTheme.bodyMedium)],
                const SizedBox(height: 24),
                if (sizes.isNotEmpty) ...[_buildSizeSection(sizes), const SizedBox(height: 16)],
                ..._groupSelections.map(_buildGroupSection),
                const SizedBox(height: 16),
                _buildSpecialInstructions(),
                const SizedBox(height: 16),
                _buildQuantitySelector(),
                if (_showValidationErrors) ...[const SizedBox(height: 12),
                  ..._getValidationErrors().map((msg) => Padding(padding: const EdgeInsets.only(bottom: 4),
                    child: Text(msg, style: TextStyle(color: Colors.red.shade700, fontSize: 13))))],
                if (!isStoreOpen) ...[const SizedBox(height: 12),
                  Text('Store is currently closed. Ordering is unavailable.',
                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold), textAlign: TextAlign.center)],
                const SizedBox(height: 80),
              ]),
            )),
            _buildBottomBar(isStoreOpen, sizes.isNotEmpty, total),
          ]);
        },
      ),
    );
  }

  Widget _buildImage(MenuItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: item.imageUrl != null
          ? CachedNetworkImage(imageUrl: item.imageUrl!, height: 220, width: double.infinity, fit: BoxFit.cover,
              placeholder: (_, __) => Container(height: 220, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator())),
              errorWidget: (_, __, ___) => Container(height: 220, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.local_pizza, size: 80))))
          : Container(height: 220, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.local_pizza, size: 80))),
    );
  }

  Widget _buildSizeSection(List<MenuItemSize> sizes) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Select Size', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Column(children: sizes.asMap().entries.map((entry) {
        final idx = entry.key; final size = entry.value;
        return RadioListTile<int>(
          value: idx,
          groupValue: _selectedSizeIndex,
          onChanged: (val) { if (val != null) setState(() { _selectedSizeIndex = val; _groupSelections = []; }); },
          title: Text(size.name), subtitle: Text('\$${size.price.toStringAsFixed(2)}'), dense: true, contentPadding: EdgeInsets.zero);
      }).toList()),
    ]);
  }

  Widget _buildGroupSection(GroupSelection groupSelection) {
    final group = groupSelection.group;
    final hasError = _showValidationErrors && !groupSelection.isValid;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Divider(),
      Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [
        if (group.imageUrl != null && group.imageUrl!.isNotEmpty) ...[
          ClipRRect(borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(imageUrl: group.imageUrl!, width: 28, height: 28, fit: BoxFit.cover, errorWidget: (_, __, ___) => const SizedBox.shrink())),
          const SizedBox(width: 8),
        ],
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(group.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: hasError ? Colors.red.shade700 : null)),
          Text(_groupSubtitle(group), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hasError ? Colors.red.shade700 : Colors.grey.shade600)),
        ])),
        if (group.isRequired) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: hasError ? Colors.red.shade100 : Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
          child: Text('Required', style: TextStyle(fontSize: 11, color: hasError ? Colors.red.shade700 : Colors.grey.shade700, fontWeight: FontWeight.w500))),
      ])),
      if (group.groupTypeEnum == GroupType.single)
        Column(children: group.items.map((gi) {
          final isSelected = groupSelection.isItemSelected(gi);
          return RadioListTile<String>(
            value: gi.id,
            groupValue: groupSelection.selectedItems.isNotEmpty ? groupSelection.selectedItems.first.groupItem.id : null,
            onChanged: (val) {
              if (val != null) {
                final item = group.items.firstWhere((i) => i.id == val);
                _toggle(group.id, item);
              }
            },
            title: Text(_giLabel(gi, isSelected ? groupSelection.selectedItems.where((s) => s.groupItem.id == gi.id).firstOrNull : null)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        }).toList())
      else
        ...group.items.map((gi) => _buildGroupItemTile(groupSelection, gi)),
    ]);
  }

  String _groupSubtitle(MenuGroup group) {
    switch (group.groupTypeEnum) {
      case GroupType.single: return 'Choose one';
      case GroupType.multiple: return 'Choose any';
      case GroupType.minMax: return group.max > 0 ? 'Choose ${group.min}-${group.max}' : 'Choose at least ${group.min}';
    }
  }

  Widget _buildGroupItemTile(GroupSelection gs, MenuGroupItem gi) {
    final isSelected = gs.isItemSelected(gi);
    final group = gs.group;
    SelectedGroupItem? sd;
    if (isSelected) sd = gs.selectedItems.where((s) => s.groupItem.id == gi.id).firstOrNull;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withAlpha(77) : null,
      elevation: isSelected ? 1 : 0,
      child: InkWell(borderRadius: BorderRadius.circular(12), onTap: () => _toggle(group.id, gi),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(children: [
            Row(children: [
              Checkbox(value: isSelected, onChanged: (_) => _toggle(group.id, gi),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact),
              if (gi.imageUrl != null && gi.imageUrl!.isNotEmpty) ...[const SizedBox(width: 4),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(imageUrl: gi.imageUrl!, width: 28, height: 28, fit: BoxFit.cover, errorWidget: (_, __, ___) => const SizedBox.shrink()))],
              const SizedBox(width: 8),
              Expanded(child: Text(_giLabel(gi, sd), style: Theme.of(context).textTheme.bodyMedium)),
            ]),
            if (isSelected && sd != null) ...[
              if (gi.sizes.length > 1) ...[const SizedBox(height: 8),
                _stepper(label: sd.selectedSize?.name ?? '', canDec: sd.sizeIndex > 0, canInc: sd.sizeIndex < gi.sizes.length - 1,
                  onDec: () => _updSize(group.id, gi.id, sd!.sizeIndex - 1), onInc: () => _updSize(group.id, gi.id, sd!.sizeIndex + 1))],
              if (gi.sides.length > 1) ...[const SizedBox(height: 4),
                _stepper(label: sd.selectedSide?.name ?? '', canDec: sd.sideIndex > 0, canInc: sd.sideIndex < gi.sides.length - 1,
                  onDec: () => _updSide(group.id, gi.id, sd!.sideIndex - 1), onInc: () => _updSide(group.id, gi.id, sd!.sideIndex + 1))],
            ],
          ]),
        ),
      ),
    );
  }

  void _toggle(String gid, MenuGroupItem gi) {
    setState(() { final i = _groupSelections.indexWhere((gs) => gs.group.id == gid); if (i >= 0) _groupSelections[i] = _groupSelections[i].toggleItem(gi); });
  }
  void _updSize(String gid, String iid, int ni) {
    setState(() { final i = _groupSelections.indexWhere((gs) => gs.group.id == gid); if (i >= 0) _groupSelections[i] = _groupSelections[i].updateSizeIndex(iid, ni); });
  }
  void _updSide(String gid, String iid, int ni) {
    setState(() { final i = _groupSelections.indexWhere((gs) => gs.group.id == gid); if (i >= 0) _groupSelections[i] = _groupSelections[i].updateSideIndex(iid, ni); });
  }

  String _giLabel(MenuGroupItem gi, SelectedGroupItem? sd) {
    final name = gi.name ?? '';
    if (sd == null) {
      if (gi.sizes.isNotEmpty) {
        final di = gi.sizes.indexWhere((s) => s.isDefault);
        final p = di >= 0 ? gi.sizes[di].price : gi.sizes.first.price;
        if (p > 0) return '$name +\$${p.toStringAsFixed(2)}';
      }
      return name;
    }
    final e = sd.additionalPrice;
    return e > 0 ? '$name +\$${e.toStringAsFixed(2)}' : name;
  }

  Widget _stepper({required String label, required bool canDec, required bool canInc, required VoidCallback onDec, required VoidCallback onInc}) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(icon: const Icon(Icons.remove_circle_outline, size: 20), onPressed: canDec ? onDec : null, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
      SizedBox(width: 120, child: Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall)),
      IconButton(icon: const Icon(Icons.add_circle_outline, size: 20), onPressed: canInc ? onInc : null, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
    ]);
  }

  Widget _buildSpecialInstructions() {
    return TextField(controller: _instructionsController, decoration: const InputDecoration(labelText: 'Special Instructions', hintText: 'Tap to add special instructions',
      border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)), maxLines: 2, onChanged: (val) => _specialInstructions = val);
  }

  Widget _buildQuantitySelector() {
    return Row(children: [
      Text('Quantity', style: Theme.of(context).textTheme.titleMedium), const Spacer(),
      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null),
      Text('$_quantity', style: Theme.of(context).textTheme.titleLarge),
      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _quantity++)),
    ]);
  }

  Widget _buildBottomBar(bool isStoreOpen, bool hasSizes, double total) {
    final buttonLabel = _isEditMode
        ? 'Update Item - \$${total.toStringAsFixed(2)}'
        : 'Add to Cart - \$${total.toStringAsFixed(2)}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(child: ElevatedButton(
        onPressed: isStoreOpen && hasSizes && !_isAddingToCart ? _addToCart : null,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
        child: _isAddingToCart
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(buttonLabel, style: const TextStyle(fontSize: 16)))),
    );
  }

  void _addToCart() {
    if (_isAddingToCart) return;
    if (!_validateSelections()) {
      setState(() => _showValidationErrors = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all required selections'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _isAddingToCart = true);
    final item = widget.item;
    final size = item.sizes[_selectedSizeIndex];
    final allSelectedItems = _groupSelections.expand((gs) => gs.selectedItems).toList();
    final cartItem = CartItem(menuItemId: item.id ?? '', name: item.name ?? '', sizeName: size.name, price: size.price, quantity: _quantity,
      selectedGroupItems: allSelectedItems, specialInstructions: _specialInstructions.trim());
    if (_isEditMode) {
      context.read<CartBloc>().add(UpdateItem(index: widget.existingCartIndex!, item: cartItem));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart item updated')));
    } else {
      context.read<CartBloc>().add(AddItem(cartItem));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    }
    Navigator.of(context).pop();
  }
}
