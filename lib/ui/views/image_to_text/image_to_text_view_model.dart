import 'package:chat_box/app/app.dialogs.dart';
import 'package:chat_box/app/app.locator.dart';
import 'package:chat_box/model/image_model.dart';
import 'package:chat_box/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImageToTextViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  late final GenerativeModel _model;
  late final ScrollController _scrollController;
  late final TextEditingController _messageController;
  late final FocusNode _focusNode;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final List<String> _messages = [];
  final List<ImageModel> _images = [];

  ScrollController get scrollController => _scrollController;
  TextEditingController get messageController => _messageController;
  FocusNode get focusNode => _focusNode;
  GlobalKey<FormState> get formkey => _formkey;
  List<String> get messages => _messages;
  List<ImageModel> get images => _images;

  ImageToTextViewModel() {
    _initialize();
  }

  void _initialize() {
    _model = GenerativeModel(
      apiKey: AppConstants.apiKey,
      model: AppConstants.geminiVision,
    );
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void pickImage(BuildContext context) async {
    _images.clear();
    final assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 2,
        requestType: RequestType.image,
        gridCount: 2,
      ),
    );
    if (assets == null) return;

    if (assets.length == 1) {
      final firstImageType = await assets[0].mimeTypeAsync;
      final firstImage = await assets[0].thumbnailDataWithSize(
        const ThumbnailSize(1980, 1080),
        quality: 75,
      );

      if (firstImage == null) return;

      final model = ImageModel(
        image: firstImage,
        mimetype: firstImageType.toString(),
      );

      _images.add(model);
      rebuildUi();
    } else {
      //Records
      final (firstImageType, secondImageType) = (
        await assets[0].mimeTypeAsync,
        await assets[1].mimeTypeAsync,
      );

      final (firstImage, secondImage) = (
        await assets[0].thumbnailDataWithSize(
          const ThumbnailSize(1980, 1080),
          quality: 75,
        ),
        await assets[1].thumbnailDataWithSize(
          const ThumbnailSize(1980, 1080),
          quality: 75,
        ),
      );

      if (firstImage == null || secondImage == null) return;

      final model1 = ImageModel(
        image: firstImage,
        mimetype: firstImageType.toString(),
      );
      final model2 = ImageModel(
        image: secondImage,
        mimetype: secondImageType.toString(),
      );

      _images.addAll([model1, model2]);
      rebuildUi();
    }
  }

  void sendRequest(String text) async {
    List<DataPart> imageParts;
    GenerateContentResponse response;
    final isValid = _formkey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    if (_images.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.errorAlert,
        data: 'No Image is selected',
      );
      return;
    }

    final prompt = TextPart(text);
    setBusy(true);

    if (_images.length == 2) {
      imageParts = [
        DataPart(_images[0].mimetype, _images[0].image),
        DataPart(_images[1].mimetype, _images[1].image),
      ];
    } else if (_images.length == 1) {
      imageParts = [
        DataPart(_images[0].mimetype, _images[0].image),
      ];
    } else {
      imageParts = [];
    }

    await runBusyFuture(
      _model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]).then(
        (value) {
          if (value.text == null) {
            _dialogService.showCustomDialog(
              variant: DialogType.errorAlert,
              data: 'No response was found',
            );
            return;
          } else {
            setBusy(false);
            _messages.add(value.text.toString());
            _images.clear();
            _messageController.clear();
            _focusNode.requestFocus();
          }
        },
      )..catchError((error) {
          _dialogService.showCustomDialog(
            variant: DialogType.errorAlert,
            data: error.toString(),
          );
          setBusy(false);
        }),
    );
  }
}
