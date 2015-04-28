/****************************************
 *
 *  ProgressView.m
 *  Cordova ProgressView
 *
 *  Created by Sidney Bofah on 2014-12-01.
 *
 ****************************************/

#import <Cordova/CDV.h>
#import <M13Progress/M13Progress.h>
#import "ProgressView.h"
#import "AppDelegate.h"

@implementation ProgressView{
    
}


/**
 *  MACRO
 */

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

/**
 *  CONSTANT
 */

static NSString *const _PROGRESSVIEW_STYLE_HORIZONTAL = @"BAR";
static NSString *const _PROGRESSVIEW_STYLE_CIRCLE = @"CIRCLE";
static const double _PROGRESSVIEW_UPDATE_INTERVAL = 1.5;


/**
 *  INIT
 */

- (void)pluginInitialize
{
    NSLog (@"(Cordova ProgressView) (Init) OK");
};


/***************************
 *  PUBLIC METHODS
 ***************************/

/**
 *  Show Dialog
 */

-(void)show:(CDVInvokedUrlCommand *)command {

    if (_isVisible == NULL || _isVisible == NO) {
        // Get Arguments
        NSString* label = [command.arguments objectAtIndex:0];
        NSString* shape = [command.arguments objectAtIndex:1];
        NSString* Indet = [command.arguments objectAtIndex:2];
        
        BOOL isIndeterminate = [[command.arguments objectAtIndex:2] boolValue];
        
        // [self.commandDelegate runInBackground:^{
        
        // Set Style
        [self showView:label isIndeterminate:isIndeterminate isShape:shape isVisible:YES];
        
        // Callback
        CDVPluginResult* pluginResult;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Show) OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
        //}];
        _isVisible = YES;
    }
};


/**
 *  Set Progress
 */

- (void)setProgress:(CDVInvokedUrlCommand*)command
{
    // Init
    CDVPluginResult* pluginResult = nil;

    // Get Arguments
    CGFloat progress = [[command.arguments objectAtIndex:0] floatValue];

    // Execute
    [self updateProgress:progress];

    // Callback
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setProgress) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
};


/**
 *  Set Label
 */

- (void)setLabel:(CDVInvokedUrlCommand*)command
{
    // Init
    CDVPluginResult* pluginResult = nil;

    NSString* label = [command.arguments objectAtIndex:0];

    // Execute
    [self updateLabel:label];

    // Callback
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setLabel) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
};


/**
 *  Hide
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
    if (_isVisible == YES) {
        // Init
        CDVPluginResult* pluginResult;
        
        [self performSelector:@selector(removeView)
                   withObject:nil
                   afterDelay:_PROGRESSVIEW_UPDATE_INTERVAL];
        
        // Callback
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Hide) OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        _isVisible = NO;
    }
};



/***************************
 *  PRIVATE METHODS
 ***************************/


- (void)updateProgress:(CGFloat)progress
{

    [_progressView setProgress:progress animated:YES];
};


- (void)updateLabel:(NSString *)viewLabel
{

    _progressView.status = viewLabel;
};


- (void)showView:(NSString *)viewLabel isIndeterminate:(BOOL)isIndeterminate isShape:(NSString *)shape isVisible:(BOOL)isVisible
{

    if ([shape isEqualToString:_PROGRESSVIEW_STYLE_HORIZONTAL]){
        
        _progressView = [[M13ProgressHUD alloc] initWithProgressView: [[M13ProgressViewBar alloc] init]];
        _progressView.statusPosition = M13ProgressViewBarPercentagePositionTop;
        
    } else {
        
        _progressView = [[M13ProgressHUD alloc] initWithProgressView: [[M13ProgressViewRing alloc] init]];
        _progressView.statusPosition = M13ProgressHUDStatusPositionBelowProgress;
        
    }
    
    [self updateProgress: _progressDefault];
    _progressView.status = viewLabel;
    _progressView.maskType = M13ProgressHUDMaskTypeSolidColor;
    _progressView.indeterminate = isIndeterminate;
    _progressView.progressViewSize = CGSizeMake(100.0, 100.0);
    _progressView.animationPoint = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    [self.webView addSubview: _progressView];
    [_progressView show:true];


};


- (void)removeView
{
    [_progressView dismiss:YES];
};


@end