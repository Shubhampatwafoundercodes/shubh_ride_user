import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardlistener.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardwidget.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfupi/cfupiutils.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/payment_section/%20data/repo_impl/create_paying_repo_impl.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

/// -------------------- ENUM + STATE --------------------

enum PaymentStatus { idle, loading, success, failed }

class PaymentState {
  final PaymentStatus status;
  final String? message;
  final String? orderId;
  final String? paymentSessionId;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.message,
    this.orderId,
    this.paymentSessionId,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? message,
    String? orderId,
    String? paymentSessionId,
  }) {
    return PaymentState(
      status: status ?? this.status,
      message: message ?? this.message,
      orderId: orderId ?? this.orderId,
      paymentSessionId: paymentSessionId ?? this.paymentSessionId,
    );
  }
}


/// -------------------- PROVIDER --------------------

final paymentProvider =
StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref);
});

/// -------------------- PAYMENT NOTIFIER --------------------

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref ref;
  PaymentNotifier(this.ref) : super(const PaymentState());

  final cfPaymentGatewayService = CFPaymentGatewayService();
  final CFEnvironment environment = CFEnvironment.SANDBOX;

  String selectedUpiId = "";
  CFCardWidget? cfCardWidget;

  /// 🔥 Main function to handle full payment flow
  Future<void> startPayment(double amount) async {
    try {
      toastMsg("🚀 Creating payment session...");
      state = state.copyWith(status: PaymentStatus.loading);

      // 🧩 Step 1: Create session from backend
      final userId = ref.read(userProvider.notifier).userId;
      final repo = ref.read(createPayingRepoProvider);

      final response = await repo.createPayingSession(userId.toString(), amount);
      debugPrint("✅ Backend response: $response");

      if (response["code"] != 200 || response["data"] == null) {
        throw Exception(response["msg"] ?? "Failed to create payment session");
      }
      final data = response["data"];
      final orderId = data["orderId"];
      final sessionId = data["sessionId"];
      final amountStr = data["amount"].toString();

      // ✅ Step 2: Save in state
      state = state.copyWith(
        status: PaymentStatus.idle,
        orderId: orderId,
        paymentSessionId: sessionId,
      );

      toastMsg("✅ Payment session created successfully");

      // 🧠 Step 3: Init Cashfree & Start checkout
      _initCashfree(sessionId, orderId, amountStr);

    } catch (e, st) {
      debugPrint("❌ startPayment error: $e\n$st");
      toastMsg("❌ Payment setup failed: $e");
      state = state.copyWith(
        status: PaymentStatus.failed,
        message: e.toString(),
      );
    }
  }

  /// 🧩 Cashfree Setup
  void _initCashfree(String sessionId, String orderId, String amount) async {
    try {
      cfPaymentGatewayService.setCallback(_onPaymentSuccess, _onPaymentError);

      final session = _createSession(sessionId, orderId);
      if (session == null) {
        toastMsg("❌ Session creation failed");
        return;
      }

      // Optionally load UPI apps
      CFUPIUtils().getUPIApps().then((value) {
        for (var i = 0; i < (value?.length ?? 0); i++) {
          var a = value?[i]["id"] as String;
          if (a.contains("cashfree")) {
            selectedUpiId = value?[i]["id"];
          }
        }
      }).catchError((e) {
        debugPrint("Error fetching UPI apps: $e");
      });

      toastMsg("💳 Launching Cashfree Web Checkout...");

      final payment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      cfPaymentGatewayService.doPayment(payment);

      state = state.copyWith(status: PaymentStatus.loading);
    } catch (e) {
      debugPrint("CFException during init: $e");
      toastMsg("❌ Cashfree init failed: $e");
    }
  }

  /// Create Cashfree session
  CFSession? _createSession(String sessionId, String orderId) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint("CFException createSession: ${e.message}");
    }
    return null;
  }

  /// ✅ Payment Success callback
  void _onPaymentSuccess(String orderId) {
    debugPrint("✅ Payment success for orderId: $orderId");
    toastMsg("🎉 Payment Successful for Order: $orderId");
    state = state.copyWith(
      status: PaymentStatus.success,
      message: "Payment Successful!",
    );

    // 🪙 Optional: Call API to credit wallet here
    // ref.read(walletRepoProvider).addMoney(orderId, state.paymentSessionId!, "SUCCESS");
  }

  /// ❌ Payment Error callback
  void _onPaymentError(CFErrorResponse errorResponse, String orderId) {
    final msg = errorResponse.getMessage();
    debugPrint("❌ Payment failed: $msg");
    toastMsg("❌ Payment failed: $msg");
    state = state.copyWith(
      status: PaymentStatus.failed,
      message: msg,
    );
  }

  /// Optional card listener (if you use card widget)
  void cardListener(CFCardListener listener) {
    debugPrint("Card listener event: ${listener.getType()}");
  }
}
