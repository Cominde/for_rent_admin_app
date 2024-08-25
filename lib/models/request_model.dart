class RequestModel {
  int? id;
  String? name;
  String? phone;
  int? productID;
  List<String> days = [];
  String? productName;

  RequestModel({
    String? id,
    String? name,
    String? phone,
    int? productID,
    String?productName,
    List<String> occupied = const [],
  }) {
    this.name = name;
    this.phone = phone;
    this.productID = productID;
    this.days = occupied;
    this.productName=productName;
  }

  RequestModel.fromJson(Map<String, dynamic>? json) {
    this.id = (json?['id']);
    this.name = json?['name'];
    this.phone = json?['phone'];
    this.productID = json?['productID'];

    try {
      if (json?['days'] != null) {
        json?['days'].forEach((item) {
          // print(item);
          days?.add(item);
        });
      }
    } catch (err) {
      // print("no occupied");
    }

    Map<String, dynamic> toMap() {
      return {
        'title': name,
        'description': phone,
        'price': productID,
        'occupied': days,
      };
    }
  }
}
