//
//  BFPostDetailsViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface BFPostDetailsViewController : UIViewController <HPGrowingTextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet HPGrowingTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *m_btnSend;
@property (strong, nonatomic) IBOutlet UIButton *m_btnReport;

@end
