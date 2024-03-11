/*import 'package:email_auth/email_auth.dart';
import 'package:get/get.dart';

class EmailAuthController extends GetxController {
  EmailAuth emailAuth = EmailAuth(sessionName: "code algo");
  var status = "".obs;
  void sendOtp(String email) async {
    var res = await emailAuth.sendOtp(recipientMail: email, otpLength: 5);
    if (res) {
      status.value = "OTP Sent";
    } else {
      status.value = "Sending OTP Failed";
    }
  }

  void validateOtp(
    String email,
    String otp,
  ) {
    var res = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
    if (res) {
      status.value = "OTP Verified Successfully";
    } else {
      status.value = " Wrong OTP";
    }
  }
}
*/