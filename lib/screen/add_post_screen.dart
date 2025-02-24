import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/screen/addpost_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<File> path = [];
  List<AssetEntity> media = [];
  File? _file;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  Future<void> _fetchNewMedia() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
      await PhotoManager.getAssetPathList(type: RequestType.image);
      media = await album[0].getAssetListPaged(page: 0, size: 60);

      for (var asset in media) {
        final file = await asset.file;
        if (file != null) {
          path.add(File(file.path));
        }
      }

      if (path.isNotEmpty) {
        setState(() {
          _file = path[0];
          selectedIndex = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  if (_file != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPostTextScreen(_file!),
                    ));
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: media.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loader while fetching
            : GridView.builder(
          shrinkWrap: true,
          itemCount: media.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  _file = path[index];
                });
              },
              child: Stack(
                children: [
                  FutureBuilder<Uint8List?>(
                    future: media[index].thumbnailDataWithSize(ThumbnailSize(200, 200)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Positioned.fill(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(color: Colors.grey[300]);
                    },
                  ),
                  if (selectedIndex == index) // Show checkmark on selected image
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}