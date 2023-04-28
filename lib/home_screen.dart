import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/categories_screen.dart';
import 'package:farm_admin/helpers/constant.dart';
import 'package:farm_admin/helpers/screen_navigation.dart';
import 'package:farm_admin/products_screen.dart';
import 'package:farm_admin/users_screen.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Farm Sharing Admin'),
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
              ListTile(
                onTap: () => changeScreen(context, const UsersScreen()),
                title: const CustomText(
                    text: 'Users', weight: FontWeight.bold, size: 20),
                trailing: GestureDetector(
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      weight: 40, size: 20),
                ),
              ),
              ListTile(
                onTap: () => changeScreen(context, const ProductsScreen()),
                title: const CustomText(
                    text: 'Products', weight: FontWeight.bold, size: 20),
                trailing: GestureDetector(
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      weight: 40, size: 20),
                ),
              ),
              ListTile(
                onTap: () => changeScreen(context, const CategoriesScreen()),
                title: const CustomText(
                  text: 'Categories',
                  weight: FontWeight.bold,
                  size: 20,
                ),
                trailing: GestureDetector(
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    weight: 40,
                    size: 23,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
