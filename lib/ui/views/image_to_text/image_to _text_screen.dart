// ignore: file_names
import 'package:chat_box/ui/views/image_to_text/image_to_text_view_model.dart';
import 'package:chat_box/ui/widgets/image_text_form_field.dart';
import 'package:chat_box/ui/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';

class ImageToTextView extends StackedView<ImageToTextViewModel> {
  const ImageToTextView({super.key});

  @override
  Widget builder(
      BuildContext context, ImageToTextViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gemini Multi Model'),
      ),
      body: ListView.builder(
        controller: viewModel.scrollController,
        itemCount: viewModel.messages.length,
        itemBuilder: (BuildContext context, int index) {
          var message = viewModel.messages[index];
          return MessageWidget(
            message: message,
            isFromUser: false,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (viewModel.images.isNotEmpty) ...[
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.images.length,
                    itemBuilder: (BuildContext context, int index) {
                      final image = viewModel.images[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(
                          image.image,
                          width: 100,
                          height: 100,
                        ),
                      );
                    },
                  ),
                )
              ],
              Row(
                children: [
                  Form(
                    key: viewModel.formkey,
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.sizeOf(context).width * 0.74,
                      child: ImageTextFormField(
                        controller: viewModel.messageController,
                        focusNode: viewModel.focusNode,
                        isReadOnly: !viewModel.isBusy,
                        onfieldSubmitted: viewModel.sendRequest,
                        onPickImage: () => viewModel.pickImage(context),
                      ),
                    ),
                  ),
                  const Gap(8),
                  if (!viewModel.isBusy) ...[
                    ElevatedButton(
                      onPressed: () {
                        viewModel.sendRequest(viewModel.messageController.text);
                      },
                      child: const Text('Send'),
                    ),
                  ] else ...[
                    const CircularProgressIndicator.adaptive(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ImageToTextViewModel viewModelBuilder(BuildContext context) {
    return ImageToTextViewModel();
  }
}
