import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/controller/chat_bot_controller.dart';
import 'package:hesabo_chat_ai/features/core/extensions/extensions.dart';
import 'package:hesabo_chat_ai/features/core/theme/app_theme_helper.dart';

class ChatBox extends StatefulWidget {
  final ChatBotMessage content;

  const ChatBox({Key? key, required this.content}) : super(key: key);

  @override
  State<ChatBox> createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  late String userId;
  late bool isMine;
  Offset? position;
  final ChatBotController controller = locator<ChatBotController>();

  @override
  void didUpdateWidget(covariant ChatBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content.id != widget.content.id) {
      setState(() {
        isMine = mine(widget.content);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (key.currentContext != null) {
        final RenderBox box =
            key.currentContext?.findRenderObject() as RenderBox;
        position = box.localToGlobal(Offset.zero);
        setState(() {});
      }
    });
    isMine = mine(widget.content);
  }

  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onLongPress: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTap: () {
        // if (widget.showOverlay) {
        //   FocusManager.instance.primaryFocus?.unfocus();
        //   if (widget.content.contentType == ContentTypeEnum.localDeleted) {
        //     return;
        //   }
        //   dismissKeyboard();
        //   widget.overlayController.openOverlay(
        //     tag: widget.content.contentId.toString(),
        //   );
        // } else {
        //   widget.onTap(position!, widget);
        // }
      },
      child: Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Row(
                textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMine ? Color(0xFF25405B) : Color(0xFF202438),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: isMine
                            ? Radius.circular(20)
                            : Radius.circular(0),
                        bottomRight: isMine
                            ? Radius.circular(0)
                            : Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      textDirection: isMine
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isMine ? 'شما' : 'دستیار هوشمند',
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (!isMine)
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Html(
                                    data: widget.content.systemQuestion!,
                                    // You can customize styling here if needed
                                    // style: {
                                    //   "body": Style(fontSize: FontSize(16.0)),
                                    //   "p": Style(margin: Margins.zero()),
                                    // },
                                  ),
                                ),
                              ),
                            if (isMine)
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(
                                  isMine
                                      ? widget.content.text!
                                      : widget.content.systemQuestion!,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            SizedBox(height: 8),
                            Text(
                              widget.content.createdAt!.toHourMinute24(),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool mine(ChatBotMessage content) {
    return controller.userId.toString() == content.userId;
  }
}
