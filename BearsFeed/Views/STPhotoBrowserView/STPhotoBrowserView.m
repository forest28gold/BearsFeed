//
//  STPhotoBrowserView.m
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#import "STPhotoBrowserView.h"
#import "STIndicatorView.h"
#import "STConfig.h"
#import <UIImageView+WebCache.h>

@interface STPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong, nullable)STIndicatorView  *indicatorView;
@property (nonatomic, strong, nullable)UIButton         *buttonReload;
@property (nonatomic, strong, nullable)UIImage          *placeHolderImage;
@property (nonatomic, strong, nullable)UITapGestureRecognizer  *tapSingle;
@property (nonatomic, strong, nullable)UITapGestureRecognizer  *tapDouble;
@property (nonatomic, strong, nullable)NSURL    *urlImage;

@end

@implementation STPhotoBrowserView
#pragma mark - --- lift cycle ---
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self addGestureRecognizer:self.tapSingle];
        [self addGestureRecognizer:self.tapDouble];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame     = self.bounds;
    self.indicatorView.center = self.scrollView.center;
    self.buttonReload.center  = self.scrollView.center;
    
    [self adjustFrame];
}

- (void)adjustFrame
{
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0,
                                       0,
                                       imageSize.width,
                                       imageSize.height);
        if (STFullWidthForLandScape){
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageView.frame = imageFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollViewContent:self.scrollView];
        
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>STScaleMax?maxScale:STScaleMax;
        self.scrollView.minimumZoomScale = STScaleMin;
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollView.contentSize = self.imageView.frame.size;
    }
    self.scrollView.contentOffset = CGPointZero;
}


#pragma mark - --- Delegate  ---

#pragma mark - 1.scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark -
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width)?
    (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height)?
    (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}


#pragma mark - --- event response  ---
#pragma mark -
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

#pragma mark -
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (!self.hasLoadedImage) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

#pragma mark -
- (void)reloadImage
{
    [self setImageWithURL:self.urlImage
         placeholderImage:self.placeHolderImage];
}

#pragma mark - --- private methods ---

#pragma mark -
- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage *)placeholderImage
{
    if (self.buttonReload) {
        [self.buttonReload removeFromSuperview];
    }
    
    self.urlImage = url;
    self.placeHolderImage = placeholderImage;
    [self addSubview:self.indicatorView];
    
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:placeholderImage
                               options:SDWebImageRetryFailed
                              progress:^(NSInteger receivedSize,
                                         NSInteger expectedSize) {
                                  __strong typeof(weakSelf) strongSelf = weakSelf;
                                  strongSelf.indicatorView.progress = (CGFloat)receivedSize / expectedSize;
                                  
                              } completed:^(UIImage *image,
                                            NSError *error,
                                            SDImageCacheType cacheType,
                                            NSURL *imageURL) {
                                  __strong typeof(weakSelf) strongSelf = weakSelf;
                                  [strongSelf.indicatorView removeFromSuperview];
                                  
                                  if (error) {
                                      [strongSelf addSubview:self.buttonReload];
                                      return;
                                  }
                                  strongSelf.hasLoadedImage = YES;
                              }];
}
#pragma mark - getters and setters 

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.indicatorView.progress = progress;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView setClipsToBounds:YES];
        [_scrollView setDelegate:self];
        [_scrollView addSubview:self.imageView];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        
        [_scrollView setMinimumZoomScale:STScaleMin];
        [_scrollView setMaximumZoomScale:STScaleMax];
        [_scrollView setZoomScale:1.0f animated:YES];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imageView;
}

- (STIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[STIndicatorView alloc]init];
        [_indicatorView setViewMode:STIndicatorViewModePieDiagram];
    }
    return _indicatorView;
}

- (UIButton *)buttonReload
{
    if (!_buttonReload) {
        _buttonReload = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_buttonReload setBackgroundColor:RGB(240, 170, 170)];
        [_buttonReload setClipsToBounds:YES];
        [_buttonReload setTitle:@"Picture fails to load, click reload" forState:UIControlStateNormal];
        [_buttonReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonReload.layer setCornerRadius:2];
        [_buttonReload.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_buttonReload addTarget:self
                          action:@selector(reloadImage)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonReload;
}

- (UITapGestureRecognizer *)tapSingle
{
    if (!_tapSingle) {
        _tapSingle = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(handleSingleTap:)];
        [_tapSingle setNumberOfTapsRequired:1];
        [_tapSingle setNumberOfTouchesRequired:1];
        [_tapSingle requireGestureRecognizerToFail:self.tapDouble];
    }
    return _tapSingle;
}

- (UITapGestureRecognizer *)tapDouble
{
    if (!_tapDouble) {
        _tapDouble = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(handleDoubleTap:)];
        [_tapDouble setNumberOfTapsRequired:2];
        [_tapDouble setNumberOfTouchesRequired:1];
    }
    return _tapDouble;
}

@end

