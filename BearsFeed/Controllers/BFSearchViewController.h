//
//  BFSearchViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSearchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnPeople;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPost;
@property (strong, nonatomic) IBOutlet UITextField *m_txtSearch;
@property (strong, nonatomic) IBOutlet UITableView *m_tableViewPeople;
@property (strong, nonatomic) IBOutlet UITableView *m_tableViewPost;

@end
