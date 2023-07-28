import 'package:flutter/material.dart';


class Step5 extends StatefulWidget {
  final void Function()? onTab;
  const Step5({Key? key,this.onTab}) : super(key: key);

  @override
  State<Step5> createState() => _Step5State();
}

class _Step5State extends State<Step5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
            children: [


              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Review Education",style: TextStyle(color: Color(0xFF003C30)),),
                ],
              ),

              SizedBox(
                height: 20,

              ),

              Container(
                width: 320,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white
                ),

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Graduation In Computer Science",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400)),
                          SizedBox(width: 35,),

                          Image.asset("assets/images/gpen.png",scale: 4),
                          SizedBox(width: 8,),
                          Image.asset("assets/images/delete.png",scale: 4),

                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(right: 25,top: 1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("New York School Of Computer Science - New York ",style: TextStyle(fontSize: 10)),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 185),
                      child: Text("April 2012 - July 2016",style: TextStyle(fontSize: 10)),
                    ),

                  ],
                ),





              ),

            SizedBox(height: 15,),

            Row(
              children: [
                SizedBox(width: 20,),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    
                  ),
                    onPressed: (){},
                    icon: Icon(Icons.add,color: Color(0xFF003C30),),
                    label: Text("Add Another",style: TextStyle(color: Color(0xFF003C30),fontSize: 10),),),
              ],
            ),


              Padding(
                padding: const EdgeInsets.only(left: 200),
                child: ElevatedButton(
                    onPressed: widget.onTab,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(40),
                      backgroundColor: const Color(0xFF003C30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                        style: TextStyle(color: Color(0xFFF1FA3F)), "Contiune")),
              ),

            ],),
      ),
    );
  }
}