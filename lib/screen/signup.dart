import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/data/firebase_service/firebase_auth.dart';
import 'package:flutter_instagram_clone/util/dialog.dart';
import 'package:flutter_instagram_clone/util/exeption.dart';
import 'package:flutter_instagram_clone/util/imagepicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  File? _imageFile;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordConfirme.dispose();
    username.dispose();
    bio.dispose();
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
              SizedBox(width: 96.w, height: 10.h),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Keeps the column compact
                  children: [
                    Text(
                      'SOCIAL APP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4), // Adds spacing between the texts
                    Text(
                      '- by Pradeep',
                      style: TextStyle(
                        color: Colors.black54, // Slightly lighter color for contrast
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 90.w, height: 70.h),
              InkWell(
                  onTap: () async {
                    File _imagefilee = await ImagePickerr().uploadImage('gallery');
                    setState(() {
                      _imageFile = _imagefilee;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 44.r,
                        backgroundColor: Colors.grey,
                        child: _imageFile == null
                            ? CircleAvatar(
                          radius: 44.r,
                          backgroundImage: AssetImage('images/person.png'),
                          backgroundColor: Colors.grey.shade200,
                        )
                            : CircleAvatar(
                          radius: 44.r,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 40.h),
              Textfild(email, email_F, 'Email', Icons.email),
              SizedBox(height: 15.h),
              Textfild(username, username_F, 'Username', Icons.person),
              SizedBox(height: 15.h),
              Textfild(bio, bio_F, 'Address', Icons.abc),
              SizedBox(height: 15.h),
              Textfild(password, password_F, 'Password', Icons.lock),
              SizedBox(height: 15.h),
              Textfild(passwordConfirme, passwordConfirme_F, 'Confirm Password', Icons.lock),
              SizedBox(height: 15.h),
              SignupButton(),
              SizedBox(height: 15.h),
              HaveAccountText()
            ],
          ),
        ),
      ),
    );
  }

  Widget SignupButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          if (_imageFile == null) {
            dialogBuilder(context, "Please select an image first.");
            return;
          }
          if (email.text.isEmpty) {
            dialogBuilder(context, "Please enter your email.");
            return;
          }
          if (username.text.isEmpty) {
            dialogBuilder(context, "Please enter a username.");
            return;
          }
          if (password.text.isEmpty || passwordConfirme.text.isEmpty) {
            dialogBuilder(context, "Please enter and confirm your password.");
            return;
          }
          if (password.text != passwordConfirme.text) {
            dialogBuilder(context, "Passwords do not match.");
            return;
          }

          try {
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirme: passwordConfirme.text,
              username: username.text,
              bio: bio.text,
              profile: _imageFile!,
            );
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
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
            'Sign up',
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

  Widget HaveAccountText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Already have an account?  ",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login ",
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

  Padding Textfild(TextEditingController controll, FocusNode focusNode,
      String typename, IconData icon) {
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
          controller: controll,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: typename,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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