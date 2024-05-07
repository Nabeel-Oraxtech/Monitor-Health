// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<String> _productIDs = [
    'product.sub.dev',
    'com.product.unsub',
    'new_product'
  ];

  bool _available = true;
  List<ProductDetails> _products = [];
  final List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      setState(() {
        _purchases.addAll(purchaseDetailsList);
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      _subscription!.cancel();
    });

    _initialize();

    super.initState();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();

    List<ProductDetails> products = await _getProducts(
      productIds: _productIDs.toSet(),
    );

    setState(() {
      _products = products;
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (int i = 0; i < purchaseDetailsList.length; i++) {
      PurchaseDetails purchaseDetails = purchaseDetailsList[i];
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _showPendingUI();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          bool valid = await _verifyPurchase(purchaseDetails);
          if (!valid) {
            _handleInvalidPurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.error:
          print(purchaseDetails.error!);
          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _showPendingUI() {
    // Placeholder UI for pending purchases
    print("Showing pending UI...");
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Placeholder logic to verify purchase
    // For example, check if the purchase is valid by validating signature, product ID, etc.
    bool isValidPurchase = false;

    // Add your verification logic here
    // For demonstration, let's assume all purchases are valid
    isValidPurchase = true;

    return isValidPurchase;
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // Placeholder logic to handle invalid purchases
    // For example, notify the user, log the error, etc.
    print("Invalid purchase detected: ${purchaseDetails.error}");
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  ListTile _buildProduct({required ProductDetails product}) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: Text('${product.title} - ${product.price}'),
      subtitle: Text(product.description),
      trailing: ElevatedButton(
        onPressed: () {
          _subscribe(product: product);
        },
        child: const Text(
          'Subscribe',
        ),
      ),
    );
  }

  ListTile _buildPurchase({required PurchaseDetails purchase}) {
    if (purchase.error != null) {
      return ListTile(
        title: Text('${purchase.error}'),
        subtitle: Text(purchase.status.toString()),
      );
    }

    String? transactionDate;
    if (purchase.status == PurchaseStatus.purchased) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchase.transactionDate!),
      );
      transactionDate = ' @ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(date)}';
    }

    return ListTile(
      title: Text('${purchase.productID} ${transactionDate ?? ''}'),
      subtitle: Text(purchase.status.toString()),
    );
  }

  void _subscribe({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Purchase'),
      ),
      body: _available
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Products ${_products.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProduct(
                            product: _products[index],
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Past Purchases: ${_purchases.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _purchases.length,
                        itemBuilder: (context, index) {
                          return _buildPurchase(
                            purchase: _purchases[index],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('The Store Is Not Available'),
            ),
    );
  }
}
