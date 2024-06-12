import 'package:chat_box/app/app.locator.dart';
import 'package:chat_box/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigateToChat() {
    _navigationService.navigateToChatView();
  }

  void navigateToImage() {
    _navigationService.navigateToImageToTextView();
  }

}
