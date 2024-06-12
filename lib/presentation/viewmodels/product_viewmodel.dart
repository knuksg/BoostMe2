import 'package:boostme2/core/provider.dart';
import 'package:boostme2/domain/usecases/products/get_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<List<Product>>>((ref) {
  return ProductViewModel(
    getProducts: ref.watch(getProductsProvider),
    getProductsByCategory: ref.watch(getProductsByCategoryProvider),
    getPopularProducts: ref.watch(getPopularProductsProvider),
  );
});

class ProductViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;
  final GetPopularProducts getPopularProducts;

  ProductViewModel({
    required this.getProducts,
    required this.getProductsByCategory,
    required this.getPopularProducts,
  }) : super(const AsyncValue.loading());

  Future<List<Product>> loadProducts() async {
    try {
      final products = await getProducts();
      state = AsyncValue.data(products);
      return products;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Product>> loadProductsByCategory(String category) async {
    try {
      final products = await getProductsByCategory(category);
      state = AsyncValue.data(products);
      return products;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Product>> loadPopularProducts() async {
    try {
      final products = await getPopularProducts();
      state = AsyncValue.data(products);
      return products;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }
}
