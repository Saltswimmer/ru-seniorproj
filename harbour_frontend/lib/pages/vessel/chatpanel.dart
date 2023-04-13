import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harbour_frontend/models/message.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/text_templates.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({Key? key}) : super(key: key);

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

enum ChatboxState { chat, search }

class _ChatPanelState extends State<ChatPanel> {
  late ColorScheme colors;

  ChatboxState cbState = ChatboxState.chat;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _chat;
  late final ScrollController _scrollController;

  List<Message> messages = [
    Message(
        body:
            "I don't have anything funny to say, so I'm just going to sit on this chair. Is that my chair? That is not your chair. IT'S MINE.",
        sender: "BOAAY",
        timestamp: DateTime.tryParse("2023-03-26 12:00")),
    Message(
        body: "Hello?",
        sender: "BOAAY",
        timestamp: DateTime.tryParse("2023-03-26 12:00")),
  ];

  @override
  void initState() {
    super.initState();
    _chat = TextEditingController();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Scrollbar(
                child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: colors.primary,
                      width: 2,
                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: colors.surface,
                              foregroundColor: colors.onSurface,
                              child: Text(messages[index].sender[0]),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: TextTemplates.medium(
                                      messages[index].body,
                                      colors.onBackground)),
                              Expanded(
                                child: TextTemplates.medium(
                                    "${messages[index].sender} at ${messages[index].timestamp.toString()}",
                                    Colors.white54),
                              )
                            ],
                          ),
                        ],
                      ),
                    ));
              },
            )),
          ),
          Form(
              key: _formKey,
              child: Row(children: [
                IconButton(
                    onPressed: () async {
                      if (_chat.text.isNotEmpty) {
                        switch (cbState) {
                          case ChatboxState.chat:
                            setState(() {
                              DateTime now = DateTime.now();
                              messages.add(Message(
                                  body: _chat.text,
                                  sender: Session.user!.username,
                                  timestamp: DateTime.now())
                                );
                            });

                            break;
                          case ChatboxState.search:
                            break;
                          default:
                            return;
                        }
                        _chat.clear();
                      }
                    },
                    icon: Icon(cbState == ChatboxState.chat
                        ? Icons.chat_bubble
                        : Icons.search)),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    cursorColor: colors.surface,
                    enableSuggestions: false,
                    controller: _chat,
                    decoration: InputDecoration(
                        hintText: cbState == ChatboxState.chat
                            ? "Send a message"
                            : "Search for messages"),
                  ),
                )
              ]))
        ],
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      setState(() {
        // Load new messages
        messages.addAll([]);
      });
    }

    if (_scrollController.position.extentBefore < 500) {
      setState(() {
        List<Message> newMessages = []..addAll(messages);
        messages = newMessages;
      });
    }
  }
}
