import 'package:chat_box/app/app.dialogs.dart';
import 'package:chat_box/app/app.locator.dart';
import 'package:chat_box/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatScreenViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  late final GenerativeModel _model;
  late ChatSession _chatSession;
  late final ScrollController _scrollController;
  late final TextEditingController _messageController;
  late final FocusNode _focusNode;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ScrollController get scrollController => _scrollController;
  TextEditingController get messageController => _messageController;
  FocusNode get focusNode => _focusNode;
  ChatSession get chatSession => _chatSession;
  GlobalKey<FormState> get formkey => _formkey;

  ChatScreenViewModel() {
    initialize();
  }

  void initialize() {
    _model = GenerativeModel(
      apiKey: AppConstants.apiKey,
      model: AppConstants.geminiModel,
    );
    _chatSession = _model.startChat();
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage([String? value]) async {
    final isValid = _formkey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await runBusyFuture(
      _chatSession.sendMessage(Content.text(value!)).then((response) {
        final text = response.text;
        if (text == null) {
          _dialogService.showCustomDialog(
            variant: DialogType.errorAlert,
            data: 'No response was found',
          );
        }
        _messageController.clear();
        _focusNode.requestFocus();
      }).catchError((error) {
        _dialogService.showCustomDialog(
          variant: DialogType.errorAlert,
          data: error.toString(),
        );
        setBusy(false);
      }),
    );
  }

  String getMessageFromContent(Content content) {
    var text = content.parts.whereType<TextPart>().map((e) => e.text).join('');
    return text;
  }
}
