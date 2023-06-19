import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitcoin',
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamController<DataModelPrice> _streamController = StreamController();

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      getCrytoPrice();
    });
  }

  Future<void> getCrytoPrice() async {
    var uri =
        Uri.parse('https://api.api-ninjas.com/v1/cryptoprice?symbol=LTCBTC');
    final header = <String, String>{
      'X-Api-Key': 'AmVc/04ixzE0qn5GT47U/Q==XiVSHQxKjLzjBdXg'
    };
    final response = await http.get(uri, headers: header);
    final dataBody = json.decode(response.body);
    DataModelPrice dataModelPrice = DataModelPrice.fromJson(dataBody);

    _streamController.sink.add(dataModelPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<DataModelPrice>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
              default: if (snapshot.hasError){
                return Text('Xin hãy chờ');
              }
              else {
                return BuildCoinWidget(snapshot.data!);
              }
            }
          },
        ),
      ),
    );
  }

  Widget BuildCoinWidget(DataModelPrice dataModelPrice) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${dataModelPrice.price}'),
          SizedBox(height: 20,),
          Text('${dataModelPrice.symbol}'),
          SizedBox(height: 20,),
          Text('${dataModelPrice.timestamp}'),
          SizedBox(height: 20,),
          Image.network('https://i-invdn-com.investing.com/news/litecoin_800x533_L_1556445276.jpg')
        ],
      ),
    );
  }
}
