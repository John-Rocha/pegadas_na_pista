import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Entrar')),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthAuthenticated) {
              context.go('/');
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            final isLoading = state is AuthLoading;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => cubit.signIn(
                            email: _emailController.text.trim(),
                            senha: _senhaController.text,
                          ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
