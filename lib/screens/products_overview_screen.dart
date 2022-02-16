import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    // productContainer.showFavouriteOnly();
                    _showOnlyFavourite = true;
                  } else {
                    // productContainer.showAll();
                    _showOnlyFavourite = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourites,
                    ),
                    const PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOptions.All,
                    )
                  ]),
          // Consumer<dir.Cart>(
          //   builder: (_, cartData, ch) => Expanded(
          //       child: Badge(
          //           child: ch as Widget, value: cartData.itemCount as String)),
          //   child: Expanded(
          //     child: IconButton(
          //       icon: const Icon(
          //         Icons.add_shopping_cart,
          //       ),
          //       onPressed: () {
          //         Navigator.of(context).pushNamed(CartScreen.routeName);
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavourite),
    );
  }
}
