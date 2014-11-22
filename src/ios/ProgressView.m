#import <Cordova/CDV.h>
#import "ProgressView.h"
#import "MBProgressHUD.h"

@implementation ProgressView
@synthesize progressView;


- (void)pluginInitialize
{
    NSLog (@"(ProgressView) Init");
}


/**
 *  DETERMINATE with LABEL
 */

-(void)showDeterminateWithLabel:(CDVInvokedUrlCommand *)command {
    
    // Get Arguments
    NSString* text = [command.arguments objectAtIndex:0];
    
    // Show
    self.progressView = nil;
    self.progressView = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    
    // Config
    self.progressView.mode = MBProgressHUDModeDeterminate;
    self.progressView.labelText = text;
    self.progressView.dimBackground = YES;
    
    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(ProgressView) (Circle) Show"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * DETERMINATE BAR with LABEL
 */

- (void)showDeterminateBarWithLabel:(CDVInvokedUrlCommand *)command {
    
    // Get Arguments
    NSString* text = [command.arguments objectAtIndex:0];
    
    // Show
    self.progressView = nil;
    self.progressView = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    
    // Config
    self.progressView.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.progressView.labelText = text;
    self.progressView.dimBackground = YES;
    
    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(ProgressView) (Bar) Show"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


/**
 * HIDE
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
	if (!self.progressView) {
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(ProgressView) (Hide) Does not exist."];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	[self.progressView hide:YES];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(ProgressView) (Hide)"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


/**
 * PROGRESS
 */

- (void)setProgress:(float)progress{
    
    // get value
    int _progress = [progress intValue];
    
    // Some blocking logic...
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        self.progressView.progress = _progress;
        // Hide
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView hideHUDForView:self.webView.superview animated:YES];
        });
    });    
        
}

@end
