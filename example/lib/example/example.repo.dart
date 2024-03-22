import 'package:dio/dio.dart';

class LoginRepo {
  final Dio dio;

  LoginRepo({
    required this.dio,
  });

  Future<String> login(String param) async {
    final res = await dio.post("/login");
    final data = res.data;
    return data;
  }
}
