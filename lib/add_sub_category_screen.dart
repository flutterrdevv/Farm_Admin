import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_admin/widgets/custom_modal_progress_hud.dart';
import 'package:farm_admin/widgets/custom_round_button.dart';
import 'package:farm_admin/widgets/custom_text.dart';
import 'package:farm_admin/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'helpers/constant.dart';
import 'helpers/utils.dart';

class AddSubCategory extends StatefulWidget {
  const AddSubCategory(
      {super.key,
      required this.subcategories,
      required this.id,
      required this.callback});
  final List subcategories;
  final String id;
  final Function(String val, int index, Fun fun) callback;

  @override
  State<AddSubCategory> createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  TextEditingController subCategoryController = TextEditingController();
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  bool isLoading = false;
  bool flag = false;
  @override
  void initState() {
    print(widget.subcategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Add Sub Categories'),
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
                            subCategoryController.text != ''
                                ? setState(() {
                                    flag = true;

                                    widget.callback(
                                        subCategoryController.text.trim(),
                                        1,
                                        Fun.add);
                                  })
                                : null;
                            subCategoryController.clear();
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
                      itemCount: widget.subcategories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: widget.subcategories[index],
                                color: black,
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  widget.callback('', index, Fun.remove);
                                }),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.withOpacity(0.8),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                CRoundButton(
                  function: () {
                    flag ? addSubCategory() : null;
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

  addSubCategory() async {
    setState(() {
      isLoading = true;
    });
    try {
      await instance
          .collection('admin')
          .doc('admin')
          .collection('categories')
          .doc(widget.id)
          .update({'sub': widget.subcategories}).then((value) {
        showSnackBar('Sub Categories Added', context);
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

enum Fun { add, remove }
