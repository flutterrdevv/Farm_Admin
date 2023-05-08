import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/add_banner_screen.dart';
import 'package:farm_admin/helpers/constant.dart';
import 'package:farm_admin/helpers/screen_navigation.dart';
import 'package:farm_admin/widgets/custom_modal_progress_hud.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners'),
        backgroundColor: purple,
        shadowColor: purple,
      ),
      body: SafeArea(
          child: CustomModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Add banner',
                    weight: FontWeight.bold,
                    size: 25,
                  ),
                  GestureDetector(
                    onTap: () => changeScreen(context, const AddBannerScreen()),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Long press on banner to delete the banner',
                  color: grey,
                  size: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('admin')
                      .doc('admin')
                      .collection('banners')
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
                        shrinkWrap: true,
                        itemCount: item.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = item[index];
                          return data['imagePath'] != ''
                              ? GestureDetector(
                                  onLongPress: () => delete(data.id, context),
                                  child: CachedNetworkImage(
                                    imageUrl: data['imagePath'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              7,
                                      decoration: BoxDecoration(
                                        color: grey,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : null;
                        });
                  }),
            ],
          ),
        ),
      )),
    );
  }

  delete(id, context) async {
    setState(() {
      isLoading = true;
    });
    final FirebaseFirestore instance = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;

    await instance
        .collection('admin')
        .doc('admin')
        .collection('banners')
        .doc(id)
        .delete();
    Reference ref = storage.ref().child("user_photos/banners/$id");
    await ref.delete().then((value) {
      print('item deleted');
      setState(() {
        isLoading = false;
      });
    });
  }
}
