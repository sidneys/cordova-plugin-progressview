/****************************************
 *
 *  ProgressView.h
 *  Cordova ProgressView
 *
 *  Created by Sidney Bofah on 2014-11-20.
 *
 ****************************************/

#import <Cordova/CDV.h>
#import <MRProgress/MRProgress.h>


@interface ProgressView: CDVPlugin {
    MRProgressOverlayView* _progressView;
    BOOL _isVisible;
    NSString* _labelDefault;
    float _progressDefault;
}

- (void)show:(CDVInvokedUrlCommand*)command;
- (void)setProgress:(CDVInvokedUrlCommand*)command;
- (void)setLabel:(CDVInvokedUrlCommand*)command;
- (void)hide:(CDVInvokedUrlCommand*)command;

@end