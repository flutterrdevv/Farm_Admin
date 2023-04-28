import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/widgets/custom_modal_progress_hud.dart';
import 'package:farm_admin/widgets/custom_round_button.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:farm_admin/widgets/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'helpers/constant.dart';
import 'helpers/utils.dart';

class AddCategory extends StatefulWidget {
  AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController textController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List subcategories = [];
  ImagePicker picker = ImagePicker();
  String? imagePath;
  bool isLoading = false;
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
        title: const Text('Add Categories'),
      ),
      body: CustomModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: const CustomText(
                    text: 'Category',
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                imagePath == null
                    ? GestureDetector(
                        onTap: pickImageFromGallery,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.camera),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: GestureDetector(
                          onTap: pickImageFromGallery,
                          child: Image.file(
                            File(imagePath!),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    hint: 'Category name',
                    label: 'Category Name',
                    controller: textController),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: const CustomText(
                    text: 'Sub Categories',
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 320,
                        child: CustomTextField(
                            hint: 'Sub category name',
                            label: 'Sub category Name',
                            controller: subCategoryController),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              subcategories.add(subCategoryController.text);
                            });
                            subCategoryController.clear();
                            print(subcategories);
                          },
                          child: CircleAvatar(
                            backgroundColor: purple,
                            child: Icon(
                              Icons.add,
                              size: 25,
                              color: white,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ListView.builder(
                      itemCount: subcategories.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: subcategories[index],
                              color: black,
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                subcategories.removeAt(index);
                                print(subcategories);
                              }),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.withOpacity(0.8),
                              ),
                            )
                          ],
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                CRoundButton(
                  function: () {
                    imagePath != null && textController.text.isNotEmpty
                        ? addCategory()
                        : showSnackBar(
                            'Select Image and Add name Please', context);
                  },
                  text: 'Add',
                  color: purple,
                  height: 50,
                  width: 150,
                  fontSize: 18,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  addCategory() async {
    setState(() {
      isLoading = true;
    });
    String imageName = textController.text.trim();
    String userPhotoPath = "user_photos/categories/$imageName";
    try {
      await storage
          .ref(userPhotoPath)
          .putFile(File(imagePath!))
          .then((p0) => print('Done'))
          .onError((error, stackTrace) {
        print(error.toString());
      });
      print('image uploaded');
      String downloadUrl = await storage.ref(userPhotoPath).getDownloadURL();
      await instance
          .collection('admin')
          .doc('admin')
          .collection('categories')
          .add({
        'imagePath': downloadUrl,
        'time': DateTime.now(),
        'name': textController.text.trim(),
        'sub': subcategories
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        showSnackBar('Category Added', context);

        Navigator.pop(context);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
