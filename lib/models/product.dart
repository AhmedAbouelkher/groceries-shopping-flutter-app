class Product {
  final String name;
  final String picPath;
  final String weight;
  final String description;
  final String price;
  int orderedQuantity;

  Product({
    this.name = 'null',
    this.picPath = 'null',
    this.weight = 'null',
    this.description =
        '''This is a professional description, so that you can buy our overpriced product, go home an be happy!''',
    this.price = 'null',
    this.orderedQuantity = 1,
  });

  void makeOrder({int bulkOrder = 0}) {
    if (bulkOrder == 0) {
      orderedQuantity++;
      return;
    }
    orderedQuantity += bulkOrder;
  }
}
