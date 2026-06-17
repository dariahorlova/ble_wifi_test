#import "TechmagicWifiConnectPlugin.h"
#if __has_include(<tm_wifi_connect/tm_wifi_connect-Swift.h>)
#import <tm_wifi_connect/tm_wifi_connect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tm_wifi_connect-Swift.h"
#endif

@implementation TechmagicWifiConnectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTechmagicWifiConnectPlugin registerWithRegistrar:registrar];
}
@end
