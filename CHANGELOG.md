
## 3.0.3
* **NEW FEATURES**: Enhanced iOS implementation with comprehensive CoreTelephony data
* Add `isSIMInserted` detection for all iOS versions
* Add `subscriberInfo` with subscriber count, identifiers, and carrier tokens
* Add `cellularPlanInfo` with dedicated eSIM support detection
* Add `networkStatus` with real-time network connectivity information
* Enhanced dual SIM support with proper subscriber counting
* Add new iOS models: `SubscriberInfo`, `CellularPlanInfo`, `NetworkStatus`
* Updated example app to showcase all new iOS features with organized sections
* Updated README with comprehensive iOS features documentation and usage examples
* Improved iOS version detection and capability handling
* All new features work across iOS versions with proper fallbacks

## 3.0.2
* **BREAKING CHANGE**: Handle CTCarrier deprecation in iOS 16.0+
* Add proper iOS version detection and fallback mechanisms
* Most carrier-specific information (carrierName, mobileCountryCode, etc.) will return nil on iOS 16.0+ due to Apple's deprecation of CTCarrier APIs
* Add comprehensive documentation about iOS 16.0+ limitations
* Radio access technology information still works as it doesn't rely on deprecated CTCarrier APIs
* Add _ios_version_info field to help developers detect iOS version and handle limitations
* Add deprecation warnings and notices in iOS implementation
* Update README with detailed iOS limitations section and technical references

## 3.0.1
* Fix JVM target compatibility issues with Java 17
* Fix Kotlin compilation errors and null safety issues
* Fix syntax errors in networkGeneration function
* Improve Android build configuration for modern Android development

## 3.0.0
* Breaking changes for android 10 and below as Telephony is no longer supported by them 
* Removal of permission checking from package, you'll need to manage permission on the mobile end 

## 2.0.8
* Breaking changes for Multi sim suport
* Syntax clean up

## 2.0.6
* Add support for Flutter 2.17.0 (Stable channel)
* Syntax clean up

## 2.0.5-beta.2.13.0
* Add support for Flutter 2.13.0 (Beta channel) [slightfoot](https://github.com/slightfoot)

## 2.0.5
* fix: request permissions before getting data from the app, added documentation for cid and lac  by [nicolaspernoud](https://github.com/nicolaspernoud)

## 2.0.4
* Merged PRs to add 5G functionality & fix permission issue

## 2.0.3
* Merged PRs to add 5G functionality & fix permission issue

## 2.0.2
* Fixed android bug
## 2.0.1
* Add pub.dev badge to readme 
* Fix compilation issue 
* bug: fix carrierName typo
* Updated Contribution section in Readme 

## 2.0.0
* Added null-saftey

## 1.0.0
* Initial release.
