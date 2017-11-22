//
//  STPhotoBrowserView.h
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPhotoBrowserView : UIView

@property (nonatomic, strong, nullable)UIScrollView *scrollView;
@property (nonatomic, strong, nullable)UIImageView *imageView;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)BOOL beginLoadingImage;
@property (nonatomic, copy) void (^ _Nonnull singleTapBlock)(UITapGestureRecognizer * _Nonnull recognizer);
@property (nonatomic, assign, getter=isLoadedImage)BOOL  hasLoadedImage;

- (void)setImageWithURL:(NSURL*_Nonnull)url
       placeholderImage:(UIImage *_Nonnull)placeholderImage;

@end
