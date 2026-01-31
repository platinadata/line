import 'package:flutter/material.dart';
import 'package:line/app.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';

class FindUserContainer extends StatelessWidget {
  final User user;
  final AuthRepository authRepo;
  final UserRepository userRepo;
  const FindUserContainer({
    super.key,
    required this.user,
    required this.authRepo,
    required this.userRepo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  user.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_reaction_outlined),
                onPressed: () async {
                  await userRepo.createMatching(
                    authRepo.currentUser!.id,
                    user.id,
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MyApp()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
