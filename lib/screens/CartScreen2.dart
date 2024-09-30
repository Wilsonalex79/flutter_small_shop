import 'package:flutter/material.dart';
import 'package:flutter_small_shop/services/CartProvider.dart';
import 'package:provider/provider.dart';

import '../ components/EmptyMessage.dart';
import '../util/Constants.dart';
import '../models/Cart.dart';

class CartScreen extends StatefulWidget {
  final String title;

  const CartScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Move the data fetching logic to didChangeDependencies to access the context
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).getCartItems();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Add logic to clear the cart items here
              Provider.of<CartProvider>(context, listen: false).clearCart();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cartItems.isEmpty) {
                  return EmptyMessage(message: 'Your Cart is Empty');
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cartItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Image(
                                //   height: 80,
                                //   width: 80,
                                //   image:
                                //   AssetImage(provider.cartItems[index].image!),
                                // ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:                                            '${provider.cartItems[index].product.name!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                      // RichText(
                                      //   maxLines: 1,
                                      //   text: TextSpan(
                                      //       text: 'Unit: ',
                                      //       style: TextStyle(
                                      //           color: Colors.blueGrey.shade800,
                                      //           fontSize: 16.0),
                                      //       children: [
                                      //         TextSpan(
                                      //             text:
                                      //             '${provider.cartItems[index].unitTag!}\n',
                                      //             style: const TextStyle(
                                      //                 fontWeight:
                                      //                 FontWeight.bold)),
                                      //       ]),
                                      // ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Price: ' r"$",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                  '${provider.cartItems[index].product.price!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                        // Provider.of<CartProvider>(context, listen: false).removeFromCart(cartItem);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade800,
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {

              // Initialize with '0' or any default value
              final ValueNotifier<String> totalPrice = ValueNotifier('0');
              // Accumulate the total price for all items in the cart
              double total = 0;

              for (var element in value.cartItems) {

                print("${element.product.name} : ${element.product.price} ${element.qty}");

                final productPrice = double.tryParse(element.product.price) ?? 0;
                // final productPrice = element.product.price;

                print(element.product.price);
                print(productPrice);

                total += (productPrice * element.qty) as double;

              }

              // Update the totalPrice value after calculating the total
              totalPrice.value = total.toString();

              return Column(
                children: [
                  ValueListenableBuilder<String?>(
                      valueListenable: totalPrice,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'Sub-Total',
                            value: r'$' + (val ?? '0'));
                      }),
                ],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Successful'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
        required this.addQuantity,
        required this.deleteQuantity,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}