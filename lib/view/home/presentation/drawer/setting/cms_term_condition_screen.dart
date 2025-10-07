import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart' show CommonBackBtnWithTitle;

class CmsPageScreen extends StatelessWidget {
  final String title;
  final String? htmlData;

  const CmsPageScreen({super.key, required this.title, required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CommonBackBtnWithTitle(text: title),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: htmlData == null || htmlData!.isEmpty
                    ? Center(
                  child: Text(
                    "No content available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : Html(
                  data: htmlData!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
