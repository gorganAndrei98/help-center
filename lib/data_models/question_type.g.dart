part of 'question_type.dart';

QuestionType _$QuestionTypeFromJson(Map<String, dynamic> json) => QuestionType(
      idDomain: json["id_domain"] as int,
      codLang: json["cod_lang"] as String,
      typeCardId: json["type_card_id"] as int,
      typeDomain: json["type_domain"] as String,
      domTitle: json["dom_title"] as String?,
      domValue: json["dom_value"] as String,
      domOrder: json["dom_order"] as int?,
      isConfirmed: json["is_confirmed"] as int,
      parentIdDomain: json["parent_id_domain"] as int?,
      domDescription: json["dom_description"] as String?,
      disableCopy: json["disable_copy"] as int,
      nameGroup: json["name_group"] as String?,
    );

Map<String, dynamic> _$QuestionTypeToJson(QuestionType instance) => <String, dynamic>{
      'id_domain': instance.idDomain,
      'cod_lang': instance.codLang,
      'type_card_id': instance.typeCardId,
      'type_domain': instance.typeDomain,
      'dom_title': instance.domTitle,
      'dom_value': instance.domValue,
      'dom_order': instance.domOrder,
      'is_confirmed': instance.isConfirmed,
      'parent_id_domain': instance.parentIdDomain,
      'dom_description': instance.domDescription,
      'disable_copy': instance.disableCopy,
      'name_group': instance.nameGroup,
    };
