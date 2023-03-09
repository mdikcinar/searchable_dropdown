import 'package:flutter/material.dart';

import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

@immutable
class SearchableDropdownFormField<T> extends FormField<T> {
  SearchableDropdownFormField({
    required List<SearchableDropdownMenuItem<T>>? items,
    Key? key,
    void Function(T?)? onSaved,
    String? Function(T?)? validator,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    Widget? hintText,
    EdgeInsetsGeometry? margin,
    T? value,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
    Widget Function(String?)? errorWidget,
    Widget Function(Widget)? backgroundDecoration,
    void Function(T?)? onChanged,
    Widget? noRecordTex,
    Widget? trailingIcon,
    Widget? trailingClearIcon,
    Widget? leadingIcon,
    String? searchHintText,
    double? dropDownMaxHeight,
  }) : this._(
          items: items,
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          hintText: hintText,
          margin: margin,
          value: value,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
          errorWidget: errorWidget,
          backgroundDecoration: backgroundDecoration,
          onChanged: onChanged,
          noRecordText: noRecordTex,
          trailingIcon: trailingIcon,
          trailingClearIcon: trailingClearIcon,
          leadingIcon: leadingIcon,
          searchHintText: searchHintText,
          dropDownMaxHeight: dropDownMaxHeight,
        );

  SearchableDropdownFormField.paginated({
    required Future<List<SearchableDropdownMenuItem<T>>?> Function(int, String?)? paginatedRequest,
    int? requestItemCount,
    Key? key,
    void Function(T?)? onSaved,
    String? Function(T?)? validator,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    Widget? hintText,
    EdgeInsetsGeometry? margin,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
    Widget Function(String?)? errorWidget,
    Widget Function(Widget)? backgroundDecoration,
    void Function(T?)? onChanged,
    Widget? noRecordTex,
    Widget? trailingIcon,
    Widget? trailingClearIcon,
    Widget? leadingIcon,
    String? searchHintText,
    double? dropDownMaxHeight,
  }) : this._(
          paginatedRequest: paginatedRequest,
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          hintText: hintText,
          margin: margin,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
          errorWidget: errorWidget,
          backgroundDecoration: backgroundDecoration,
          onChanged: onChanged,
          noRecordText: noRecordTex,
          trailingIcon: trailingIcon,
          trailingClearIcon: trailingClearIcon,
          leadingIcon: leadingIcon,
          searchHintText: searchHintText,
          dropDownMaxHeight: dropDownMaxHeight,
          requestItemCount: requestItemCount,
        );

  SearchableDropdownFormField.future({
    required Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest,
    Key? key,
    void Function(T?)? onSaved,
    String? Function(T?)? validator,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    Widget? hintText,
    EdgeInsetsGeometry? margin,
    bool isEnabled = true,
    VoidCallback? disabledOnTap,
    Widget Function(String?)? errorWidget,
    Widget Function(Widget)? backgroundDecoration,
    void Function(T?)? onChanged,
    Widget? noRecordTex,
    Widget? trailingIcon,
    Widget? trailingClearIcon,
    Widget? leadingIcon,
    String? searchHintText,
    double? dropDownMaxHeight,
  }) : this._(
          futureRequest: futureRequest,
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          hintText: hintText,
          margin: margin,
          isEnabled: isEnabled,
          disabledOnTap: disabledOnTap,
          errorWidget: errorWidget,
          backgroundDecoration: backgroundDecoration,
          onChanged: onChanged,
          noRecordText: noRecordTex,
          trailingIcon: trailingIcon,
          trailingClearIcon: trailingClearIcon,
          leadingIcon: leadingIcon,
          searchHintText: searchHintText,
          dropDownMaxHeight: dropDownMaxHeight,
        );

  SearchableDropdownFormField._({
    this.items,
    this.futureRequest,
    this.paginatedRequest,
    this.requestItemCount,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    this.hintText,
    this.margin,
    this.value,
    this.isEnabled = true,
    this.disabledOnTap,
    this.errorWidget,
    this.backgroundDecoration,
    this.onChanged,
    this.noRecordText,
    this.trailingIcon,
    this.trailingClearIcon,
    this.leadingIcon,
    this.searchHintText,
    this.dropDownMaxHeight,
  }) : super(
          builder: (FormFieldState<T> state) {
            return Padding(
              padding: margin ?? const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (items != null)
                    SearchableDropdown<T>(
                      key: key,
                      backgroundDecoration: backgroundDecoration,
                      hintText: hintText,
                      margin: EdgeInsets.zero,
                      leadingIcon: leadingIcon,
                      trailingIcon: trailingIcon,
                      trailingClearIcon: trailingClearIcon,
                      noRecordText: noRecordText,
                      dropDownMaxHeight: dropDownMaxHeight,
                      searchHintText: searchHintText,
                      isEnabled: isEnabled,
                      disabledOnTap: disabledOnTap,
                      items: items,
                      value: value,
                      onChanged: (value) {
                        state.didChange(value);
                        if (onChanged != null) onChanged(value);
                      },
                    ),
                  if (paginatedRequest != null)
                    SearchableDropdown<T>.paginated(
                      paginatedRequest: paginatedRequest,
                      requestItemCount: requestItemCount,
                      key: key,
                      backgroundDecoration: backgroundDecoration,
                      hintText: hintText,
                      margin: EdgeInsets.zero,
                      leadingIcon: leadingIcon,
                      trailingIcon: trailingIcon,
                      trailingClearIcon: trailingClearIcon,
                      noRecordText: noRecordText,
                      dropDownMaxHeight: dropDownMaxHeight,
                      searchHintText: searchHintText,
                      isEnabled: isEnabled,
                      disabledOnTap: disabledOnTap,
                      onChanged: (value) {
                        state.didChange(value);
                        if (onChanged != null) onChanged(value);
                      },
                    ),
                  if (futureRequest != null)
                    SearchableDropdown<T>.future(
                      futureRequest: futureRequest,
                      key: key,
                      backgroundDecoration: backgroundDecoration,
                      hintText: hintText,
                      margin: EdgeInsets.zero,
                      leadingIcon: leadingIcon,
                      trailingIcon: trailingIcon,
                      trailingClearIcon: trailingClearIcon,
                      noRecordText: noRecordText,
                      dropDownMaxHeight: dropDownMaxHeight,
                      searchHintText: searchHintText,
                      isEnabled: isEnabled,
                      disabledOnTap: disabledOnTap,
                      onChanged: (value) {
                        state.didChange(value);
                        if (onChanged != null) onChanged(value);
                      },
                    ),
                  if (state.hasError)
                    errorWidget != null
                        ? errorWidget(state.errorText)
                        : Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              state.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                ],
              ),
            );
          },
        );
  //Is dropdown enabled
  final bool isEnabled;

  /// Height of dropdown's dialog, default: MediaQuery.of(context).size.height*0.3.
  final double? dropDownMaxHeight;

  /// Dropdowns margin padding with other widgets.
  final EdgeInsetsGeometry? margin;

  /// Future service which is returns DropdownMenuItem list.
  final Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;

  /// Paginated request service which is returns DropdownMenuItem list.
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? searchKey)? paginatedRequest;

  /// Paginated request item count which returns in one page, this value is using for knowledge about isDropdown has more item or not.
  final int? requestItemCount;

  /// Dropdown items.
  final List<SearchableDropdownMenuItem<T>>? items;

  /// SearchBar hint text.
  final String? searchHintText;

  //Initial value of dropdown
  final T? value;

  //Triggers this function if dropdown pressed while disabled
  final VoidCallback? disabledOnTap;

  /// Returns selected Item.
  final void Function(T? value)? onChanged;

  /// Hint text shown when the dropdown is empty.
  final Widget? hintText;

  /// Shows if there is no record found.
  final Widget? noRecordText;

  /// Dropdown trailing icon.
  final Widget? trailingIcon;

  /// Dropdown trailing clear icon that clears current selected value.
  final Widget? trailingClearIcon;

  /// Dropdown trailing icon.
  final Widget? leadingIcon;

  /// Validation Error widget which is shown under dropdown.
  final Widget Function(String? errorText)? errorWidget;

  /// Background decoration of dropdown, i.e. with this you can wrap dropdown with Card.
  final Widget Function(Widget child)? backgroundDecoration;
}
