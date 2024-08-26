class ErrorResponseModel {
  String? error;
  late int status;

  ErrorResponseModel({this.error, required this.status});

  ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    return data;
  }
}
