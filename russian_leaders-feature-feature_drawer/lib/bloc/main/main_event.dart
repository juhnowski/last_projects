import 'package:equatable/equatable.dart';
import 'package:russian_leaders/model/drawer_items.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class DrawerItemChosen extends MainEvent {
  final DrawerItem itemSelected;

  DrawerItemChosen(this.itemSelected);

  @override
  List<Object> get props => [itemSelected];

  @override
  String toString() => "DrawerItemChosen { itemSelected: $itemSelected}";
}
