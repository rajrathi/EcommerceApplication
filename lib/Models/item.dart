import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  String productType;
  Timestamp publishedDate;
  String thumbnailUrl;
  String description;
  String status;
  int price;
  int discountPercent;
  String productId;

  ItemModel(
      {this.title,
        this.productType,
        this.publishedDate,
        this.thumbnailUrl,
        this.description,
        this.status,
        this.productId,
        });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    productType = json['productType'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    status = json['status'];
    price = json['price'] as int ;
    discountPercent = json['discountPercent'] as int;
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['productType'] = this.productType;
    data['price'] = this.price;
    data['discountPercent'] = this.discountPercent;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    data['productId'] = this.productId;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
