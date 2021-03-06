import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sku_flutter_example/sku/entity/spec_entity.dart';
import 'package:sku_flutter_example/sku/spec_bottom_layout.dart';
import 'package:sku_flutter_example/top_reminder_wongxd.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var rawSpecJson = """
       {
    "attrs": [
        {
            "key": "颜色",
            "value": [
                {
                    "id": 3,
                    "name": "红色",
                    "ownId": 1
                },
                {
                    "id": 4,
                    "name": "蓝色",
                    "ownId": 1
                }
            ]
        },
        {
            "key": "重量",
            "value": [
                {
                    "id": 5,
                    "name": "10KG",
                    "ownId": 2
                },
                {
                    "id": 6,
                    "name": "20KG",
                    "ownId": 2
                },
                {
                    "id": 7,
                    "name": "30KG",
                    "ownId": 2
                }
            ]
        },
        {
            "key": "产地",
            "value": [
                {
                    "id": 24,
                    "name": "江油",
                    "ownId": 22
                },
                {
                    "id": 23,
                    "name": "绵阳",
                    "ownId": 22
                },
                {
                    "id": 31,
                    "name": "四川绵阳市涪城区的撒啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊",
                    "ownId": 22
                }
            ]
        },
        {
            "key": "尺寸",
            "value": [
                {
                    "id": 20,
                    "name": "30cm",
                    "ownId": 14
                },
                {
                    "id": 19,
                    "name": "20cm",
                    "ownId": 14
                },
                {
                    "id": 18,
                    "name": "10cm",
                    "ownId": 14
                }
            ]
        }
    ],
    "combs": [
        {
            "comb": "4,6,23,20",
            "desc": "蓝色-20KG-绵阳-30cm",
            "id": 10,
            "price": "1.0(可抵扣)",
            "productId": 5,
            "stock": 2,
            "specImg":"http://ww3.sinaimg.cn/mw600/0073ob6Pgy1fo91049t9mj30lc0w0dnh.jpg"
        },
        {
            "comb": "4,5,23,19",
            "desc": "蓝色-10KG-绵阳-20cm",
            "id": 8,
            "price": "22.0(可抵扣)",
            "productId": 5,
            "stock": 333,
             "specImg":"http://wx4.sinaimg.cn/mw600/0072bW0Xly1fo908gkyqjj30en0miabp.jpg"
        },
        {
            "comb": "4,5,24,19",
            "desc": "蓝色-10KG-江油-20cm",
            "id": 9,
            "price": "1.0(可抵扣)",
            "productId": 5,
            "stock": 2,
             "specImg":"http://wx1.sinaimg.cn/mw600/0072bW0Xly1fo8zz4znwyj30hq0qoabz.jpg"
        },
        {
            "comb": "3,6,24,18",
            "desc": "红色-20KG-江油-10",
            "id": 11,
            "price": "1.0(可抵扣)",
            "productId": 5,
            "stock": 2,
            "specImg":"http://wx2.sinaimg.cn/mw600/0072bW0Xly1fo8zf0pn15j30ia0tzdox.jpg"
        }
    ]
}
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sku'),
      ),
      body: Column(children: [
        Center(
            child: Text(
                'Running on: ${Platform.isAndroid ? 'Android' : 'iOS'}\n')),
        RaisedButton(
          onPressed: () {
            SpecBottomLayout.show(
                context, SpecEntity.fromJson(json.decode(rawSpecJson)),
                tipShowProvider: (context, str) {
              TopReminder.info(context, str);
            });
          },
          child: Text('sku'),
        ),
      ]),
    );
  }
}
