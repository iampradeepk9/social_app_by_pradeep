import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/data/firebase_service/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'forgotpass.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: 96.w, height: 100.h),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SOCIAL APP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '- by Pradeep',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.h),
              textField(email, email_F, 'Email', Icons.email),
              SizedBox(height: 15.h),
              textField(password, password_F, 'Password', Icons.lock),
              SizedBox(height: 15.h),
              forgetPassword(),
              SizedBox(height: 15.h),
              loginButton(),
              SizedBox(height: 15.h),
              signUpOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpOption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don't have an account?  ",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Sign up",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          if (email.text.isEmpty || password.text.isEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Validation Error'),
                content: Text('Please enter both email and password.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            await Authentication().Login(email: email.text, password: password.text);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding forgetPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 230.w),
      child: GestureDetector(
        onTap: () {
          // Navigate to Forgot Password Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Forgot()),
          );
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Padding textField(TextEditingController controller, FocusNode focusNode,
      String hintText, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}