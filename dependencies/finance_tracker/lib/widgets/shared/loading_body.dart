import 'package:flutter/material.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';

class LoadingBody extends StatelessWidget {
  /// LoadingBody is a widget extensively used to manage errors and database loading interval throughout the app as the parent for any given screen body.
  const LoadingBody(
      {super.key,
      required this.loadingStatus,
      required this.errorText,
      required this.widget,
      this.feedbackText = "",
      required this.resetErrorTextFn,
      this.isFirstScreen = false});

  /// LoadingStatus variable that determines the database fetch status
  final LoadingStatus loadingStatus;

  /// The text to be shown in case of an error.
  final String errorText;

  /// Any specific feedback to be shown to the user, when it is needed.
  final String feedbackText;

  /// The child widget, mostly the body of a Scaffold.
  final Widget widget;

  /// Viewmodel function that will reset the error to empty.
  final Function resetErrorTextFn;

  /// Check to not show the back button on screen
  final bool isFirstScreen;

  @override
  Widget build(BuildContext context) {
    if (loadingStatus == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_sharp,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: !isFirstScreen,
              child: IconButton.filled(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            )
          ],
        ),
      );
    }

    //  else if (loadingStatus == LoadingStatus.submitting) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         CircularProgressIndicator(),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //             AppLocalizations.of(context)!.submitting,
    //             style: Theme.of(context).textTheme.bodyLarge,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // else if (loadingStatus == LoadingStatus.submitted) {
    //   return Builder(
    //     builder: (context) {
    //       // Use addPostFrameCallback to avoid calling Navigator.pop inside build
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         if (Navigator.canPop(context)) {
    //           Navigator.pop(context);
    //         }
    //       });
    //       return const SizedBox(); // Return an empty widget while pop is in progress
    //     },
    //   );
    // }

    if (errorText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorText)),
        );
        resetErrorTextFn();
      });
    }

    if (feedbackText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(feedbackText)),
        );
        resetErrorTextFn();
      });
    }

    return widget;
  }
}

