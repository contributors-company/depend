import 'package:depend/depend.dart';
import 'package:flutter/cupertino.dart';

extension DependencyContext on BuildContext {
  T depend<T extends DependencyContainer<Object?>>() => DependencyProvider.of<T>(this);

  T? maybeDepend<T extends DependencyContainer<Object?>>() => DependencyProvider.maybeOf<T>(this);


}