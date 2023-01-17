import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.pentellioUser});

  final PentellioUser pentellioUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ChatCubit>().closeSearching();
        context.read<ChatCubit>().createAndOpenChat(pentellioUser);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(double.infinity, 70)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  strokeAlign: StrokeAlign.center,
                  width: 0.05)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                RoundedRect(
                  50,
                  child: pentellioUser.profilePictureUrl.isNotEmpty
                      ? CachedNetworkImage(
                          cacheManager: kIsWeb ? null : context.read(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageUrl: pentellioUser.profilePictureUrl,
                        )
                      : ColoredBox(color: Theme.of(context).indicatorColor),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            pentellioUser.username,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
