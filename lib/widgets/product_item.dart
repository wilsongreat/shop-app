import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart.dart';
import 'package:shop_app/providers/product_model.dart';
import 'package:shop_app/screens/product_details.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem(
  //     {Key? key, required this.title, required this.imageUrl, required this.id})
  //     : super(key: key);
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
              arguments: products.id);
        },
        child: GridTile(
          child: Image.network(
            products.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
              leading: Consumer<Product>(
                builder: (ctx, products, child) => IconButton(
                  onPressed: () {
                    products.toggleFavouriteStatus();
                  },
                  icon: Icon(products.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  cart.addItem(products.id, products.price, products.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added item to cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(products.id);
                      },
                    ),
                  ));
                },
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              title: Text(
                products.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54),
        ),
      ),
    );
  }
}
