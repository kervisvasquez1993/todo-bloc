class TaskModel {
  List<Data> data;
  TaskModel({this.data = const []});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        data: List<Data>.from(json["data"].map((e) => Data.fromJson(e))),
      );
}

class Data {
  int id;
  final String title;
  final String description;
  final String status;

  Data(
      {this.id = 0,
      this.status = "no-status",
      this.title = "no-title",
      this.description = "no-description"});
  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      status: json["status"]);
}
