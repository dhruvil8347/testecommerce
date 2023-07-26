import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'model/category_model.dart';
import 'model/product_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController categoryCtrl = TextEditingController();
  //

  Category categoryModel = Category();
  List<Category> categoryList = [];
  List<productModel> productlist = [];
  bool isLoding = false;
  final fromkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCategory();
    getproduct();
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
      body:
      isLoding
      ? Center(
        child: SizedBox(
            width: 220,
            child: Lottie.asset('assets/lottie/a.json')),
      )
      : Column(
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
                  label: const Text("Category"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onLongPress: () {
                print("null");
              },
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (fromkey.currentState!.validate()) {
                  categoryModel.categoryName = categoryCtrl.text.trim();
                  if (categoryModel.id != 0) {
                    categoryCtrl.clear();
                    editCategory(categoryModel);
                  } else {
                    addCategory();
                    categoryCtrl.clear();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(330, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("ADD")),
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
                              const SizedBox(
                                width: 3,
                              ),

                              SizedBox(
                                width: 230,
                                child: Text(
                                  categoryList[index].categoryName,overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
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
                                      child: const Icon(Icons.edit,
                                          color: Colors.white)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Delete"),
                                                content: const Text(
                                                    "Are you sure you want to delete?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        deleteCategory(
                                                            categoryList[index]
                                                                .id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color: Colors.red),

                                                      )
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(Icons.delete,
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
      List<productModel> dummylist =
          productlist.where((element) => element.categoryId == id).toList();
      for (int i = 0; i < dummylist.length; i++) {
        Map<String, dynamic> body = {'id': dummylist[i].id};
        Dio().post(
            "http://testecommerce.equitysofttechnologies.com/product/delete",
            data: body);
      }
      Map<String, dynamic> body = {'id': id};
      var response = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/category/delete",
          data: body);
      print(response.data);
      /*   setState(() {
        comapanyList.removeAt(1);
      });*/
      await getCategory();
      await getproduct();
      setState(() {
        isLoding = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getproduct() async {
    try {
      isLoding = true;
      var response = await Dio()
          .get("https://testecommerce.equitysofttechnologies.com/product/get");
      print(response.data);
      productlist = List<productModel>.from(
          response.data['r'].map((e) => productModel.fromJson(e)));
      /*productimg = List<ProductImg>.from(response.data.map((e)=> ProductImg.fromJson(e)));*/
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

  Future<void> getCategory() async {
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
