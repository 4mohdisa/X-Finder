//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

List<DataModel> dataModelFromJson(var str) =>
    str.map<DataModel>((json) => DataModel.fromJson(json)).toList();

String dataModelToJson(List<DataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataModel {
  String? name;
  String? link;

  DataModel({
    this.name,
    this.link,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        name: json["name"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
      };
}
