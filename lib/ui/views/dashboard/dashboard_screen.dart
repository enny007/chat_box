import 'package:chat_box/ui/common/ui_helpers.dart';
import 'package:chat_box/ui/views/dashboard/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
      BuildContext context, DashboardViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                viewModel.navigateToChat();
              },
              child: const Text('Chat'),
            ),
            verticalSpace(16),
            FilledButton(
              onPressed: () {
                viewModel.navigateToImage();
              },
              child: const Text('Image To Text'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
    return DashboardViewModel();
  }
}
