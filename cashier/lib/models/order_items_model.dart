class OrderItems {
  static const String orderItemsTableName = 'order_items';
  static const String colId = 'id';
  static const String colItemName = 'item_name';
  static const String colItemQty = 'item_qty';
  static const String colItemPrice = 'item_price';
  static const String colItemAmount = 'item_amount';
  static const String colItemRef = 'item_ref';

  int? id;
  final String itemRef;
  final String itemName;
  final int itemQty;
  final double itemPrice;
  final double itemAmount;
  OrderItems({
    this.id,
    required this.itemRef,
    required this.itemName,
    required this.itemQty,
    required this.itemPrice,
    required this.itemAmount,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colItemRef: itemRef,
      colItemName: itemName,
      colItemQty: itemQty,
      colItemPrice: itemPrice,
      colItemAmount: itemAmount,
    };

    if (id != null) {
      map[colId] = id;
    }

    return map;
  }

  static OrderItems fromMap(Map<String, dynamic> map) {
    return OrderItems(
      id: map[colId],
      itemRef: map[colItemRef],
      itemName: map[colItemName],
      itemQty: map[colItemQty],
      itemPrice: map[colItemPrice],
      itemAmount: map[colItemAmount],
    );
  }
}
