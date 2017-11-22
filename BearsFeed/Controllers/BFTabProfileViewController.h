//
//  BFTabProfileViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFTabProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *m_imgBackPhoto;
@property (strong, nonatomic) IBOutlet UILabel *m_lblName;
@property (strong, nonatomic) IBOutlet UILabel *m_lblBio;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
