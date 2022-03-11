import 'package:flutter/material.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';

class OutlineThemedButton extends StatelessWidget {
  Function onTap;
  IconData? iconData;
  String title;
  double? padding;
  Color? color;

  OutlineThemedButton({
    required this.onTap,
    this.iconData,
    required this.title,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
          side: BorderSide(color: AppThemeNotifier.definedColor4, width: 2),
        ),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null) ...[
                Icon(iconData, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: padding ?? 0),
                  child: Text(title, style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary), textAlign: TextAlign.center),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: padding ?? 0),
                  child: Text(title, style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary), textAlign: TextAlign.center),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
