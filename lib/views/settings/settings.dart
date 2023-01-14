import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/login/login_title.dart';
import 'package:pentellio/views/page_navigator.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key, required this.user});

  final PentellioUser user;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _darkTheme = true;
  bool _imageHover = false;
  final ImagePicker _imagePicker = ImagePicker();

  Widget _buildProfilePicture(BuildContext context, double profilePictureSize) {
    var chatCubit = context.read<ChatCubit>();

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(profilePictureSize * 0.2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(profilePictureSize * 0.1),
        onTap: () async {
          var image = await _imagePicker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            chatCubit.changeProfilePicture(image);
          }
        },
        onHover: ((value) => setState(() {
              _imageHover = value;
            })),
        child: SizedBox(
          height: profilePictureSize,
          width: profilePictureSize,
          child: Stack(
            children: [
              widget.user.profilePictureUrl.isNotEmpty
                  ? CachedNetworkImage(
                      cacheManager: kIsWeb ? null : context.read(),
                      color: _imageHover ? Colors.grey.shade700 : null,
                      colorBlendMode: BlendMode.overlay,
                      placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      imageUrl: widget.user.profilePictureUrl)
                  : SizedBox(
                      width: profilePictureSize,
                      height: profilePictureSize,
                      child: ColoredBox(color: Colors.blue),
                    ),
              if (_imageHover)
                Center(child: Icon(size: profilePictureSize * 0.3, Icons.image))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: const [Text("Dark theme")],
            ),
            Column(
              children: [
                Switch(
                  onChanged: (value) => {
                    setState(() {
                      _darkTheme = value;
                    }),
                  },
                  value: _darkTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOut(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.read<AuthCubit>().signOut();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [const Text("Log out")],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var profilePictureSize = min<double>(200, constraints.maxWidth);
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfilePicture(context, profilePictureSize),
                const SizedBox(
                  height: 24,
                ),
                Text(context.read<ChatCubit>().currentUser.username),
                const SizedBox(
                  height: 16,
                ),
                _buildThemeSwitch(context),
                _buildLogOut(context),
                const Expanded(
                  child: SizedBox.expand(),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: PentellioText(
                    fontSize: 50,
                    text: "Pentellio",
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      duration: const Duration(milliseconds: 200),
      nextPage: ChatPanelPortrait(user: widget.user),
      onNextPage: context.read<ChatCubit>().showChatList,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              IconButton(
                onPressed: () {
                  context.read<ChatCubit>().showChatList();
                },
                icon: const Icon(Icons.arrow_back),
                splashRadius: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text("Settings"),
            ]),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: DefaultTextStyle(
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
              child: _buildSettingsList(context)),
        ),
      ),
    );
  }
}
