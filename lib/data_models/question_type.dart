part 'question_type.g.dart';

class QuestionType {
  final int idDomain;
  final String codLang;
  final int typeCardId;
  final String typeDomain;
  final String? domTitle;
  final String domValue;
  final int? domOrder;
  final int isConfirmed;
  final int? parentIdDomain;
  final String? domDescription;
  final int disableCopy;
  final String? nameGroup;

  //would have been fun to have some more complex datatypes, like a date
  QuestionType({
    required this.idDomain,
    required this.codLang,
    required this.typeCardId,
    required this.typeDomain,
    this.domTitle,
    required this.domValue,
    this.domOrder,
    required this.isConfirmed,
    this.parentIdDomain,
    this.domDescription,
    required this.disableCopy,
    this.nameGroup,
  });


  @override
  String toString() {
    return 'QuestionType{idDomain: $idDomain, codLang: $codLang, typeCardId: $typeCardId, typeDomain: $typeDomain, domTitle: $domTitle, domValue: $domValue, domOrder: $domOrder, isConfirmed: $isConfirmed, parentIdDomain: $parentIdDomain, domDescription: $domDescription, disableCopy: $disableCopy, nameGroup: $nameGroup}';
  }



  factory QuestionType.fromJson(Map<String, dynamic> json) => _$QuestionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionTypeToJson(this);

}
