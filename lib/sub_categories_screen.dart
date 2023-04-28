import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/helpers/screen_navigation.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'add_sub_category_screen.dart';
import 'helpers/constant.dart';
import 'helpers/utils.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen(
      {super.key, required this.subCategories, required this.id});
  final List subCategories;
  final String id;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Sub Categories'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Sub Categories',
                    weight: FontWeight.bold,
                    size: 23,
                  ),
                  GestureDetector(
                    onTap: () => changeScreen(
                        context,
                        AddSubCategory(
                          subcategories: widget.subCategories,
                          id: widget.id,
                          callback: (val, index, fun) {
                            if (fun == Fun.add) {
                              setState(() {
                                widget.subCategories.add(val);
                              });
                              print(widget.subCategories);
                            } else if (fun == Fun.remove) {
                              setState(() {
                                widget.subCategories.removeAt(index);
                              });
                              print(widget.subCategories);
                            }
                          },
                        )),
                    child: const Icon(
                      Icons.add,
                      size: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: ListView.builder(
                    itemCount: widget.subCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        // leading: CircleAvatar(
                        //   radius: 20,
                        //   backgroundImage: data['imagePath'] != ''
                        //       ? NetworkImage(data['imagePath'])
                        //       : const NetworkImage(
                        //           'https://cdn.pixabay.com/photo/2021/10/11/23/49/app-6702045_1280.png'),
                        // ),
                        title: CustomText(text: widget.subCategories[index]),
                        trailing: GestureDetector(
                          onTap: () => removeSubCategory(index),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      )),
    );
  }

  removeSubCategory(index) {
    setState(() {
      widget.subCategories.removeAt(index);
    });
    instance
        .collection('admin')
        .doc('admin')
        .collection('categories')
        .doc(widget.id)
        .update({'sub': widget.subCategories}).then((value) {
      showSnackBar('sub category removed', context);
    });
  }
}
