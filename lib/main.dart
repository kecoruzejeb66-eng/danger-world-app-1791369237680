import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DangerWorldSecurityApp());
}

class DangerWorldSecurityApp extends StatelessWidget {
  const DangerWorldSecurityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danger World Security',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFD32F2F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD32F2F),
          secondary: Color(0xFFE53935),
          surface: Color(0xFF141414),
          background: Color(0xFF0A0A0A),
          error: Color(0xFFB71C1C),
        ),
      ),
      home: const PinLockScreen(),
    );
  }
}

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({Key? key}) : super(key: key);

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _enteredPin = '';
  final String _correctPin = '1984';
  bool _isError = false;

  void _onNumberTap(String number) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
        _isError = false;
      });

      if (_enteredPin.length == 4) {
        if (_enteredPin == _correctPin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LauncherHomeScreen()),
          );
        } else {
          setState(() {
            _isError = true;
          });
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              setState(() {
                _enteredPin = '';
                _isError = false;
              });
            }
          });
        }
      }
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security,
              size: 64,
              color: Color(0xFFD32F2F),
            ),
            const SizedBox(height: 16),
            const Text(
              'DANGER WORLD SECURITY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter PIN (Default: 1984)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool filled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled
                        ? (_isError ? Colors.redAccent : const Color(0xFFD32F2F))
                        : Colors.transparent,
                    border: Border.all(
                      color: _isError ? Colors.redAccent : const Color(0xFFD32F2F),
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            ...List.generate(3, (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (colIndex) {
                    int number = rowIndex * 3 + colIndex + 1;
                    return _buildKeypadButton(number.toString());
                  }),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 80, height: 80),
                  _buildKeypadButton('0'),
                  Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.backspace, color: Colors.white70),
                      onPressed: _onDeleteTap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String text) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          side: const BorderSide(color: Color(0xFF333333)),
        ),
        onPressed: () => _onNumberTap(text),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class LauncherHomeScreen extends StatefulWidget {
  const LauncherHomeScreen({Key? key}) : super(key: key);

  @override
  State<LauncherHomeScreen> createState() => _LauncherHomeScreenState();
}

class _LauncherHomeScreenState extends State<LauncherHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardTab(),
    ShieldTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: const Row(
          children: [
            Icon(Icons.shield, color: Color(0xFFD32F2F)),
            SizedBox(width: 8),
            Text(
              'DANGER WORLD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock, color: Colors.grey),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PinLockScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Shield',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({Key? key}) : super(key: key);

  void _triggerPanic(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('PANIC ACTIVATED', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: const Text(
            'Emergency protocols engaged. Location broadcasted. Local sirens triggered.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('STAND DOWN'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Panic mode disengaged.'),
                    backgroundColor: Colors.grey,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2B0000), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'SYSTEM STATUS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ARMED & SECURE',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _triggerPanic(context),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFFE53935), Color(0xFFB71C1C), Color(0xFF5F0000)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'PANIC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap to broadcast emergency distress signal',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard(Icons.videocam, 'Live Feed', 'Offline'),
              _buildActionCard(Icons.gps_fixed, 'Geo-Fence', 'Active'),
              _buildActionCard(Icons.lock_outline, 'Vault', 'Locked'),
              _buildActionCard(Icons.cell_tower, 'Signal Jammer', 'Ready'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFD32F2F)),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ShieldTab extends StatefulWidget {
  const ShieldTab({Key? key}) : super(key: key);

  @override
  State<ShieldTab> createState() => _ShieldTabState();
}

class _ShieldTabState extends State<ShieldTab> {
  bool _stealthMode = false;
  bool _biometricLock = true;
  bool _networkDefense = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'SECURITY MODULES',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Stealth Cloaking'),
          subtitle: const Text('Hide launcher traces from app switcher'),
          value: _stealthMode,
          activeColor: const Color(0xFFD32F2F),
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onChanged: (bool value) {
            setState(() {
              _stealthMode = value;
            });
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Biometric Override'),
          subtitle: const Text('Require fingerprint for deep settings'),
          value: _biometricLock,
          activeColor: const Color(0xFFD32F2F),
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onChanged: (bool value) {
            setState(() {
              _biometricLock = value;
            });
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Active Network Defense'),
          subtitle: const Text('Block unauthorized packet sniffers'),
          value: _networkDefense,
          activeColor: const Color(0xFFD32F2F),
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onChanged: (bool value) {
            setState(() {
              _networkDefense = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'DIAGNOSTICS',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF222222)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Threat Level: ZERO', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Encrypted Packets: 1,429 sent', style: TextStyle(color: Colors.white70, fontSize: 12)),
              SizedBox(height: 4),
              Text('Firewall Integrity: 100%', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'PREFERENCES',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Change PIN Code'),
          subtitle: const Text('Update primary security access code'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN modification locked by admin policy.')),
            );
          },
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Emergency Contacts'),
          subtitle: const Text('Manage automated broadcast numbers'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {},
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Theme Color'),
          subtitle: const Text('Crimson Red & Deep Black (Default)'),
          trailing: const Icon(Icons.palette, size: 18, color: Color(0xFFD32F2F)),
          onTap: () {},
        ),
        const SizedBox(height: 24),
        const Text(
          'ABOUT',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          tileColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Danger World Security Core'),
          subtitle: const Text('Version 4.0.2-RELEASE'),
        ),
      ],
    );
  }
}