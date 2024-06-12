import 'package:chat_box/ui/views/chat/chat_screen_view_model.dart';
import 'package:chat_box/ui/widgets/chat_text_form_field.dart';
import 'package:chat_box/ui/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StackedView<ChatScreenViewModel> {
  const ChatView({super.key});

  @override
  Widget builder(
      BuildContext context, ChatScreenViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat'),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          controller: viewModel.scrollController,
          itemCount: viewModel.chatSession.history.length,
          itemBuilder: (BuildContext context, int index) {
            var content = viewModel.chatSession.history.toList()[index];
            final message = viewModel.getMessageFromContent(content);
            return MessageWidget(
              message: message,
              isFromUser: content.role == 'user',
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            top: 8,
          ),
          child: Row(
            children: [
              Form(
                key: viewModel.formkey,
                child: SizedBox(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width * 0.74,
                  child: ChatTextFormField(
                    controller: viewModel.messageController,
                    focusNode: viewModel.focusNode,
                    isReadOnly: !viewModel.isBusy,
                    onfieldSubmitted: viewModel.sendChatMessage,
                  ),
                ),
              ),
              const Gap(8),
              if (!viewModel.isBusy) ...[
                ElevatedButton(
                  onPressed: () {
                    viewModel.sendChatMessage(viewModel.messageController.text);
                  },
                  child: const Text('Send'),
                ),
              ] else ...[
                const CircularProgressIndicator.adaptive(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  ChatScreenViewModel viewModelBuilder(BuildContext context) {
    return ChatScreenViewModel();
  }
}
