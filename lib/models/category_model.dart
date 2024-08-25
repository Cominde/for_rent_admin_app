class CategoryModel{

  String ?title;
  String ?id;

  CategoryModel(String title, String id)
  {
    this.title=title;
    this.id=id;
  }

  CategoryModel.fromJson(Map<String,dynamic>?json)
  {
    title=json?['title'];
    id=json?['id'].toString();

  }

}