import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class Margin {
  static EdgeInsets all(context, {double grid = 24, double def = 0}) {
    EdgeInsets margin = EdgeInsets.all(def);

    if (Device.get().isTablet) {
      margin = EdgeInsets.all(MediaQuery.of(context).size.width / grid);
    }
    return margin;
  }

  static double margin(context, {double grid = 24, double def = 0}) {
    double margin = def;

    if (Device.get().isTablet) {
      margin = MediaQuery.of(context).size.width / grid;
    }
    return margin;
  }
}

class FontSize {
  static double h1() {
    double size = 22;
    if (Device.get().isTablet) size += 4;
    return size;
  }

  static double h2() {
    double size = 20;
    if (Device.get().isTablet) size += 4;
    return size;
  }

  static double body() {
    double size = 14;
    if (Device.get().isTablet) size += 4;
    return size;
  }

  static double small() {
    double size = 10;
    if (Device.get().isTablet) size += 4;
    return size;
  }

  static double subtitle() {
    double size = 16;
    if (Device.get().isTablet) size += 4;
    return size;
  }
}

class Size {
  static double groupImageSize() {
    double size = 80;
    if (Device.get().isTablet) size = 120;
    return size;
  }

  static double userImageSize() {
    double size = 60;
    if (Device.get().isTablet) size = 120;
    return size;
  }

  static double userImageLarge() {
    double size = 160;
    if (Device.get().isTablet) size = 400;
    return size;
  }

  static double iconSize() {
    double size = 20;
    if (Device.get().isTablet) size = 30;
    return size;
  }
}
