//
//  AppDelegate.h
//  SibgletonClassExample
//
//  Created by Rajesh K G on 25/11/16.
//  Copyright © 2016 INDGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    UIActivityIndicatorView *spinnerView;
}

@property (strong, nonatomic) UIWindow *window;

-(void)addSpinnerViewOnScreen:(BOOL)removeOrAddSpinner;


@end

