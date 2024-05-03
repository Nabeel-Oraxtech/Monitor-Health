// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

const String testID = 'book_test';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  late StreamSubscription _subscription;
  int _coins = 0;
  Future<void> _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      await _getUserProducts();
      await _getPastPurchases();
      _verifyPurchases();
      _subscription = _iap.purchaseStream.listen((data) => setState(() {
            _purchases.addAll(data);
            _verifyPurchases();
          }));
    }
  }

  Future<void> _getUserProducts() async {
    Set<String> ids = {testID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _getPastPurchases() async {
    InAppPurchase.instance.purchaseStream.listen((purchaseDetailsList) {
      List<PurchaseDetails> pastPurchases =
          purchaseDetailsList.where((purchase) {
        return purchase.status == PurchaseStatus.purchased;
      }).toList();

      setState(() {
        _purchases = pastPurchases;
      });
    });
    List<PurchaseDetails> initialPastPurchases =
        InAppPurchase.instance.purchaseStream.first as List<PurchaseDetails>;
    setState(() {
      _purchases = initialPastPurchases;
    });
  }

  PurchaseDetails _hasUserPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID);
  }

  void _verifyPurchases() {
    PurchaseDetails purchase = _hasUserPurchased(testID);
    if (purchase.status == PurchaseStatus.purchased) {
      _coins = 10;
    }
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  void spendCoins(PurchaseDetails purchase) async {
    setState(() {
      _coins--;
    });

    if (_coins == 0) {
      if (Platform.isAndroid) {
        // Consume purchase for Android
        final BillingClient billingClient =
            BillingClient((_, __) {} as PurchasesUpdatedListener, null);
        await billingClient.startConnection(
            onBillingServiceDisconnected: () {});
        await billingClient.consumeAsync(purchase.purchaseID!);
        await billingClient.endConnection();
      } else if (Platform.isIOS) {
        // Consume purchase for iOS
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isAvailable ? 'Product Available' : 'No Product Available'),
      ),
      body: Center(
        child: Column(
          children: [
            for (var product in _products)
              if (_hasUserPurchased(product.id) != null) ...[
                Text(
                  '$_coins',
                  style: const TextStyle(fontSize: 30),
                ),
                ElevatedButton(
                    onPressed: () => spendCoins(_hasUserPurchased(product.id)),
                    child: const Text('Consume')),
              ] else ...[
                Text(
                  product.title,
                ),
                Text(product.description),
                Text(product.price),
                ElevatedButton(
                    onPressed: () => _buyProduct(product),
                    child: const Text(''))
              ]
          ],
        ),
      ),
    );
  }
}
