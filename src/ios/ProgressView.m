//
// 
//  ProgressView.m
//  Cordova ProgressView
//
//  Created by Sidney Bofah on 2014-11-20.
//

#import <Cordova/CDV.h>
#import "ProgressView.h"
#import "MRProgress.h"

@implementation ProgressView
@synthesize progressView;


- (void)pluginInitialize
{
    NSLog (@"(Cordova ProgressView) (Init) OK");
}



/**
 *  Show Dialog
 */

-(void)show:(CDVInvokedUrlCommand *)command {

    // Get Arguments
    NSString* text = [command.arguments objectAtIndex:0];
    NSString* type = [command.arguments objectAtIndex:1];

    // Set Defaults
    if ([text length] == 0) {
        text = @"Loading";
    }

    // Reset
    self.progressView = nil;

    // Show
    self.progressView = [MRProgressOverlayView showOverlayAddedTo:self.webView.window animated:YES];

    // Set Text
    self.progressView.titleLabelText = text;

    // Set Type
    if ([type isEqualToString: @"CIRCLE"]) {
        self.progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
    } else {
        self.progressView.mode = MRProgressOverlayViewModeDeterminateHorizontalBar;
    }

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Show) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  Hide Dialog
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
    if (!self.progressView) {

        // Callback (Error)
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(Cordova ProgressView) (Hide) ERROR: No dialog to hide."];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    // Hide
    [MRProgressOverlayView dismissOverlayForView:self.webView.window animated:YES];

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Hide) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  Set Progress
 */

- (void)setProgress:(CDVInvokedUrlCommand*)command
{
    // Get Arguments
    NSNumber* _progress = nil;

    // Massage types
    _progress = [command.arguments objectAtIndex:0];
    float progress = [_progress floatValue];

    // Set Progress
    [self.progressView setProgress:progress animated:YES];

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Set) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end