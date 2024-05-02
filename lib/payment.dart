// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
const _variant = {"amplifyabhi", "amplifyabhi pro"};

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    });
    initStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("In-app Purchase"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            _buy(context);
          },
          child: const Text("Pay For Perchase"),
        ),
      ),
    );
  }

  void initStore() async {
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_variant);

    if (productDetailsResponse.error == null) {
      setState(() {
        _products = productDetailsResponse.productDetails;
      });

      // Call _buy() after _products have been fetched
      _buy(this);
    } else {
      // Handle error
      print("Error fetching product details: ${productDetailsResponse.error}");
    }
  }
}

_listenToPurchase(
    List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pending")));
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Purchased")));
    }
  });
}

void _buy(context) {
  if (_products.isNotEmpty) {
    final PurchaseParam param = PurchaseParam(productDetails: _products[0]);
    _inAppPurchase.buyConsumable(purchaseParam: param);
  } else {
    // Handle case where _products list is empty
    print("Products list is empty");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Products list is empty. Please wait...")),
    );
  }
  if (Platform.isAndroid) {
    // Execute Android-specific code
  } else if (Platform.isIOS) {
    // Execute iOS-specific code
  } else {
    // Execute code for other platforms
  }
}
