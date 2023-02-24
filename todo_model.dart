class TodoModel {
  String? id;
  String? avatar;
  String? name;
  String? desc;
  String? date;

  TodoModel({this.id, this.avatar, this.name, this.desc, this.date});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    desc = json['desc'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['date'] = this.date;
    return data;
  }
}
