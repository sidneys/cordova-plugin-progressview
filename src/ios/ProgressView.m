/****************************************
 *
 *  ProgressView.m
 *  Cordova ProgressView
 *
 *  Created by Sidney Bofah on 2014-11-20.
 *
 ****************************************/

#import <Cordova/CDV.h>
#import <MRProgress/MRProgress.h>
#import "ProgressView.h"

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

    // Check State
    if ((self.progressView) || ([[MRProgressOverlayView allOverlaysForView:self.webView.window] count])) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(Cordova ProgressView) (Show) ERROR: Dialog already showing"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    // Get Arguments
    NSString* label = [command.arguments objectAtIndex:0];
    NSString* shape = [command.arguments objectAtIndex:1];
    BOOL indeterminate = [[command.arguments objectAtIndex:2] boolValue];
    // Set Defaults
    if ([label length] == 0) {
        label = @" ";
    }


    // Reset
    self.progressView = nil;

    // Show
    self.progressView = [MRProgressOverlayView showOverlayAddedTo:self.webView.window animated:YES];

    // Set Label
    self.progressView.titleLabelText = label;

    // Set Shape & Type
    if (([shape isEqualToString: @"CIRCLE"])) {
        if (indeterminate == true) {
            self.progressView.mode = MRProgressOverlayViewModeIndeterminate;
        } else {
            self.progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
        }
    } else if ([shape isEqualToString: @"BAR"]) {
        if (indeterminate == true) {
            self.progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
        } else {
            self.progressView.mode = MRProgressOverlayViewModeDeterminateHorizontalBar;
        }
    }

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Show) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  Set Progress
 */

- (void)setProgress:(CDVInvokedUrlCommand*)command
{
    // Check State
    if ((!self.progressView) || (![[MRProgressOverlayView allOverlaysForView:self.webView.window] count])) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(Cordova ProgressView) (setProgress) ERROR: No dialog to update"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    // Get Arguments
    NSNumber* _progress = [command.arguments objectAtIndex:0];

    // Convert variable number types
    float progress = [_progress floatValue];

    // Update Progress
    [self.progressView setProgress:progress animated:YES];

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setProgress) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  Set Label
 */

- (void)setLabel:(CDVInvokedUrlCommand*)command
{
    // Check State
    if ((!self.progressView) || (![[MRProgressOverlayView allOverlaysForView:self.webView.window] count])) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(Cordova ProgressView) (setLabel) ERROR: No dialog to update."];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    // Get Arguments
    NSString* label = [command.arguments objectAtIndex:0];

    // Update Label
    if ([label length] == 0) {
        label = @" ";
    }
    self.progressView.titleLabelText = label;

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setLabel) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  Hide
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
    // Check State
    if ((!self.progressView) || (![[MRProgressOverlayView allOverlaysForView:self.webView.window] count])) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"(Cordova ProgressView) (Hide) ERROR: No dialog to hide"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    // Hide
    [MRProgressOverlayView dismissOverlayForView:self.webView.window animated:YES];
    self.progressView = nil;

    // Callback
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Hide) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



@end