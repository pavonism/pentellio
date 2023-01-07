import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/services/chat_service.dart';
import 'package:pentellio/services/image_service.dart';
import 'package:pentellio/services/user_service.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/drawing/draw_view.dart';
import 'package:pentellio/widgets/app_state_observer.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

import 'chat_list/chat_list.dart';
import 'chat_list/users_panel.dart';
import 'loading_screen.dart';

class PentellionPages extends StatelessWidget {
  PentellionPages({super.key, required this.signedInState});

  SignedInState signedInState;

  @override
  Widget build(BuildContext context) {
    return AppStateObserver(
      userService: context.read(),
      uId: signedInState.uid,
      child: Provider(
        create: (_) {
          return ChatService();
        },
        child: Provider(
          create: (_) =>
              StorageService(firebaseStorage: FirebaseStorage.instance),
          child: BlocProvider(
            create: (context) {
              return ChatCubit(
                  chatService: context.read(),
                  userService: context.read(),
                  storageService: context.read(),
                  userId: signedInState.uid);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return constraints.maxWidth < 600
                    ? PentellioPagesPortrait()
                    : PentellioPagesLandscape(
                        constraints: constraints,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PentellioPagesPortrait extends StatelessWidget {
  const PentellioPagesPortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, EmptyState>(
      builder: (context, state) {
        if (state is DrawingChatState) {
          return DrawView(
            user: state.currentUser,
            friend: state.openedChat,
          );
        } else if (state is ChatOpenedState) {
          return ChatView(
            friend: state.openedChat,
            user: state.currentUser,
          );
        } else if (state is SearchingUsersState) {
          return const UserListPanel();
        } else if (state is UserState) {
          return ChatPanelPortrait(
            user: state.currentUser,
          );
        }

        return const LoadingScreen();
      },
    );
  }
}

class PentellioPagesLandscape extends StatelessWidget {
  PentellioPagesLandscape({super.key, required this.constraints});

  BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width:
              constraints.maxWidth * 0.25 + (constraints.maxWidth - 600) * 0.01,
          height: double.infinity,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: BlocBuilder<ChatCubit, EmptyState>(
              builder: (context, state) {
                if (state is DrawingChatState) {
                  return DrawView(
                    user: state.currentUser,
                    friend: state.openedChat,
                  );
                } else if (state is ChatOpenedState) {
                  return ChatPanelPortrait(
                    user: state.currentUser,
                  );
                } else if (state.isSearchingUsers ?? false) {
                  return UserListPanel();
                } else if (state is UserState) {
                  return ChatPanelPortrait(
                    user: state.currentUser,
                  );
                }

                return const LoadingScreen();
              },
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ChatCubit, EmptyState>(
            builder: (context, state) {
              if (state is ChatOpenedState) {
                return ChatView(
                  friend: state.openedChat,
                  user: state.currentUser,
                );
              }

              return Scaffold(
                backgroundColor: Color(0xFF191C1F),
              );
            },
          ),
        )
      ],
    );
  }
}
