## 1.3.0

* Dart sdk version upgraded.
* hasTrailingClearIcon parameter added to disable clear functionality.
* Pagination dropdown widget now can take its controller from outside aim for easy programmatically management.
* Fixes:
  * Removed an unnecessary padding for non paginated dropdowns
  * Sometimes pagination requests was triggering multiple times therefore scroll throttleDuration time increased.
  * Initial value problem fixed for paginated and future dropdowns.

## 1.2.0

* isDropdownExpanded parameter added
  * If its true dialog will be expanded all width of screen, otherwise dialog will be same size of dropdown.
* changeCompletionDelay parameter added for search trigger

## 1.1.0

* Throttle dropable added to scroll listener

## 1.0.0

* Clear dropdown after filled feature added
* Circular progress indicator changed with adaptive.
* Dynamic heights replaced with const ones
* Package dart version reduced `2.17.1` to `2.17.0`
* Package code refactored as more clean code
  
## 0.0.7

* Text overflow problem fixed
* State no longer has a context problem fixed

## 0.0.6

* On change and value properties fixed

## 0.0.5

* Formfields default isEnabled changed to true

## 0.0.4

* Missing properties added to dropdown form field

## 0.0.3

* Future and paginated requests seperated
* Gesture dedector behavior changed
* isEnabled property and disabledOnTap callback added
* Leading icon added
* Search contains method improved
* Initial value property added

## 0.0.2

* Run flutter format .
* Readme image view fixed.

## 0.0.1

* Pre-release.
