class QueryResponse {
  final List<dynamic> data;

  const QueryResponse(this.data);

  factory QueryResponse.fromDynamic(dynamic data) {
    return QueryResponse(asList(data));
  }

  List<T> castData<T>(T Function(dynamic value) valueBuilder) {
    return data.map(valueBuilder).toList(growable: false);
  }

  static List<dynamic> asList(dynamic dynamicData) {
    if (dynamicData is List) {
      return dynamicData;
    } else {
      return [dynamicData];
    }
  }
}
