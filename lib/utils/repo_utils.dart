// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:analyzer/dart/element/type.dart';

import 'package:bloc_gen/annotation/endpoint_annotation.dart';
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';

class FunctionMetadata {
  final String returnTypeDefinition;
  final String functionDefinition;
  final String reqType;
  final String returnDefinition;

  const FunctionMetadata({
    required this.returnTypeDefinition,
    required this.functionDefinition,
    required this.reqType,
    required this.returnDefinition,
  });

  factory FunctionMetadata.fromEndpointMetadata(EndpointMetadata data) {
    final returnTypeDefinition = RepoUtils.generateReturnTypeDefinition(
      data.returnType?.toString(),
    );
    final functionDefinition = RepoUtils.generateFunctionDefinition(
      data.functionName,
      data.paramType?.toString(),
    );

    final reqType = RepoUtils.resolveRequestType(data.requestType);

    final returnDefinition = RepoUtils.generateReturnDefinition(
      data.returnType,
    );

    return FunctionMetadata(
      returnTypeDefinition: returnTypeDefinition,
      functionDefinition: functionDefinition,
      reqType: reqType,
      returnDefinition: returnDefinition,
    );
  }
}

class RepoUtils {
  static String generateReturnTypeDefinition(String? returnType) {
    if (returnType == null) return "dynamic";
    return "Future<$returnType>";
  }

  static String generateFunctionDefinition(
    String functionName,
    String? paramType,
  ) {
    return "$functionName(${paramType == null ? "" : "$paramType param"})";
  }

  static bool isPrimitiveTypes(DartType type) {
    return type.isDartCoreBool ||
        type.isDartCoreMap ||
        type.isDartCoreString ||
        type.isDartCoreNum;
  }

  static String resolveRequestType(RequestType type) {
    return type.name;
  }

  static String generateReturnDefinition(
    DartType? returnType,
  ) {
    if (returnType == null) return "data";

    if (isPrimitiveTypes(returnType)) return "data";

    String returnDefinition = """
      ${returnType.toString()}.fromMap(data)
    """;
    if (returnType.isDartCoreList) {
      var typeArgument =
          (returnType as ParameterizedType).typeArguments[0].toString();
      returnDefinition = """
        List<$typeArgument>.from(data.map((e) => $typeArgument.fromMap(e)))
      """;
    }

    return returnDefinition;
  }
}
