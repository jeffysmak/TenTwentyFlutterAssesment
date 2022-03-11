import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeatPattern {
  int index;
  List<SeatEnum?> seatPattern;

  SeatPattern(this.index, this.seatPattern);

  static Widget widgetBySeatEnum(int i, SeatEnum? enuma) {
    if (enuma != null && enuma == SeatEnum.digit) {
      return Text('$i', style: TextStyle(color: colorBySeatEnum(enuma)));
    }
    return SvgPicture.asset('assets/seat.svg', color: colorBySeatEnum(enuma));
  }

  static Color colorBySeatEnum(SeatEnum? enuma) {
    if (enuma == null) return Colors.transparent;
    switch (enuma) {
      case SeatEnum.selected:
        return Color(0x0ffCD9D0F);
      case SeatEnum.na:
        return Color(0x0ffA6A6A6).withOpacity(0.5);
      case SeatEnum.vip:
        return Color(0x0ff564CA3);
      case SeatEnum.reg:
        return Color(0x0ff61C3F2);
      case SeatEnum.digit:
        return Colors.black45;
      default:
        return Colors.transparent;
    }
  }
}

enum SeatEnum { selected, na, vip, reg, digit }
