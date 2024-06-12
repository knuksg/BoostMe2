import '../datasources/remote_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    print('category: $category');
    final products = await remoteDataSource.getProductsByCategory(category);
    print('products: $products');
    return products;
  }

  @override
  Future<List<Product>> getPopularProducts() async {
    return await remoteDataSource.getPopularProducts();
  }
}
