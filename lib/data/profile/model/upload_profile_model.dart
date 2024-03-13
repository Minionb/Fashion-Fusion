class UploadProfileModel {
  String? dictionary;
  dynamic newData;

  UploadProfileModel({
    required this.dictionary,
    required this.newData
  });

  UploadProfileModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[dictionary!] = newData;
    return data;
  }
}

class ResponseUploadProfileModel {
  ResponseUploadProfileModel.fromJson(Map<String, dynamic> json);
 
}
