//
//  BFEliminatedTargetViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFEliminatedTargetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_view;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *m_activity;

- (void)onEliminateTarget;
- (void)onEliminateLastTarget;

@end
