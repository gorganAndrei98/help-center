class JoyFloImages {
  final String base64Img;
  final String ext;

  const JoyFloImages({required this.base64Img, required this.ext});

  Map<String, dynamic> toJson() => {
        'img': base64Img,
        'ext': ext,
      };
}

class TechSupportQuestion {
  final int userId;
  final int typeRequest;
  final int typeQuestion;
  final String message;
  final List<JoyFloImages>? images;

  TechSupportQuestion({
    required this.userId,
    required this.typeRequest,
    required this.typeQuestion,
    required this.message,
    this.images,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'type_request': typeRequest,
        'type_question': typeQuestion,
        'message': message,
        'images': images?.map((image) => image.toJson()).toList() ?? [],
      };
}
