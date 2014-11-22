#import <Cordova/CDV.h>
#import "MBProgressHUD.h"

@interface ProgressView: CDVPlugin {
}

@property (nonatomic, assign) MBProgressHUD* progressView;

- (void)show:(CDVInvokedUrlCommand*)command;
- (void)setProgress:(CDVInvokedUrlCommand*)command;
- (void)hide:(CDVInvokedUrlCommand*)command;

@end