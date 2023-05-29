import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/add_category_screen.dart';
import 'package:farm_admin/helpers/constant.dart';
import 'package:farm_admin/helpers/screen_navigation.dart';
import 'package:farm_admin/helpers/utils.dart';
import 'package:farm_admin/sub_categories_screen.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Categories'),
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
                    text: 'Categories',
                    weight: FontWeight.bold,
                    size: 23,
                  ),
                  GestureDetector(
                    onTap: () => changeScreen(context, AddCategory()),
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .doc('admin')
                        .collection('categories')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CustomText(
                          text: 'No Categories',
                          color: grey,
                          size: 20,
                        ));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: grey,
                          ),
                        );
                      }
                      var item = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: item.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = item[index];
                          return ListTile(
                            onTap: () => changeScreen(
                                context,
                                SubCategoriesScreen(
                                  subCategories: data['sub'],
                                  id: data.id,
                                )),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: white,
                              backgroundImage: data['imagePath'] != ''
                                  ? NetworkImage(data['imagePath'])
                                  : const NetworkImage(
                                      'https://cdn.pixabay.com/photo/2021/10/11/23/49/app-6702045_1280.png'),
                            ),
                            title: CustomText(text: data['name']),
                            trailing: GestureDetector(
                              onTap: () => removeCategory(
                                  data.id, data['name'].toString().trim()),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.withOpacity(0.8),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }

  removeCategory(id, name) {
    print(name);
    Reference ref = storage.ref().child("user_photos/categories/$name");
    instance
        .collection('admin')
        .doc('admin')
        .collection('categories')
        .doc(id)
        .delete()
        .then((value) {
      name != ''
          ? ref.delete().then(
                (value) => showSnackBar('item removed', context),
              )
          : showSnackBar('item removed', context);
    });
  }
}
