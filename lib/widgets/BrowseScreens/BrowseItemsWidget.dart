// ignore_for_file: file_names

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shopbee/globals.dart';

import '../../pages/ProductDetailScreens/ProductDetailPage.dart';

class BrowseItemsWidget extends StatefulWidget {
  final String searchKey;
  const BrowseItemsWidget({super.key, required this.searchKey});

  @override
  State<BrowseItemsWidget> createState() => _BrowseItemsWidgetState();
}

class _BrowseItemsWidgetState extends State<BrowseItemsWidget> {
  Map<String, dynamic> bookData = {};

  Future<Map<String, dynamic>> getProduct() async {
    try {
      Response response = await get(
        Uri.parse(apiURL + 'api/v1/product/list?key_word=${widget.searchKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        bookData = responseBody;
        return responseBody;
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
    return bookData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getProduct(), // function where you call your api
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (snapshot.hasError)
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.white,
                  child: Center(child: Text('Error: ${snapshot.error}')));
            else if (!snapshot.data?['data'].isEmpty)
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: GridView.count(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 12.35,
                  childAspectRatio: 0.82,
                  primary: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: [
                    for (var productData in snapshot.data?['data'])
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(106, 158, 158, 158),
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'ProductDetailPage',
                              arguments: ProductData(
                                productData['id'],
                              ),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Align(
                                  alignment: const Alignment(0, -1),
                                  child: FractionallySizedBox(
                                    heightFactor: .65,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                      child: Container(
                                        foregroundDecoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  productData['image']['url']),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                  )),
                              Align(
                                alignment: const Alignment(-1, 1),
                                child: FractionallySizedBox(
                                  heightFactor: .35,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 4),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                productData['name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12, right: 12, bottom: 4),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    productData['price']
                                                            .toString() +
                                                        ' đ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF33907C),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12, right: 12, bottom: 1),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Color(0xFF33907C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundImage: NetworkImage(
                                                        "http://d1851nciml9u0m.cloudfront.net/user/default-1691832193326062897.png"),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Flexible(
                                                    child: Text(
                                                      productData['shop']
                                                          ['fullname'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            else
              return Container();
          }
        });
  }
}
