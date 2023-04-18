class ProductNotFoundException implements Exception{
  String message;
  ProductNotFoundException(this.message) : super();
}