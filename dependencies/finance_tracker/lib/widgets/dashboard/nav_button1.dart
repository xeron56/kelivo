import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/providers/theme_provider.dart';

class NavButton1 extends StatelessWidget {
  const NavButton1({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  final Function onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 1,
      color: themeProvider.primary800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          height: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18, color: themeProvider.white),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                color: themeProvider.white,
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}

