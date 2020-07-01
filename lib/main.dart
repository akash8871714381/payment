import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Payment());
}

class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_Wh0VxDyTQdsVcv',
      'amount': totalAmount * 100,
      'name': 'Digiblade',
      'external': {
        'wallets': ['paytm'],
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "success:" + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "error:" + response.code.toString() + "." + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "external wallet:" + response.walletName);
  }

  int totalAmount = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LimitedBox(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "please Enter amount"),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = num.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  onPressed: () {
                    openCheckout();
                  },
                  child: Text("Payment")),
            ],
          ),
        ),
      ),
    );
  }
}
