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

    [self.commandDelegate runInBackground:^{
        [self createView];
    }];
};


/***************************
 *  PUBLIC
 ***************************/

/**
 *  Show Dialog
 */

-(void)show:(CDVInvokedUrlCommand *)command {

    // Init
    CDVPluginResult* pluginResult;

    // Get Arguments
    NSString* label = [command.arguments objectAtIndex:0];
    NSString* shape = [command.arguments objectAtIndex:1];
    BOOL isIndeterminate = [[command.arguments objectAtIndex:2] boolValue];

    // Set Style
    if ([shape isEqualToString: _PROGRESSVIEW_STYLE_HORIZONTAL]) {
        if (isIndeterminate) {
            [self generateView:label viewMode:MRProgressOverlayViewModeIndeterminateSmall isVisible:YES];
        } else {
            [self generateView:label viewMode:MRProgressOverlayViewModeDeterminateHorizontalBar isVisible:YES];
        }
    } else {
        if (isIndeterminate) {
            [self generateView:label viewMode:MRProgressOverlayViewModeIndeterminate isVisible:YES];
        } else {
            [self generateView:label viewMode:MRProgressOverlayViewModeDeterminateCircular isVisible:YES];
        }
    };

    // Callback
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Show) OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
};


/**
 *  Set Progress
 */

- (void)setProgress:(CDVInvokedUrlCommand*)command
{
    // Init
    __block CDVPluginResult* pluginResult = nil;

    // Get Arguments
    __block NSNumber* progress = [command.arguments objectAtIndex:0];

    // Execute
    [self performBlock:^{
        [self updateProgress:progress];
        // Callback
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setProgress) OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } afterDelay:_PROGRESSVIEW_UPDATE_INTERVAL];
};


/**
 *  Set Label
 */

- (void)setLabel:(CDVInvokedUrlCommand*)command
{
    // Init
    __block CDVPluginResult* pluginResult = nil;

    // Get Arguments
    __block NSString* label = [command.arguments objectAtIndex:0];

    // Execute
    [self performBlock:^{
        [self updateLabel:label];
        // Callback
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (setLabel) OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } afterDelay:_PROGRESSVIEW_UPDATE_INTERVAL];
};


/**
 *  Hide
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
    // Init
    __block CDVPluginResult* pluginResult;

    // Execute
    [self performBlock:^{
        [self removeView];
        // Callback
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"(Cordova ProgressView) (Hide) OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } afterDelay:_PROGRESSVIEW_UPDATE_INTERVAL];
};



/***************************
 *  PRIVATE
 ***************************/

- (void)setVisible:(BOOL)visible
{
    if (visible == _isVisible) {
        return;
    }
    _isVisible = visible;

};


- (void)createView
{
    // Never animate the showing of the splash screen.
    if (_progressView == nil) {
        [self generateView:@"" viewMode:MRProgressOverlayViewModeDeterminateCircular isVisible:NO];
    }
};


- (void)updateProgress:(NSNumber *)viewProgress
{
    float viewProgressFloat = [viewProgress floatValue];
    [_progressView setProgress:viewProgressFloat animated:YES];
};


- (void)updateLabel:(NSString *)viewLabel
{
    [_progressView setTitleLabelText:viewLabel];
};


- (void)generateView:(NSString *)viewLabel viewMode:(MRProgressOverlayViewMode)viewMode isVisible:(BOOL)showView
{

    if ([viewLabel length] == 0) {
        viewLabel = _labelDefault;
    }

    if (_progressView == nil) {
        _progressView = [MRProgressOverlayView new];
        _progressView.tag = 88;
        [self.webView.superview.window addSubview:_progressView];
    } else {

        [_progressView setMode:viewMode];
        [self updateLabel:viewLabel];

        if (showView) {
            [_progressView show:YES];
            [self setVisible:YES];
        } else {
            [self setVisible:NO];
        }


    }
};


- (void)removeView
{
    [_progressView dismiss:YES completion:^(void){
        [_progressView removeFromSuperview];
        _progressView = nil;
        [self setVisible:NO];
    }];

};


- (BOOL)isVisible
{
    return _isVisible;
};


/***************************
 *  UTILITY
 ***************************/

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}


- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end