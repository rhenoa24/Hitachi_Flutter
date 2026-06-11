import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/social.dart';
import '../services/auth_service.dart';
import '../services/social_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/social_card_widget.dart';
import '../widgets/others_button.dart';
import '../widgets/popup_modal.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _showLogoutUI = false;
  bool _isLoading = true;
  List<Social> _socials = [];

  @override
  void initState() {
    super.initState();
    _loadSocials();
  }

  void _loadSocials() async {
    final socialService = Provider.of<SocialService>(context, listen: false);
    final socials = await socialService.getSocials();
    setState(() {
      _socials = socials;
      _isLoading = false;
    });
  }

  void _showLogout() {
    setState(() {
      _showLogoutUI = !_showLogoutUI;
    });
  }

  void _logout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    authService.logout();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  void _openSocial(Social social) {
    Navigator.of(context).pushNamed('/social', arguments: social);
  }

  void _openOthers() {
    Navigator.of(context).pushNamed('/others');
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final session = authService.session;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? LoadingWidget(loadingText: 'Fetching Data')
          : Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _showLogout,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                session?.profilePicture ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session?.userName ?? 'User',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                session?.userId ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 30,
                                  crossAxisSpacing: 30,
                                ),
                            itemCount: _socials.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _socials.length) {
                                final social = _socials[index];
                                return SocialCardWidget(
                                  name: social.name,
                                  imageUrl: social.iconUrl,
                                  onTap: () => _openSocial(social),
                                );
                              } else {
                                return OthersButton(onTap: _openOthers);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Logout Modal
                if (_showLogoutUI)
                  PopupModal(
                    title: '',
                    message: '',
                    isVisible: _showLogoutUI,
                    isBottom: true,
                    buttons: [
                      PopupButton(
                        label: 'Logout',
                        color: AppColors.primaryRed,
                        onPressed: _logout,
                      ),
                      PopupButton(
                        label: 'Cancel',
                        color: AppColors.primaryBlue,
                        onPressed: _showLogout,
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
