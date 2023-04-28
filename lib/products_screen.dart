import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/helpers/constant.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Products'),
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
                children: const [
                  CustomText(
                    text: 'Products',
                    weight: FontWeight.bold,
                    size: 23,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CustomText(
                          text: 'No products',
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
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: data['imagePath'] != ''
                                    ? NetworkImage(data['imagePath'])
                                    : const NetworkImage(
                                        'https://cdn.pixabay.com/photo/2021/10/11/23/49/app-6702045_1280.png'),
                              ),
                              title: CustomText(text: data['name']),
                              trailing: const Icon(
                                  Icons.shopping_cart_checkout_rounded));
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
}
