import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final String imageUrl;
  final int index;
  final bottomIndex;
  final int selectedItem;

  const MainScreenState(
      {required this.index,
      required this.imageUrl,
      required this.bottomIndex,
      required this.selectedItem});

  const MainScreenState.initial()
      : this(imageUrl: '', index: 0, bottomIndex: 0, selectedItem: 0);

  MainScreenState copyWith(
          {String? imageUrl,
          int? index,
          int? bottomIndex,
          int? selectedItem}) =>
      MainScreenState(
          index: index ?? this.index,
          imageUrl: imageUrl ?? this.imageUrl,
          bottomIndex: bottomIndex ?? this.bottomIndex,
          selectedItem: selectedItem ?? this.selectedItem);

  @override
  // TODO: implement props
  List<Object?> get props => [index, imageUrl, bottomIndex, selectedItem];

  @override
  bool get stringify => true;
}
