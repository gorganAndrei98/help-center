import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flu/data_models/tech_support_question.dart';
import 'package:flu/server_requests/core/question_type_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../data_models/question_type.dart';
import '../../locator/locator.dart';
import '../../server_requests/core/http_requests_core.dart';
import '../../server_requests/server_response.dart';
import 'package:path/path.dart' as path;

class SupportPageCubit extends Cubit<SupportPageCubitState> {
  final QuestionTypeRequests requests;

  SupportPageCubit({required this.requests})
      : super(SupportPageCubitInitialState());

  Future<void> getQuestionTypes() async {
    if (isClosed) return;
    emit(state.copyWith(status: SupportPageStatus.loading));

    final delay = Future.delayed(const Duration(microseconds: 500));
    final fetchData = () async {
      return requests.getAll();
    }();
    final result = await Future.wait([delay, fetchData]);

    emit(state.copyWith(
        questionTypes: result[1], status: SupportPageStatus.success));
  }

  void setApiError() {
    emit(state.copyWith(simulateApiError: !state.simulateApiError));
  }

  void updateSelectedQuestionType(String input) {
    final selectedQuestionType =
        state.questionTypes.firstWhere((element) => element.domValue == input);
    emit(state.copyWith(selectedQuestionType: selectedQuestionType));
  }

  void addImage(String path) {
    List<String> updatedPaths = List<String>.from(state.filePaths)..add(path);
    emit(state.copyWith(filePaths: updatedPaths));
  }

  void updateFreeText(String input) {
    emit(state.copyWith(freeText: input));
  }

  Future<ServerResponse> sendSupportRequest() async {
    emit(state.copyWith(status: SupportPageStatus.loading));
    //from path to base64
    List<JoyFloImages> joyFloImages = [];

    for (String filePath in state.filePaths) {
      String? base64Img = await _imageToBase64(filePath, 700 * 1024);
      if(base64Img != null){
        joyFloImages.add(JoyFloImages(base64Img: base64Img, ext: path.extension(filePath)));
      }
    }

    final techSupportQuestion = TechSupportQuestion(
      userId: 1,
      typeRequest: 19785,
      typeQuestion: state.selectedQuestionType!.idDomain,
      message: state.freeText!,
      images: joyFloImages,
    );
    final serverResponse = await getIt<HttpRequestsCore>()
        .techSupportRequests
        .postSupportRequest(techSupportQuestion);
    emit(SupportPageCubitInitialState());
    return serverResponse;
  }

  Future<String?> _imageToBase64(String filePath, int maxSizeBytes) async {
    final File file = File(filePath);
    final Uint8List bytes = await file.readAsBytes();
    final Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 1920,
      minWidth: 1080,
      quality: 85,
    );
    if ((compressedBytes?.length ?? 0) > maxSizeBytes) {
      return null;
    }
    return "data:image/png;base64,${base64Encode(compressedBytes ?? bytes)}";
  }

}

enum SupportPageStatus { loading, success, failure }

//state
class SupportPageCubitState {
  final QuestionType? selectedQuestionType;
  final List<QuestionType> questionTypes;
  final String? freeText;
  final List<String> filePaths;
  final SupportPageStatus status;
  final bool simulateApiError;

  SupportPageCubitState({
    this.selectedQuestionType,
    this.freeText,
    required this.filePaths,
    required this.questionTypes,
    required this.status,
    this.simulateApiError = false,
  });

  @override
  String toString() {
    return 'SupportPageCubitState{selectedQuestionType: $selectedQuestionType, questionTypes: $questionTypes, freeText: $freeText, files: $filePaths, status: $status}';
  }

  SupportPageCubitState copyWith({
    QuestionType? selectedQuestionType,
    List<QuestionType>? questionTypes,
    String? freeText,
    List<String>? filePaths,
    SupportPageStatus? status,
    bool? simulateApiError,
  }) {
    return SupportPageCubitState(
      selectedQuestionType: selectedQuestionType ?? this.selectedQuestionType,
      questionTypes: questionTypes ?? this.questionTypes,
      filePaths: filePaths ?? this.filePaths,
      freeText: freeText ?? this.freeText,
      status: status ?? this.status,
      simulateApiError: simulateApiError ?? this.simulateApiError,
    );
  }
}

class SupportPageCubitInitialState extends SupportPageCubitState {
  SupportPageCubitInitialState()
      : super(status: SupportPageStatus.success, questionTypes: [], filePaths: []);
}
