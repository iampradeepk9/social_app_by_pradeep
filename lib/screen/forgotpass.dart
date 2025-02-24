import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (emailController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset link sent to ${emailController.text}")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SOCIAL APP',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '- by Pradeep',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: emailController,
                focusNode: emailFocusNode,
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: emailFocusNode.hasFocus ? Colors.black : Colors.grey[600],
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
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: InkWell(
                onTap: resetPassword,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}