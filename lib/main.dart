import 'dart:convert';

import 'package:examcreative/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: firstpage(),
  ));
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  String? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;

  List<viewresponce> temp = [];

  Rating? rating;
  bool status = false;
  List searchlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewdata();
  }

  Future<void> viewdata() async {
    var url = Uri.parse('https://fakestoreapi.com/products');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    List mylist = jsonDecode(response.body);

    for (int i = 0; i < mylist.length; i++) {
      viewresponce vs = viewresponce.fromJson(mylist[i]);
      temp.add(vs);
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              },
          )
        ],
          title:
          TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              if (value != "")  {
                searchlist = [];
                for (int i = 0; i < temp.length; i++) {
                  String title = "${temp[i].title}";
                  if (title.toLowerCase().toString().contains(value.toLowerCase().toString())) {
                    searchlist.add(temp[i]);
                    print(searchlist);
                  }
                }
              } else
              {
                searchlist = temp;
                setState(() {
                });
              }
            });
          },
        ),
          backgroundColor: Colors.purpleAccent.shade100,
        ),
        backgroundColor: Colors.green.shade200,
        body: status
            ? ListView.builder(
                itemCount: temp.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return viewpage(temp[index].image, index);
                          },
                        ));
                      },
                      title: Text("${temp[index].title}"),
                      subtitle: Text(
                          "       ${temp[index].id}            rating: ${temp[index].rating}   "
                          "               price:-${temp[index].price}"),
                      leading: Expanded(
                        child: ClipRect(
                            child: Image.network("${temp[index].image}")),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class viewresponce {
  int? id;
  String? title;
  dynamic? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  viewresponce(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating});

  viewresponce.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating =
        json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  dynamic? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
