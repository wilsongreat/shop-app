import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

//   @override
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        //using the future builder to avoid loading data using initState method
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapShots) {
            if (dataSnapShots.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShots.error != null) {
                //handle error
                return const Center(child: Text('An Error Occured'));
              } else {
                return Consumer<Orders>(builder: (context, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  );
                });
              }
            }
          },
        ));
  }
}
// {
// "rules": {
// ".read": "now < 1647644400000",  // 2022-3-19
// ".write": "now < 1647644400000",  // 2022-3-19
// }
// }
