// To parse this JSON data, do
//
//     final canteenWebsite = canteenWebsiteFromJson(jsonString);

import 'dart:convert';

CanteenWebsite canteenWebsiteFromJson(String str) => CanteenWebsite.fromJson(json.decode(str));

String canteenWebsiteToJson(CanteenWebsite data) => json.encode(data.toJson());

class CanteenWebsite {
    List<Faculty> faculties;
    List<Canteen> canteens;
    List<Stall> stalls;
    List<Product> products;

    CanteenWebsite({
        required this.faculties,
        required this.canteens,
        required this.stalls,
        required this.products,
    });

    factory CanteenWebsite.fromJson(Map<String, dynamic> json) => CanteenWebsite(
        faculties: List<Faculty>.from(json["faculties"].map((x) => Faculty.fromJson(x))),
        canteens: List<Canteen>.from(json["canteens"].map((x) => Canteen.fromJson(x))),
        stalls: List<Stall>.from(json["stalls"].map((x) => Stall.fromJson(x))),
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "faculties": List<dynamic>.from(faculties.map((x) => x.toJson())),
        "canteens": List<dynamic>.from(canteens.map((x) => x.toJson())),
        "stalls": List<dynamic>.from(stalls.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Canteen {
    String model;
    int pk;
    CanteenFields fields;

    Canteen({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Canteen.fromJson(Map<String, dynamic> json) => Canteen(
        model: json["model"],
        pk: json["pk"],
        fields: CanteenFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class CanteenFields {
    String name;
    int faculty;
    String image;
    String price;

    CanteenFields({
        required this.name,
        required this.faculty,
        required this.image,
        required this.price,
    });

    factory CanteenFields.fromJson(Map<String, dynamic> json) => CanteenFields(
        name: json["name"],
        faculty: json["faculty"],
        image: json["image"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "faculty": faculty,
        "image": image,
        "price": price,
    };
}

class Faculty {
    String model;
    int pk;
    FacultyFields fields;

    Faculty({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        model: json["model"],
        pk: json["pk"],
        fields: FacultyFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class FacultyFields {
    String name;
    String nickname;
    String colors;
    String image;

    FacultyFields({
        required this.name,
        required this.nickname,
        required this.colors,
        required this.image,
    });

    factory FacultyFields.fromJson(Map<String, dynamic> json) => FacultyFields(
        name: json["name"],
        nickname: json["nickname"],
        colors: json["colors"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "nickname": nickname,
        "colors": colors,
        "image": image,
    };
}

class Product {
    ProductModel model;
    int pk;
    ProductFields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: productModelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: ProductFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": productModelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class ProductFields {
    String name;
    String price;
    int stall;

    ProductFields({
        required this.name,
        required this.price,
        required this.stall,
    });

    factory ProductFields.fromJson(Map<String, dynamic> json) => ProductFields(
        name: json["name"],
        price: json["price"],
        stall: json["stall"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "stall": stall,
    };
}

enum ProductModel {
    MAIN_PRODUCT
}

final productModelValues = EnumValues({
    "main.product": ProductModel.MAIN_PRODUCT
});

class Stall {
    StallModel model;
    int pk;
    StallFields fields;

    Stall({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Stall.fromJson(Map<String, dynamic> json) => Stall(
        model: stallModelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: StallFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": stallModelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class StallFields {
    String name;
    int canteen;
    String cuisine;

    StallFields({
        required this.name,
        required this.canteen,
        required this.cuisine,
    });

    factory StallFields.fromJson(Map<String, dynamic> json) => StallFields(
        name: json["name"],
        canteen: json["canteen"],
        cuisine: json["cuisine"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "canteen": canteen,
        "cuisine": cuisine,
    };
}

enum StallModel {
    MAIN_STALL
}

final stallModelValues = EnumValues({
    "main.stall": StallModel.MAIN_STALL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
