import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testecommerce/model/product_model.dart';

import 'addproduct_screen.dart';
import 'model/product_model.dart';

class GetProduct extends StatefulWidget {
  const GetProduct({Key? key, required this.productListModel}) : super(key: key);

  /*final productModel = product();*/
  final productModel productListModel;

  @override
  State<GetProduct> createState() => _GetProductState();
}

class _GetProductState extends State<GetProduct> {

  String ImageUrl = "https://testecommerce.equitysofttechnologies.com/uploads/product_img/";
  List<productModel>  productlist = [];

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
                  return Builder(builder: (context) {
                    return Image.network(ImageUrl+e.productImgg);
                  },);
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.productListModel.productName,
                    style: const TextStyle(fontSize: 15, height: 3)),
                Text(
                  "Price: ${widget.productListModel.price}",
                  style: const TextStyle(fontSize: 15, height: 3),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.productListModel.companyName,
                  style: const TextStyle(height: 3, fontSize: 15),
                ),
                Text("QTY ${widget.productListModel.qty}",
                    style: const TextStyle(fontSize: 15, height: 3)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 220, top: 25),
              child: Text("Descripation:",
                  style: TextStyle(height: 1, fontSize: 16)),
            ),
            Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took "
            ),
            SizedBox(
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
                    style: ElevatedButton.styleFrom(fixedSize: Size(120, 35)),
                    onPressed: () {
                      deleteProduct(widget.productListModel.id);
                      Navigator.of(context).pop();
                    },
                    child: Text("Delete")),
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
