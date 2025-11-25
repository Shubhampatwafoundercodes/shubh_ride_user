import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart'
    show CommonBackBtnWithTitle;

class CmsPageScreen extends StatelessWidget {
  final String title;
  final String? htmlData;

  const CmsPageScreen({
    super.key,
    required this.title,
    required this.htmlData,
  });

  @override
  Widget build(BuildContext context) {
    final safeHtml = htmlData?.trim() ?? "";

    return Scaffold(
      // backgroundColor: =.white,
      body: SafeArea(
        child: Column(
          children: [
            CommonBackBtnWithTitle(text: title),
            Expanded(
              child: safeHtml.isEmpty
                  ? const Center(
                child: Text(
                  "No content available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : SingleChildScrollView(
                padding: AppPadding.screenPadding,
                child: Html(
                  data: safeHtml,
                  style: {
                    "body": Style(
                      fontSize: FontSize(15.0),
                      lineHeight: LineHeight.number(1.5),
                      color:context.textPrimary,
                    ),
                    "h1": Style(fontSize: FontSize(22), fontWeight: FontWeight.bold),
                    "h2": Style(fontSize: FontSize(18), fontWeight: FontWeight.w600),
                    "ul": Style(margin: Margins.only(bottom: 10)),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
