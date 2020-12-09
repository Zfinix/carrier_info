#import "CarrierInfoPlugin.h"
#if __has_include(<carrier_info/carrier_info-Swift.h>)
#import <carrier_info/carrier_info-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "carrier_info-Swift.h"
#endif

@implementation CarrierInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCarrierInfoPlugin registerWithRegistrar:registrar];
}
@end
