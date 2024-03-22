// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';
import 'package:bloc_gen/utils/repo_utils.dart';

abstract interface class ICodeGenerator {
  String generateCode(
    EndpointMetadata metadata,
    FunctionMetadata functiondata,
  );

  String generateClassName(EndpointMetadata metadata);

  String get fileExtension;
}
