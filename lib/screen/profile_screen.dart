import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/data/firebase_service/firestor.dart';
import 'package:flutter_instagram_clone/data/model/usermodel.dart';
import 'package:flutter_instagram_clone/screen/post_screen.dart';
import 'package:flutter_instagram_clone/util/image_cached.dart';
import 'package:flutter_instagram_clone/widgets/post_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;
  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  bool yourse = false;
  List following = [];
  bool follow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    if (widget.Uid == _auth.currentUser!.uid) {
      setState(() {
        yourse = true;
      });
    }
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    following = (snap.data()! as dynamic)['following'];
    if (following.contains(widget.Uid)) {
      setState(() {
        follow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: Firebase_Firestor().getUser(UID: widget.Uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Head(snapshot.data!);
                  },
                ),
              ),
              StreamBuilder(
                stream: _firebaseFirestore
                    .collection('posts')
                    .where('uid', isEqualTo: widget.Uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }
                  post_lenght = snapshot.data!.docs.length;
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostScreen(snap.data())));
                        },
                        child: CachedImage(
                          snap['postImage'],
                        ),
                      );
                    }, childCount: post_lenght),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Head(Usermodel user) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: CachedImage(user.profile),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Text(
                          "Address: " ,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 35.w),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 53.w),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 25.w),

                    ],
                  ),
                ],
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: GestureDetector(
              onTap: () {
                if (!yourse) {
                  Firebase_Firestor().flollow(uid: widget.Uid);
                  setState(() {
                    follow = true;
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 30.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Always white for "Edit Your Profile"
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.grey.shade400), // Grey border
                ),
                child: Text(
                  'Edit Your Profile',
                  style: TextStyle(color: Colors.black), // Adjust text color if needed
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
