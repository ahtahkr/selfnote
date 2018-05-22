final String tableName = "category";
final String columnId = "id";
final String columnTitle = "title";

class Category {
  int id;
  String title;

  Category() {
    this.title = "";
  }

  String toString() {
    return "{id:$id, title:$title}";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnTitle: title.toString()
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Category.fromMap(Map map) {
    /*map.forEach((k, v) => print("Category. from Map. " + k + ":" + v.toString()));*/
    id = map[columnId];
    title = map[columnTitle];
  }
}