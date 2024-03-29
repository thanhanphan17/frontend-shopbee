// ignore_for_file: unnecessary_import, file_names, avoid_unnecessary_containers
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopbee/globals.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shopbee/pages/ProductDetailScreens/ProductDetailPage.dart';

class StoreProfileWidget extends StatefulWidget {
  final String id;
  const StoreProfileWidget({super.key, required this.id});

  @override
  State<StoreProfileWidget> createState() => _StoreProfileWidgetState();
}

class _StoreProfileWidgetState extends State<StoreProfileWidget> {
  final searchController = TextEditingController();
  String? jwtToken;
  Map<String, dynamic> storeProfileProductData = {};

  @override
  void initState() {
    _getToken().then((value) {});
    super.initState();
  }

  Future<Map<String, dynamic>> getStoreProfileProduct(String id) async {
    try {
      Response response = await get(
        Uri.parse(apiURL + 'api/v1/product/list?shop_id=${id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        storeProfileProductData = responseBody;
        return responseBody;
      } else {
        print(response.body);
        print('failed product');
      }
    } catch (e) {
      print(e.toString());
    }
    return storeProfileProductData;
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
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getStoreProfileProduct(widget.id),
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
            else if (!snapshot.data?['data'].isEmpty)
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
                          for (var myProduct in snapshot.data?['data'])
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  'ProductDetailPage',
                                  arguments: ProductData(myProduct['id']),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        106, 158, 158, 158),
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
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                            ),
                                            child: Container(
                                              foregroundDecoration:
                                                  BoxDecoration(
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
                                                            color: Color(
                                                                0xFF33907C),
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
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  "http://d1851nciml9u0m.cloudfront.net/user/default-1691832193326062897.png"),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            myProduct['shop']
                                                                ['fullname'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
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
                    ),
                  ],
                ),
              );
            else
              return Text('no data');
          }
        });
  }
}
