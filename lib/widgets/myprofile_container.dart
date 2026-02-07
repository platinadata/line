import 'package:flutter/material.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/screens/myprofile_edit_form.dart';

class MyprofileContainer extends StatelessWidget {
  final AuthRepository authRepo;
  const MyprofileContainer({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => MyProfileEditForm(authRepo: authRepo)),
            ),
          );
        },
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      authRepo.currentUser!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        authRepo.currentUser!.profileImageUrl,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
