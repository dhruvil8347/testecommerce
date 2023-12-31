import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testecommerce/addproduct_screen.dart';
import 'details_screen.dart';
import 'model/company_model.dart';
import 'model/product_model.dart';

class productScreen extends StatefulWidget {
  const productScreen({Key? key}) : super(key: key);

  @override
  State<productScreen> createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {
  List<productModel> productlist = [];
  List<ProductImg> productimg = [];
  List<Company> comapanyList = [];
  List<String> selectedImages = [];
  bool isLoding = false;

  productModel product = productModel();
  String imageUrl =
      "https://testecommerce.equitysofttechnologies.com/uploads/product_img/";

  @override
  void initState() {
    super.initState();
    setState(() {
      getproduct();
    });
  }

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Product")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Addproduct(productListModel: productModel()),
                      )).then((value) {
                    print("REFRESH => ");
                    getproduct();
                  });
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: productlist.isEmpty
                  ? Image.asset("assets/images/data.png")
                  : isLoding
                      ? Lottie.asset("assets/lottie/a.json")
                      : ListView.builder(
                          itemCount: productlist.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GetProduct(
                                          productListModel: productlist[index]
                                      ),
                                    )).then((value) {
                                  getproduct();
                                });
                              },
                              child: Container(
                                height: 130,
                                width: 330,
                                child: Card(
                                  elevation: 5,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image.network(imageUrl +
                                            productlist[index]
                                                .productImg
                                                .first
                                                .productImgg),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 10),
                                        child: Container(
                                          width: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  productlist[index]
                                                      .productName
                                                      .trim(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  )),
                                              Text(
                                                  " ${productlist[index].categoryName}",
                                                  style: const TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.grey)),
                                              Text(
                                                "Qty: 0${productlist[index].qty.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                /*  String refresh = await*/ Navigator
                                                    .push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Addproduct(
                                                            productListModel:
                                                                productlist[
                                                                    index],
                                                          ),
                                                        )).then((value) {
                                                  getproduct();
                                                });

                                                /* if(refresh == "refresh"){
                                              getproduct();
                                            }*/
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(80, 30)),
                                              child: const Text("Edit")),
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                      content: const Text(
                                                          "Are you sure if you wnat to Delete?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "Cancel")),
                                                        TextButton(
                                                            onPressed: () {
                                                              deleteProduct(
                                                                  productlist[
                                                                          index]
                                                                      .id);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            )),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(80, 30)),
                                              child: const Text("Delete")),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getproduct() async {
    try {
      isLoding = true;
      Response response = await Dio()
          .get("https://testecommerce.equitysofttechnologies.com/product/get");
      print(response.data);
      productlist = List<productModel>.from(
          response.data['r'].map((e) => productModel.fromJson(e)));
      /*productimg = List<ProductImg>.from(response.data.map((e)=> ProductImg.fromJson(e)));*/

      /*  setState(() {
         getproduct();
      });
*/
      setState(() {
        isLoding = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void editProduct(productModel product) async {
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
     /*      print(selectedImages);
      for (int i = 0; i < selectedImages.length; i++) {
        body.addAll({
          'product_img[$i]': await MultipartFile.fromFile(
            selectedImages[i],
            filename: "${DateTime.now().toIso8601String()}.jpg",
          )
        });
      }*/
      Response respose = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/product/update",
          data: body);
      print(respose.data);
      setState(() {
        getproduct();
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteProduct(int id) async {
    try {
      isLoding = false;
      Map<String, dynamic> body = {'id': id};
      var response = await Dio().post(
          "https://testecommerce.equitysofttechnologies.com/product/delete",
          data: body);
      print(response.data);
      setState(() {
        getproduct();
      });
      setState(() {
        isLoding = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
