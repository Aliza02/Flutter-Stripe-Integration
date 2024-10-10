import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/network/network_response.dart';
import 'package:http/http.dart' as http;

Future<NetworkEventResponse<Map<String, dynamic>>> createPaymentIntent(
    {required String amount, required String currency}) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var secretKey = dotenv.env['STRIPE_SECRET'];
    var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    if (response.statusCode != 200) {
      return const NetworkEventResponse.failure(
        message: 'Failed to create payment intent',
        status: false,
      );
    }
    return NetworkEventResponse.success(
      message: 'Payment intent created successfully',
      status: true,
      response: jsonDecode(response.body.toString()),
    );
  } catch (e) {
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  }
}

Future<bool> makePayment() async {
  try {
    final paymentIntent = await createPaymentIntent(
      amount: '100',
      currency: 'USD',
    );
    if (paymentIntent.status == true) {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent.response!['client_secret'],
        googlePay: const PaymentSheetGooglePay(
          testEnv: true,
          currencyCode: "USD",
          merchantCountryCode: "US",
        ),
        style: ThemeMode.dark,
        merchantDisplayName: 'Flutter Stripe Store',
      ));

      final response = await displayPaymentSheet();
      return response.status!;
    }

    return false;
  } catch (e) {
    return false;
  }
}

Future<NetworkEventResponse<Map<String, dynamic>>> displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();
    return const NetworkEventResponse.success(
      status: true,
    );
  } on StripeException catch (e) {
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  } catch (e) {
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  }
}
