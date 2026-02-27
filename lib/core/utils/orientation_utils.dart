import 'package:flutter/material.dart';

/// Returns true if the device is in landscape mode
bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.landscape;

/// Returns a value based on orientation
T orientationValue<T>(BuildContext context,
    {required T portrait, required T landscape}) =>
    isLandscape(context) ? landscape : portrait;