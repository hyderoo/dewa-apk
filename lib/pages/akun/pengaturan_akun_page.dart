import 'package:cached_network_image/cached_network_image.dart';
import 'package:dewa_wo_app/core/consts/app_consts.dart';
import 'package:dewa_wo_app/pages/auth/cubit/auth_cubit.dart';
import 'package:dewa_wo_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PengaturanAkunPage extends StatefulWidget {
  const PengaturanAkunPage({super.key});

  @override
  State<PengaturanAkunPage> createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String? _userAvatar;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();

    context.read<AuthCubit>().stream.listen((state) {
      if (state is AuthUnauthenticated && _isLoggingOut) {
        _isLoggingOut = false;

        if (mounted) {
          context.goNamed('home');
        }
      } else if (state is AuthAuthenticated) {
        _getUserInfo();
      }
    });
  }

  void _getUserInfo() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _userName = authState.user.fullName;
        _userEmail = authState.user.email;
        _userPhone = authState.user.phone;
        _userAvatar = authState.user.avatar;
      });
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    await context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final bool hasAvatar = _userAvatar != null && _userAvatar!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          hasAvatar
              ? CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '${AppConsts.baseUrl}$_userAvatar',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.pink[50],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.pink[300]!,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.pink[100],
                        child: Center(
                          child: _userName.isNotEmpty
                              ? Text(
                                  _userName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                )
                              : const Icon(Icons.person,
                                  size: 50, color: Colors.pink),
                        ),
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.pink[100],
                  child: _userName.isNotEmpty
                      ? Text(
                          _userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        )
                      : const Icon(Icons.person, size: 50, color: Colors.pink),
                ),
          const SizedBox(height: 16),
          Text(
            _userName.isNotEmpty ? _userName : 'User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail.isNotEmpty ? _userEmail : 'user@example.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.pink[300],
            ),
          ),
          const SizedBox(height: 4),
          if (_userPhone.isNotEmpty)
            Text(
              _userPhone,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: AppIcons.profile,
          label: 'Pengaturan Profile',
          onTap: () {
            context.pushNamed('profile').then((value) {
              _getUserInfo();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey[200],
          ),
        ),
        _buildMenuItem(
          icon: AppIcons.privacyPolicy,
          label: 'Privacy Policy',
          onTap: () {
            context.pushNamed('privacy-policy');
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey[200],
          ),
        ),
        // _buildMenuItem(
        //   icon: AppIcons.review,
        //   label: 'Beri Rating dan Review',
        //   onTap: () {
        //     _showRatingDialog(context);
        //   },
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Divider(
        //     height: 1,
        //     indent: 16,
        //     endIndent: 16,
        //     color: Colors.grey[200],
        //   ),
        // ),
        _buildMenuItem(
          icon: AppIcons.logout,
          label: 'Keluar',
          isLogout: true,
          onTap: () {
            _showLogoutConfirmation(context);
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required Function() onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24,
              color: isLogout ? Colors.red : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.red : Colors.black87,
              ),
            ),
            if (_isLoggingOut && isLogout) ...[
              const Spacer(),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beri Rating'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Berikan rating untuk aplikasi kami'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terima kasih atas penilaian Anda!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
