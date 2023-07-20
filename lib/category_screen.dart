import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController categoryCtrl = TextEditingController();
  Category categoryModel = Category();
  List<Category> categoryList = [];
  bool isLoding = false;
  final fromkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 78),
          child: Text("Category"),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: fromkey,
              child: TextFormField(
                controller: categoryCtrl,
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return "Required Categoryname";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text("Category"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onLongPress: (){
              print("null");
            },
              onPressed: () {
                if (fromkey.currentState!.validate()) {
                  categoryModel.categoryName = categoryCtrl.text.trim();
                  if (categoryModel.id != 0) {
                    categoryCtrl.clear();
                    editCategory(categoryModel);
                  } else {
                    addCategory();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(330, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("ADD")),
          const SizedBox(
            height: 10,
          ),
          /*ElevatedButton(
              onPressed: () {
                companyModel.companyName = nameCtrl.text.trim();
                if (companyModel.id > 0) {

                  editcompany(companyModel);
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(330, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text("UPDATE")),*/
          const Padding(
            padding: EdgeInsets.only(top: 25, right: 220),
            child: Text("List of companies"),
          ),
          Expanded(
            child: isLoding
                ? Lottie.asset("assets/lottie/a.json")
                : ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      print("data->${categoryList[index].categoryName}");
                      return ListTile(
                        title: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  categoryList[index].categoryName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        categoryModel = Category(
                                          id: categoryList[index].id,
                                          categoryName:
                                              categoryList[index].categoryName,
                                        );
                                        categoryCtrl.text =
                                            categoryList[index].categoryName;
                                        categoryModel.index = index;
                                      },
                                      child: Icon(Icons.edit,
                                          color: Colors.white)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          showDialog(context: context, builder: (context) {
                                            return AlertDialog(
                                              title: Text("Delete"),
                                              content: Text("Are you sure you want to delete?"),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                }, child: Text("Cancel")),
                                                TextButton(onPressed: (){
                                                  deleteCategory(
                                                      categoryList[index].id);
                                                  Navigator.of(context).pop();
                                                }, child: Text("Delete")),
                                              ],
                                            );
                                          },)

                                          ;
                                        },
                                        child: Icon(Icons.delete,
                                            color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void deleteCategory(int id) async {
    try {
      isLoding = false;
      Map<String, dynamic> body = {'id': id};
      var response = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/category/delete",
          data: body);
      print(response.data);
      /*   setState(() {
        comapanyList.removeAt(1);
      });*/
      setState(() {
        getCategory();
      });
      setState(() {
        isLoding = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void editCategory(Category category) async {
    try {
      Map<String, dynamic> body = {
        'id': category.id,
        'category_name': category.categoryName
      };
      print(body);
      var response = await Dio().post(
        "http://testecommerce.equitysofttechnologies.com/category/update",
        data: body,
      );
      if (response.data['s'] == 1) {
        setState(() {
          categoryList[category.index] = category;
        });
        categoryModel = Category();
      } else {
        throw response.data['m'];
      }
    } catch (e) {
      print(e);
    }
  }

  void addCategory() async {
    try {
      isLoding = true;
      Map<String, dynamic> body = {'category_name': categoryCtrl.text.trim()};
      var response = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/category/add",
          data: body);
      setState(() {
        getCategory();
      });
      setState(() {
        isLoding = false;
      });
      print("dfdff--->${response.data}");
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  void getCategory() async {
    try {
      isLoding = true;
      var response = await Dio()
          .get("http://testecommerce.equitysofttechnologies.com/category/get");
      print(response.data);
      categoryList = CategoryModel.fromJson(response.data).category;
      setState(() {
        isLoding = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
