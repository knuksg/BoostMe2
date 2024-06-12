import 'package:boostme2/domain/entities/product.dart';
import 'package:boostme2/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
}

class GetPopularProducts {
  final ProductRepository repository;

  GetPopularProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getPopularProducts();
  }
}
