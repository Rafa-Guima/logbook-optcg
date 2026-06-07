import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;

  final user = FirebaseAuth.instance.currentUser;

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  // DIÁLOGO PARA MUDAR O NICKNAME
  Future<void> _changeNickname() async {
    final controller = TextEditingController(text: user?.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Alterar Nickname', style: TextStyle(color: AppColors.textDark)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textDark),
          decoration: const InputDecoration(labelText: 'Novo Nickname'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != user?.displayName) {
      try {
        await user?.updateDisplayName(newName);
        setState(() {}); // Atualiza o ecrã com o novo nome
        _showSnackBar('Nickname atualizado com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao atualizar nickname.', isError: true);
      }
    }
  }

  // DIÁLOGO PARA MUDAR O E-MAIL (Exige senha atual)
  Future<void> _changeEmail() async {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Alterar E-mail', style: TextStyle(color: AppColors.textDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              style: const TextStyle(color: AppColors.textDark),
              decoration: const InputDecoration(labelText: 'Novo E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              style: const TextStyle(color: AppColors.textDark),
              decoration: const InputDecoration(labelText: 'Senha atual (para confirmar)'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'email': emailController.text.trim(),
              'pass': passController.text.trim(),
            }),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result['email']!.isNotEmpty && result['pass']!.isNotEmpty) {
      try {
        // Reautenticar o utilizador antes de mudar dados sensíveis
        final cred = EmailAuthProvider.credential(email: user!.email!, password: result['pass']!);
        await user?.reauthenticateWithCredential(cred);
        
        // Atualizar e-mail
        await user?.verifyBeforeUpdateEmail(result['email']!);
        _showSnackBar('Link de verificação enviado para o novo e-mail!');
      } catch (e) {
        _showSnackBar('Erro ao atualizar e-mail. Verifique a sua senha.', isError: true);
      }
    }
  }

  // DIÁLOGO PARA MUDAR A SENHA (Exige senha atual)
  Future<void> _changePassword() async {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Alterar Senha', style: TextStyle(color: AppColors.textDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              style: const TextStyle(color: AppColors.textDark),
              decoration: const InputDecoration(labelText: 'Senha atual'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPassController,
              style: const TextStyle(color: AppColors.textDark),
              decoration: const InputDecoration(labelText: 'Nova senha'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'old': oldPassController.text.trim(),
              'new': newPassController.text.trim(),
            }),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result['old']!.isNotEmpty && result['new']!.isNotEmpty) {
      try {
        // Reautenticar
        final cred = EmailAuthProvider.credential(email: user!.email!, password: result['old']!);
        await user?.reauthenticateWithCredential(cred);
        
        // Atualizar senha
        await user?.updatePassword(result['new']!);
        _showSnackBar('Senha atualizada com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao atualizar senha. Verifique a senha atual.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfaceDark,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: () {
                        _showSnackBar('A funcionalidade de foto será ligada ao Firebase Storage em breve!');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Alterar Nickname'),
            subtitle: Text(user?.displayName ?? 'Sem nickname definido'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeNickname,
          ),
          ListTile(
            title: const Text('Alterar E-mail'),
            subtitle: Text(user?.email ?? 'Sem e-mail'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeEmail,
          ),
          ListTile(
            title: const Text('Alterar Senha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),
          const Divider(height: 32),
          Text('Preferências', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _isDarkMode = val);
            },
          ),
          SwitchListTile(
            title: const Text('Notificações Push (Alertas de Preço)'),
            value: _notificationsEnabled,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
          ),
        ],
      ),
    );
  }
}