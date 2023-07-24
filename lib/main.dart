import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:testecommerce/category_screen.dart';
import 'package:testecommerce/company_screen.dart';
import 'package:testecommerce/productlist_screen.dart';


void main() {
  runApp(const MyApp());
}
Logger logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "star",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => productScreen(),));
              },
              child: Container(
                height: 200,
                color: Colors.blue,
                child: const Center(child: Text("Product",style: TextStyle(color: Colors.white,fontSize: 18),)),

              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(),));
              },
              child: Container(
                height: 200,
                color: Colors.blue,
                child: const Center(child: Text("Category",style: TextStyle(color: Colors.white,fontSize: 18),)),

              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  CompanyScreen(),));
              },
              child: Container(
                height: 200,
                color: Colors.blue,
                child: const Center(child: Text("Company",style: TextStyle(color: Colors.white,fontSize: 18),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
