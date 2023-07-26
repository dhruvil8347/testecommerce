import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testecommerce/common/textfiled.dart';
import 'main.dart';
import 'model/category_model.dart';
import 'model/company_model.dart';
import 'model/product_model.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key, required this.productListModel})
      : super(key: key);

  final productModel productListModel;

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  TextEditingController productnameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController qtyCtrl = TextEditingController();
  int? companyvalue;
  int? categoryvalue;
  List<Company> companyList = [];
  List<Category> categoryList = [];
  List<String> selectedImages = [];
  List<productModel> productlist = [];
  bool isLoding = false;

  final ImagePicker picker = ImagePicker();
  String imageUrl =
      "https://testecommerce.equitysofttechnologies.com/uploads/product_img/";
  productModel productmodel = productModel();
  bool isEdit = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.productListModel.id > 0) {
      productnameCtrl.text = widget.productListModel.productName;
      descriptionCtrl.text = widget.productListModel.description;
      priceCtrl.text = widget.productListModel.price.toString();
      qtyCtrl.text = widget.productListModel.qty.toString();
      companyvalue = widget.productListModel.companyId;
      categoryvalue = widget.productListModel.categoryId;
      selectedImages =
          widget.productListModel.productImg.map((e) => e.productImgg).toList();
      isEdit = true;
    }
    getcompany();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                AppTextfiled(
                  validator: (value) {
                    if(value == null || value.trim().isEmpty)
                    {
                      return "Required";
                    }
                    return null;
                  },
                  controller: productnameCtrl,
                  obscureText: false,
                  label: "Product Name",
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 325,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 1.2),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<int>(
                        validator: (value)
                        {
                          if(value == null ){
                            return "Required";
                          }
                          return null;
                        },
                        value: companyvalue,
                        borderRadius: BorderRadius.circular(10),
                        hint: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Company"),
                        ),
                        items: companyList.map((e) {
                          return DropdownMenuItem<int>(

                              value: e.id, child: Text(e.companyName));
                        }).toList(),
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            companyvalue = value;
                          });
                        }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 325,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0.0, 0.0),
                        color: Colors.black,
                        blurRadius: 1.2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<int>(
                      validator: (value)
                      {
                         if(value == null ){
                           return "Required";
                         }
                         return null;
                      },
                        value: categoryvalue,
                        borderRadius: BorderRadius.circular(10),
                        hint: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Category"),
                        ),
                        items: categoryList.map((e) {
                          return DropdownMenuItem(
                              value: e.id, child: Text(e.categoryName));
                        }).toList(),
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            categoryvalue = value;
                          });
                        }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextfiled(
                  validator: (value)
                  {
                    if(value == null || value.trim().isEmpty)
                    {
                      return 'Required';
                    }
                    return null;

                  },
                    controller: descriptionCtrl,
                    maxLines: 5,
                    obscureText: false,
                    label: "Description"),
                AppTextfiled(
                    validator: (value)
                    {
                      if(value == null || value.trim().isEmpty)
                      {
                        return 'Required';
                      }
                      return null;

                    },
                    keyboardType: TextInputType.number,
                    input: [FilteringTextInputFormatter.digitsOnly  ],
                    controller: priceCtrl,
                    obscureText: false,
                    label: "Price"),
                AppTextfiled(
                    validator: (value)
                    {
                      if(value == null || value.trim().isEmpty)
                      {
                        return 'Required';
                      }
                      return null;

                    },

                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    input: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: false,
                    label: "Qty"),
                const Padding(
                  padding: EdgeInsets.only(top: 10, right: 225, bottom: 10),
                  child: Text("Upload Image:"),
                ),
                GestureDetector(
                  onTap: () {
                    getImages();
                  },
                  child: Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.2,
                              color: Colors.grey,
                              blurStyle: BlurStyle.outer),
                        ]),
                    child: const Icon(Icons.add),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 145,
                        height: 120,
                        child: selectedImages.isEmpty
                            ? const Center(
                                child: Text(
                                "Image not found",
                                style: TextStyle(color: Colors.red),
                              ))
                            : GridView.builder(
                                itemCount: selectedImages.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 1.2,
                                            color: Colors.grey,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                    ),
                                    child: !selectedImages[index]
                                            .contains("data/user")
                                        ?
                                            Stack(
                                              children: [
                                                Center(
                                                  child: Image.network(
                                                      imageUrl + selectedImages[index],
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: (){


                                                   /* List<String> remove = selectedImages.where((element) => element.contains("data/user")).toList();*/
                                                    },
                                                    child: Icon(Icons.close,color: Colors.red,)),
                                              ],
                                            )
                                        : Image.file(
                                            File(selectedImages[index]),
                                            fit: BoxFit.cover,
                                          ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(fixedSize: const Size(350, 40)),
                    onPressed: () async {
                      print('UPDATE:::::::::::${widget.productListModel.id}');
                      /*   widget.productListModel.id > 0 & productmodel.id == 0
                            ? addProduct()
                            : editProduct(productModel(
                                id: widget.productListModel.id,
                                productName: productnameCtrl.text,
                                description: descriptionCtrl.text,
                                price: double.parse(priceCtrl.text),
                                qty: int.parse(qtyCtrl.text),
                                categoryId: categoryValue ?? 0,
                                companyId: companyValue ?? 0,
                              ));*/
                      /*  if (fromkey.currentState!.validate())
                      {

                      }*/
                      if(formkey.currentState!.validate()) {

                        if (widget.productListModel.id > 0) {
                          await editProduct(productModel(
                            id: widget.productListModel.id,
                            productName: productnameCtrl.text,
                            description: descriptionCtrl.text,
                            productImg: widget.productListModel.productImg,
                            price: double.parse(priceCtrl.text),
                            qty: int.parse(qtyCtrl.text),
                            categoryId: categoryvalue ?? 0,
                            companyId: companyvalue ?? 0,

                          )).then((value) => Navigator.of(context).pop());
                        } else if (productmodel.id > 0) {
                          print("your product add successfully");
                          setState(() {
                            getproduct();
                          });
                        } else {
                          await addProduct()
                              .then((value) => Navigator.of(context).pop());
                        }
                      }
                    },
                    child: Text(isEdit ? "Update" : "SAVE")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getcompany() async {
    try {
      Response response = await Dio()
          .get("http://testecommerce.equitysofttechnologies.com/company/get");
      print(response.data);
      companyList = CompanyModel.fromJson(response.data).company;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> editProduct(productModel product) async {
    try {
      Map<String, dynamic> body = {
        'id': product.id,
        'product_name': product.productName,
        'company_id': product.companyId,
        'category_id': product.categoryId,
        'qty': product.qty,
        'description': product.description,
        'price': product.price,
      };
 /*     List<String> removetemp = selectedImages.where((element) => element.contains('data/user')).toList();

      for (int i = 0; i < removetemp.length; i++) {
        body.addAll({
          'product_img_remove[$i]': await MultipartFile.fromFile(
            removetemp[i],
            filename: "${DateTime.now().toIso8601String()}.jpg",
          )
        }
        );
      }
*/



      logger.d(selectedImages);
      List<String> temp = selectedImages.where((element) => element.contains('data/user')).toList();
      logger.wtf(temp);
      for (int i = 0; i < temp.length; i++) {
        body.addAll({
          'product_img[$i]': await MultipartFile.fromFile(
            temp[i],
            filename: "${DateTime.now().toIso8601String()}.jpg",
          )
        });
      }
      print(":::::::::::::::::::::::::::::");
      var respose = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/product/update",
          data: FormData.fromMap(body));
      setState(() {});
      print(respose.data);
    } catch (e) {
      if(e is DioException){
        print(e.response);
      }else{
        print(e);
      }

    }
  }

  Future<void> addProduct() async {
    try {
      Map<String, dynamic> body = {
        'product_name': productnameCtrl.text,
        'description': descriptionCtrl.text,
        'price': priceCtrl.text,
        'qty': qtyCtrl.text,
        'category_id': categoryvalue,
        'company_id': companyvalue,
      };
      for (int i = 0; i < selectedImages.length; i++) {
        body.addAll({
          'product_img[$i]': await MultipartFile.fromFile(
            selectedImages[i],
            filename: selectedImages[i].split("/").last,
          )
        });
      }
      /*  Map<String, dynamic> img =
     {
      'product_img' : mulitiselectedImages,
     };*/
      FormData data = FormData.fromMap(body);
      Response response = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/product/add",
          data: data);
      print(response);
      setState(() {
        getproduct();
      });
    } catch (e) {
      print(e);
      if (e is DioException) {
        print(e.response);
      }
    }
  }

  void getCategory() async {
    try {
      Response response = await Dio()
          .get("http://testecommerce.equitysofttechnologies.com/category/get");
      print(response.data);
      categoryList = CategoryModel.fromJson(response.data).category;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            logger.w(xfilePick[i].path);
            selectedImages.add(xfilePick[i].path);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Nothing is selected!',
            style: TextStyle(
              color: Colors.red,
            ),
          )));
        }
      },
    );
  }

  void getproduct() async {
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
}
///all time mixx