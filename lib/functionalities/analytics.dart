import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  static final AnalyticsService _analyticsService =
      AnalyticsService._internal();

  AnalyticsService._internal();

  factory AnalyticsService() {
    return _analyticsService;
  }
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  FirebaseAnalyticsObserver getObserver() => observer;

  Future<void> logAddToCart(
      String id, String name, String category, String quantity) async {
    await analytics.logAddToCart(
        itemId: id, itemName: name, itemCategory: category, quantity: null);
  }

  Future<void> logPurchase(
      String paymentMethod, String amount, String userId, String email) async {
    await analytics.logEvent(
      name: paymentMethod + '_purchase',
      parameters: <String, dynamic>{
        'amount': amount,
        'userID': userId,
        'email': email,
        'method': paymentMethod,
      },
    );
  }

  Future<void> logSignUp(String method) async
  {
    await analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logLogIn(String method) async
  {
    await analytics.logLogin(loginMethod:method);
  }

  Future<void> logPaytmPurchase(String amount, String userId, String email) async {
    await analytics.logEcommercePurchase(
      currency: "INR",
      value: double.parse(amount),
      transactionId: email,
    );
    await analytics.logEvent(
      name: 'paytm_purchase',
      parameters: <String, dynamic>{
        'amount': amount,
        'userID': userId,
        'email': email,
      },
    );
  }
}
