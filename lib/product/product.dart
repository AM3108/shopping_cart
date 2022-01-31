class ProductData {
  List<ProductItem> productItems;

  ProductData({required this.productItems});
}

class ProductItem {
  String productName;
  String productUnit;
  int productPrice;
  String productImage;
  String category;
  int quantity;

  ProductItem(
      {required this.productName,
      required this.productImage,
      required this.productPrice,
      required this.quantity,
      required this.category,
      required this.productUnit});
}
