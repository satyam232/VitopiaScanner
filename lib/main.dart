import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> dataList = [];
  int ticketCount = 0;
  TextEditingController barcode = TextEditingController();

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dataList = prefs.getStringList('dataList') ?? [];
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dataList', dataList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
    ticketCount = dataList.length;
  }

  void addStringToList(String value) {
    if (dataList.contains(value)) {
      StatusContainer(context, Colors.red, "Already Entered");
    } else {
      setState(() {
        dataList.add(value);
        StatusContainer(context, Colors.green, "Verified");
      });
      saveData();
    }
  }

  // Future<void> scanBarcode() async {
  //   try {
  //     final barcodeData = await BarcodeScanner.scan();
  //     print('Barcode data: $barcodeData');
  //     // You can process the barcode data here, such as saving it to shared preferences or displaying it in your UI.
  //   } catch (error) {
  //     print('Error scanning barcode: $error');
  //     // Handle any errors that occur during the barcode scanning process.
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/PNGFiles/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Image.asset("assets/PNGFiles/logo.png"),
                  ),
                  Container(
                    child: Text(
                      "VItopia'24 Ticket Verification",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: 0.3,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buttons(width, "Upload Files", 50),
                  SizedBox(
                    height: 20,
                  ),
                  buttons(width, "Open Camera", 60),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      "Activate Here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: barcode,
                        onChanged: (value) {
                          setState(() {
                            if (value.length == 13) {
                              addStringToList(value);

                              ticketCount = dataList.length;
                              barcode.clear();
                            }
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none,
                            hintText: "BarCode"),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (barcode.text == "") {
                          Fluttertoast.showToast(
                              msg: "Enter the code",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            ticketCount = dataList.length;
                          });
                        } else {
                          if (barcode.text.length == 13) {
                            setState(() {
                              addStringToList(barcode.text);
                              ticketCount = dataList.length;
                              barcode.clear();
                            });
                          }
                        }

                        barcode.clear();
                        print(dataList);
                      },
                      child: buttons(width, "Enter", 40)),
                  Text("Status here:"),
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: width - 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Text(
                      "VERIFIED",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 0.3,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: width - 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(0.6)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Overall Tickets Verified",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          ticketCount.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buttons(double width, String name, double length) {
    return Container(
      alignment: Alignment.center,
      height: length,
      width: width - 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.withOpacity(0.8)),
      child: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

void StatusContainer(BuildContext context, Color color, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: color,
          child: Container(
            height: 200,
            width: 40,
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ));
    },
  );
}
