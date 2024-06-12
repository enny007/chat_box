import 'package:chat_box/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:chat_box/ui/dialogs/error_alert/error_alert_dialog.dart';
import 'package:chat_box/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:chat_box/ui/views/chat/chat_screen.dart';
import 'package:chat_box/ui/views/dashboard/dashboard_screen.dart';
import 'package:chat_box/ui/views/image_to_text/image_to%20_text_screen.dart';
import 'package:chat_box/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: ImageToTextView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: ErrorAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
