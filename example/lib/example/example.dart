import 'package:bloc_gen/annotation/endpoint_annotation.dart';

class Something {
  Something();
  factory Something.fromMap(Map<String, dynamic> map) {
    return Something();
  }
  Map<String, dynamic> toMap() {
    return {};
  }
}

@Endpoint(paramType: String, returnType: String)
const login = '/login';
