//
//  STConst.h
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

#define STWeakSelf __weak typeof(self) weakSelf = self;