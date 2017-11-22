//
//  AutoFormatter.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoFormatter : UIView
{
    
}

@property(readwrite) float SCALE_X;
@property(readwrite) float SCALE_Y;

+(AutoFormatter*)getInstance;

- (void) initTextFldType:(UITextField*)_textFld placeholder:(NSString*)_txt;
- (void) resizeView:(UIView*)__view;

@end
