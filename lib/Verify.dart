/*import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_me/email_Auth.dart';

class Verify extends StatefulWidget 
{
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> 
{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

void sendOTP()async{
  EmailAuth.sessionName = "Test";
  var res = await EmailAuth.sendOtp(recipientMail: _emailController.text );
  if (res)
  {
    print("OTP Sent");


  }
  else{
    print("We could not sent");
  }
}
void verifyOTP()
{
  var res = EmailAuth.validateOtp(recieverMail: _emailController.text, userOtp: _otpController.text);
  if (res){
    print("OTP Verified");
  }
  else{
    print("Invalid OTP");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Verify Email"),

      ),
      body: Column(
        children: [Image.asset("assets/logo.png",
        fit: BoxFit.cover,),
        SizedBox(
          height: 20.0,
        ),
        Padding(padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: InputDecoration.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter Email",
                labelText: "Email",
                suffixIcon: TextButton(child: Text("Send OTP"),
                onPressed: ()=> sendOTP(),
                )
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                labelText: "OTP",
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(child: Text("Verify OTP"),
            onPressed: () => verifyOTP(),
            )
          ],),
        ),

        
        
        
        
        ],
        
      ),
    );
  }
}
*/