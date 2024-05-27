
class ProductModel {
  int? id;
  String? name;
  String? image;
  double? price;
  String? date;

  ProductModel({
    this.id,
    this.name,
    this.image,
    this.price,
    this.date,
  });

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) => ProductModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    price: json["price"]?.toDouble(),
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "price": price,
    "date": date,
  };

  Map<String, Object> toMap() {
    Map<String, Object> data = {};

    if(id != null){
      data["id"] = id!;
    }

    if(name != null){
      data["name"] = name!;
    }

    if(image != null){
      data["image"] = image!;
    }

    if(price != null){
      data["price"] = price!;
    }

    if(date != null){
      data["date"] = date!;
    }

    return data;
  }
}
