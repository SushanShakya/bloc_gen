// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta_meta.dart';

enum RequestType { get, post }

@Target({TargetKind.topLevelVariable})
class Endpoint {
  final String? functionName;
  final RequestType requestType;
  final Type? paramType;
  final Type? returnType;

  const Endpoint({
    this.functionName,
    this.requestType = RequestType.post,
    this.paramType,
    this.returnType,
  });
}
