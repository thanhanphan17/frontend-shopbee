// ignore_for_file: unnecessary_import, file_names, avoid_unnecessary_containers

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopbee/globals.dart';
import 'dart:convert';
import 'package:http/http.dart';

class MyStoreEditWidget extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const MyStoreEditWidget({super.key, required this.profileData});

  @override
  State<MyStoreEditWidget> createState() => _MyStoreEditWidgetState();
}

class _MyStoreEditWidgetState extends State<MyStoreEditWidget> {
  String? jwtToken;
  final searchController = TextEditingController();
  Map<String, dynamic> myProductData = {};

  Future<Map<String, dynamic>> getMyProduct() async {
    try {
      Response response = await get(
        Uri.parse(apiURL +
            'api/v1/product/list?shop_id=${widget.profileData['data']['id']}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        myProductData = responseBody;
        return responseBody;
      } else {
        print(response.body);
        print('failed product');
      }
    } catch (e) {
      print(e.toString());
    }
    return myProductData;
  }

  Future<void> deleteProduct(String id) async {
    try {
      Response response = await delete(
        Uri.parse(apiURL + 'api/v1/product/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);
      } else {
        print('failed to delete');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Function to set the JWT token
  Future<void> _setToken(String token) async {
    await setToken(token);
    setState(() {
      jwtToken = token;
    });
    print(jwtToken.toString());
  }

  // Function to get the JWT token
  Future<void> _getToken() async {
    String? token = await getToken();
    setState(() {
      jwtToken = token;
    });
  }

  @override
  void initState() {
    _getToken().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getMyProduct(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
            );
          } else {
            if (snapshot.hasError)
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                  child: Center(child: Text('Error: ${snapshot.error}')));
            else
              return Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 31),
                    Padding(
                      padding: const EdgeInsets.only(left: 23, right: 17),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          controller: searchController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF13B58C),
                            ),
                            hintText: "Search Product",
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 23),
                        child: Text(
                          "Products",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "AddProductPage");
                            },
                            child: DottedBorder(
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(12),
                              dashPattern: const [6, 6, 6, 6],
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                child: Container(
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Add Product',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          for (var myProduct in snapshot.data?['data'])
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(106, 158, 158, 158),
                                  width: 2,
                                ),
                              ),
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
                                                      myProduct['image']
                                                          ['url']),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Align(
                                    alignment: const Alignment(0, -0.3),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            //add edit product api here
                                            Navigator.pushNamed(
                                                context, "EditProductPage");
                                          },
                                          child: const CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Color.fromARGB(85, 0, 0, 0),
                                            child: Icon(Icons.border_color,
                                                color: Color.fromARGB(
                                                    115, 255, 255, 255)),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Delete Product"),
                                                content: const Text(
                                                    "Are you sure you want to delete this product?"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      deleteProduct(
                                                              myProduct['id'])
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Color.fromARGB(85, 0, 0, 0),
                                            child: Icon(Icons.delete,
                                                color: Color.fromARGB(
                                                    115, 255, 255, 255)),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    myProduct['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 4),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        myProduct['price']
                                                                .toString() +
                                                            ' đ',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFF33907C),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 1),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor:
                                                            Color(0xFF33907C),
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "http://d1851nciml9u0m.cloudfront.net/user/default-1691832193326062897.png"),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          myProduct['shop']
                                                              ['fullname'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        });
  }
}
