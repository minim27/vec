class RatingResponseModel {
  RatingResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final dynamic data;

  factory RatingResponseModel.fromJson(Map<String, dynamic> json) =>
      RatingResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data,
      };
}
