import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/helpers/constant.dart';
import 'package:farm_admin/widgets/custom_modal_progress_hud.dart';
import 'package:farm_admin/widgets/custom_round_button.dart';
import 'package:farm_admin/widgets/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'helpers/utils.dart';

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  ImagePicker picker = ImagePicker();
  TextEditingController linkController = TextEditingController();
  bool isLoading = false;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  String imagePath = '';

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        shadowColor: purple,
        title: const Text('Add Banner'),
      ),
      body: SafeArea(
          child: CustomModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => pickImageFromGallery(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 7,
                    decoration: BoxDecoration(
                        color: grey.withOpacity(0.2),
                        border: Border.all(
                            width: 2, color: Colors.grey.withOpacity(0.2)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.0),
                        child: imagePath.isNotEmpty
                            ? Image.file(
                                File(imagePath),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.image,
                                size: 35,
                                color: grey.withOpacity(1),
                              )),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                  hint: 'Link', label: 'Link', controller: linkController),
              const SizedBox(
                height: 50,
              ),
              CRoundButton(
                function: () => imagePath.isNotEmpty
                    ? addBanner()
                    : showSnackBar('Please select image', context),
                text: 'Upload',
                height: 50,
                width: 300,
                fontSize: 22,
              )
            ],
          ),
        ),
      )),
    );
  }

  addBanner() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentReference ref = await instance
          .collection('admin')
          .doc('admin')
          .collection('banners')
          .add({
        'url': linkController.text.trim(),
        'imagePath': '',
        'time': DateTime.now(),
      });

      String userPhotoPath = "user_photos/banners/${ref.id}";

      await storage
          .ref(userPhotoPath)
          .putFile(File(imagePath))
          .then((p0) => print('Done'))
          .onError((error, stackTrace) {
        print(error.toString());
      });
      print('image uploaded');
      String downloadUrl = await storage.ref(userPhotoPath).getDownloadURL();

      await ref.update({'imagePath': downloadUrl, 'id': ref.id}).then((value) {
        setState(() {
          isLoading = false;
        });
        linkController.clear();
        print('Update done.');
        showSnackBar('Banner Uploaded', context);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
