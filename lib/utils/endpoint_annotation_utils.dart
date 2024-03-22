// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

import '../annotation/endpoint_annotation.dart';

class EndpointMetadata {
  final DartType? paramType;
  final String functionName;
  final String className;
  final DartType? returnType;
  final RequestType requestType;
  final String endpointUrl;

  const EndpointMetadata({
    required this.paramType,
    required this.functionName,
    required this.className,
    required this.returnType,
    required this.requestType,
    required this.endpointUrl,
  });

  factory EndpointMetadata.fromAnnotation(
    Element element,
    ConstantReader annotation,
  ) {
    final paramType = EndpointAnnotationUtils.extractParamType(annotation);
    final className = EndpointAnnotationUtils.extractClassName(element);
    final functionName = EndpointAnnotationUtils.extractFunctionName(
      annotation,
      element,
    );
    final returnType = EndpointAnnotationUtils.extractResponseType(annotation);
    final requestType = EndpointAnnotationUtils.extractRequestType(annotation);
    final endpointUrl = EndpointAnnotationUtils.extractEndpoint(element);

    return EndpointMetadata(
      paramType: paramType,
      className: className,
      functionName: functionName,
      returnType: returnType,
      requestType: requestType,
      endpointUrl: endpointUrl,
    );
  }
}

class EndpointAnnotationUtils {
  static DartType? extractParamType(ConstantReader annotation) {
    var paramType = annotation.read('paramType');
    if (!paramType.isNull) {
      return paramType.typeValue;
    }
    return null;
  }

  static DartType? extractResponseType(ConstantReader annotation) {
    var responseType = annotation.read('returnType');
    if (!responseType.isNull) {
      return responseType.typeValue;
    }
    return null;
  }

  static String extractClassName(Element element) {
    final fnName = element.displayName;
    return "${fnName[0].toUpperCase()}${fnName.substring(1)}";
  }

  static String extractFunctionName(
    ConstantReader annotation,
    Element element,
  ) {
    var fnName = element.displayName;
    final value = annotation.read('functionName').literalValue as String?;
    if (value != null) {
      fnName = value;
    }
    return fnName;
  }

  static String extractEndpoint(Element element) {
    return (element as TopLevelVariableElement)
        .computeConstantValue()!
        .toStringValue()!;
  }

  static RequestType extractRequestType(ConstantReader annotation) {
    final i = annotation
        .read('requestType')
        .objectValue
        .getField('index')!
        .toIntValue()!;
    return RequestType.values[i];
  }
}
