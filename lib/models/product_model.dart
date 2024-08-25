class ProductModel {
  int? id;
  String? title;
  String? description;
  String? coverImage='https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg';
  String? terms;
  int? price;
  List<dynamic> images = ['https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg'];
  List<DateTime> occupied = [];
  int ?categoryID;

  ProductModel({
    String? id,
    String? title,
    String? description,
    List<dynamic> images=const ["https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"],
    var coverImage='https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg',
    int? price,
    String? terms,
    List<DateTime> occupied=const[],
    String ?categoryID,
  }) {
    this.title = title;
    this.description = description;
    this.images = images;
    this.coverImage = coverImage;
    this.price = price;
    this.terms = terms;
    this.occupied = occupied;
    this.categoryID=int.parse(categoryID??'0');
  }

  ProductModel.fromJson(Map<String, dynamic>? json) {
    this.id = (json?['id']);
    this.title = json?['title'];
    this.description = json?['description'];
    this.coverImage = json?['coverImage'];
    this.price = json?['price'];
    this.terms = json?['terms'];
    this.categoryID=json?['categoryID'];

    try{
      if (json?['occupied'] != null) {
        json?['occupied'].forEach((item) {
          // print(item);
          occupied?.add(DateTime.parse(item));
        });
      }
    }
    catch(err){
      // print("no occupied");
    }

    if (json?['images'] != null) {
      images.clear();
      json?['images'].forEach((item) {
        images.add(item);
      });
    }
  }

  Map<String, dynamic> toMap() {

    List<String>occ=[];
    occupied.forEach((day){
      occ.add(day.toString());
    });

    return {
      'title': title,
      'description': description,
      'images': images,
      'coverImage': coverImage,
      'price': price,
      'terms': terms,

      'occupied': occ,
      'categoryID':categoryID,
    };
  }
}
