import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';
import 'package:line/widgets/app_text_field_form_field.dart';

class MyProfileEditForm extends StatefulWidget {
  final AuthRepository authRepo;
  const MyProfileEditForm({super.key, required this.authRepo});

  @override
  State<MyProfileEditForm> createState() => _MyProfileEditFormState();
}

class _MyProfileEditFormState extends State<MyProfileEditForm> {
  late final FirebaseFirestore _db;
  late final UserRepository _userRepo;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _userRepo = UserRepository(_db);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameFieldKey = GlobalKey<FormFieldState<String>>();
    final mailFieldKey = GlobalKey<FormFieldState<String>>();
    final userCodeFieldKey = GlobalKey<FormFieldState<String>>();

    final currentUser = widget.authRepo.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('プロフィールを編集')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 32),
              AppTextFormField(
                fieldKey: nameFieldKey,
                initialValue: currentUser.name,
                hint: '氏名',
                label: '氏名',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "必須です";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppTextFormField(
                fieldKey: mailFieldKey,
                initialValue: currentUser.mail,
                hint: 'メールアドレス',
                label: 'メールアドレス',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "必須です";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppTextFormField(
                fieldKey: userCodeFieldKey,
                initialValue: currentUser.userCode,
                hint: '検索用コード',
                label: '検索用コード',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "必須です";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  try {
                    await _userRepo.editMyprofile(
                      widget.authRepo.currentUser!.id,
                      nameFieldKey.currentState!.value!,
                      mailFieldKey.currentState!.value!,
                      userCodeFieldKey.currentState!.value!,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('プロフィールの変更に失敗しました')),
                      );
                    }
                  }
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text("更新"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
