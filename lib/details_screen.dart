import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/model/product_model.dart';
import 'addproduct_screen.dart';
/*import 'model/product_model.dart';*/

class GetProduct extends StatefulWidget {
  const GetProduct({Key? key, required this.productListModel})
      : super(key: key);

  /*final productModel = product();*/
  final productModel productListModel;

  @override
  State<GetProduct> createState() => _GetProductState();
}

class _GetProductState extends State<GetProduct> {
  String ImageUrl =
      "https://testecommerce.equitysofttechnologies.com/uploads/product_img/";
  List<productModel> productlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CarouselSlider(
              items: widget.productListModel.productImg.map((e) {
                return Builder(
                  builder: (context) {
                    return Image.network(ImageUrl + e.productImgg);
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text("Product:${widget.productListModel.productName}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, height: 3)),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    "Price:${widget.productListModel.price}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, height: 3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 210),
              child: Text(
                widget.productListModel.categoryName,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text(
                    " ${widget.productListModel.companyName}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 3, fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text("QTY: ${widget.productListModel.qty}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, height: 3)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 220, top: 25),
              child: Text("Descripation:",
                  style: TextStyle(height: 1, fontSize: 16)),
            ),
            Text(
                "Lorem Ipsum is simply dummy text sum h theer took ${widget.productListModel.description}"),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addproduct(
                                productListModel: widget.productListModel),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 30)),
                    child: const Text("Edit")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 35)),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete",
                                style: TextStyle(color: Colors.red)),
                            content: Text("Are you sure you want to delete?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    deleteProduct(widget.productListModel.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          );
                        },
                      );

                      Navigator.of(context).pop();
                    },
                    child: const Text("Delete")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteProduct(int id) async {
    try {
      Map<String, dynamic> body = {'id': id};
      var response = await Dio().post(
          "http://testecommerce.equitysofttechnologies.com/product/delete",
          data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
