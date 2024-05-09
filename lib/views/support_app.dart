import 'package:flu/cubits/support_page/support_page_cubit.dart';
import 'package:flu/locator/locator.dart';
import 'package:flu/navigation/routes.dart';
import 'package:flu/server_requests/core/http_requests_core.dart';
import 'package:flu/views/base/base_leaf_background.dart';
import 'package:flu/views/components/feedback_dialog.dart';
import 'package:flu/views/components/rows/editable_row.dart';
import 'package:flu/views/components/rows/expandable_row.dart';
import 'package:flu/views/components/rows/images_row.dart';
import 'package:flu/views/components/templates/ui_templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SupportApp extends StatelessWidget {
  const SupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupportPageCubit>(
      create: (context) => SupportPageCubit(
          requests: getIt<HttpRequestsCore>().questionTypeRequests)
        ..getQuestionTypes(),
      child: const BaseLeafBackground(
        child: _SupportAppPage(),
      ),
    );
  }
}

class _SupportAppPage extends StatefulWidget {
  const _SupportAppPage({super.key});

  @override
  State<_SupportAppPage> createState() => _SupportAppPageState();
}

class _SupportAppPageState extends State<_SupportAppPage> {
  void _setSelectedQuestionType(String input) {
    if (!mounted) return;
    context.read<SupportPageCubit>().updateSelectedQuestionType(input);
    return;
  }

  void _setFreeText(String input) {
    if (!mounted) return;
    context.read<SupportPageCubit>().updateFreeText(input);
    return;
  }

  void _addImage(String path) {
    if (!mounted) return;
    context.read<SupportPageCubit>().addImage(path);
    return;
  }

  bool _checkFields() {
    final state = context.read<SupportPageCubit>().state;
    return state.selectedQuestionType != null &&
        (state.freeText != null && state.freeText!.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportPageCubit, SupportPageCubitState>(
        builder: (context, state) {
      if (state.status == SupportPageStatus.loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: SizedBox(
                    height: 131,
                    width: 169,
                    child: SvgPicture.asset(
                      'assets/operator.svg',
                    ),
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "Come possiamo aitarti",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                ...[
                  const Text(
                    "Seleziona una sezione o argomento",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  //Expandable row
                  ExpandableRow(
                    choices:
                        state.questionTypes.map((e) => e.domValue).toList(),
                    onChoiceSelected: _setSelectedQuestionType,
                    informationAsString: state.selectedQuestionType?.domValue ??
                        'Seleziona sezione o argomento',
                  ),

                  const Text(
                    "Formula la tua domanda",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  //editable information row
                  EditableRow(
                    multiline: true,
                    onChanged: _setFreeText,
                    maxLength: 2000,
                  ),

                  const Text(
                    "Aggiungi immagini (massimo 5)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  ImagesRow(
                    onImageSelected: (file) => _addImage(file.path),
                    maxImages: 5,
                    initialImagePaths: state.filePaths,
                  ),
                ].map((e) => Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                      child: e,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Annulla',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                    //backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text("Simula errore api"),
                    Checkbox(
                        value: state.simulateApiError,
                        onChanged: (_) => context.read<SupportPageCubit>().setApiError()
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_checkFields()) {
                          final res = await context
                              .read<SupportPageCubit>()
                              .sendSupportRequest();
                          await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => FeedbackDialog(
                                    isPositive: state.simulateApiError ? false : res.success,
                                  )).then((res) {
                            if (res == true) {
                              final nav = Navigator.of(context);
                              final modalRoute =
                                  ModalRoute.withName(Routes.DASHBOARD);
                              nav.popUntil(
                                  (route) => modalRoute(route) || route.isFirst);
                            }
                          });
                        } else {
                          UITemplates.showToast(
                              "Controlla i campi", ToastType.Error);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            _checkFields() ? Colors.green : Colors.grey),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: _checkFields() ? Colors.green : Colors.grey),
                          ),
                        ),
                      ),
                      child: const Text('Invia',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
