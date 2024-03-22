import 'package:bloc_gen/generators/code_generator/interface/icode_generator.dart';
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';
import 'package:bloc_gen/utils/repo_utils.dart';

class InterfaceCodeGenerator implements ICodeGenerator {
  @override
  String generateCode(
    EndpointMetadata metadata,
    FunctionMetadata fnData,
  ) {
    final className = generateClassName(metadata);
    return """
      abstract interface class $className {
        ${fnData.returnTypeDefinition} ${metadata.functionName}();
      }
    """;
  }

  @override
  String generateClassName(EndpointMetadata metadata) {
    return "I${metadata.className}Repo";
  }

  @override
  String get fileExtension => ".interface.dart";
}
