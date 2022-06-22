import 'package:flutter/material.dart';

import '../searchable_dropdown.dart';

// ignore: must_be_immutable
class SearchableDropdownFormField<T> extends FormField<T> {
  ///Hint text shown when the dropdown is empty
  final Widget? hintText;

  ///Background decoration of dropdown, i.e. with this you can wrap dropdown with Card
  final Widget Function(Widget child)? backgroundDecoration;

  ///Validation Error widget which is shown under dropdown
  final Widget Function(String? errorText)? errorWidget;

  ///Shwons if there is no record found
  final Widget? noRecordText;

  ///Dropdown trailing icon
  final Widget? icon;

  ///Searchbar hint text
  final String? searchHintText;

  ///Dropdowns margin padding with other widgets
  final EdgeInsetsGeometry? margin;

  ///Returns selected Item
  final void Function(T? value)? onChanged;

  ///Dropdown items
  List<SearchableDropdownMenuItem<T>>? items;

  ///Paginated or normal request service which is returns DropdownMenuItem list
  Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? key)? getRequest;

  ///Paginated request item count which returns in one page, this value is using for knowledge about isDropdown has more item or not.
  int? requestItemCount;

  SearchableDropdownFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    this.hintText,
    this.margin,
    required this.items,
    this.errorWidget,
    this.backgroundDecoration,
    this.onChanged,
    this.noRecordText,
    this.icon,
    this.searchHintText,
  }) : super(
          builder: (FormFieldState<T> state) {
            return Padding(
              padding: margin ?? const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchableDropdown<T>(
                    backgroundDecoration: backgroundDecoration,
                    hintText: hintText,
                    margin: EdgeInsets.zero,
                    items: items,
                    onChanged: (value) {
                      state.didChange(value);
                    },
                  ),
                  if (state.hasError)
                    errorWidget != null
                        ? errorWidget(state.errorText)
                        : Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              state.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                ],
              ),
            );
          },
        );

  SearchableDropdownFormField.paginated({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    this.hintText,
    this.margin,
    required this.getRequest,
    this.requestItemCount,
    this.errorWidget,
    this.backgroundDecoration,
    this.onChanged,
    this.noRecordText,
    this.icon,
    this.searchHintText,
  }) : super(
          builder: (FormFieldState<T> state) {
            return Padding(
              padding: margin ?? const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchableDropdown<T>.paginated(
                    backgroundDecoration: backgroundDecoration,
                    hintText: hintText,
                    margin: EdgeInsets.zero,
                    requestItemCount: requestItemCount,
                    getRequest: getRequest,
                    onChanged: (value) {
                      state.didChange(value);
                    },
                  ),
                  if (state.hasError)
                    errorWidget != null
                        ? errorWidget(state.errorText)
                        : Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              state.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                ],
              ),
            );
          },
        );
}
