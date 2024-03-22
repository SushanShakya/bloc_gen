import 'package:bloc_gen/generators/code_generator/interface/icode_generator.dart';
import 'package:bloc_gen/utils/endpoint_annotation_utils.dart';
import 'package:bloc_gen/utils/repo_utils.dart';

class RepoCodeGenerator implements ICodeGenerator {
  @override
  String generateCode(
    EndpointMetadata metadata,
    FunctionMetadata fnData,
  ) {
    final className = generateClassName(metadata);
    return """
    import 'package:dio/dio.dart';

    class $className {

      final Dio dio;

      $className({
        required this.dio,
      });
      
      ${fnData.returnTypeDefinition} ${fnData.functionDefinition} async {
        final res = await dio.${fnData.reqType}("${metadata.endpointUrl}");
        final data = res.data;
        return ${fnData.returnDefinition};
      }
    }
    """;
  }

  @override
  String generateClassName(EndpointMetadata metadata) {
    return "${metadata.className}Repo";
  }

  @override
  String get fileExtension => ".repo.dart";
}
