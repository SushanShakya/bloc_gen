import 'package:dio/dio.dart';

class XRepo {
  final Dio dio;

  XRepo({
    required this.dio,
  });

  Future<String> x() async {
    final res = await dio.get("/x");
    final data = res.data;
    return data;
  }
}
