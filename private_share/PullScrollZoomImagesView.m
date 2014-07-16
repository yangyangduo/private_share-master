//
//  PullScrollZoomImagesView.m
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PullScrollZoomImagesView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

CGFloat const kPullImageTopViewHeight = 64.f;
CGFloat const kPullImageBottomViewHeight = 30.f;

@implementation PullScrollZoomImagesView {
    CGFloat insetTop;
    UIScrollView *imagesScrollView;
    __weak UIScrollView *containerScrollView;
}

@synthesize imageItems = _imageItems_;
@synthesize pageIndex = _pageIndex_;
@synthesize scrollViewLocked = _scrollViewLocked_;
@synthesize bottomView = _bottomView_;
@synthesize delegate;

- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectMake(0, -kPullImageViewHeight - scrollView.contentInset.top, kPullImageViewWidth, kPullImageViewHeight)];
    if(self) {
        insetTop = scrollView.contentInset.top;
        
        //
        containerScrollView = scrollView;
        
        //
        imagesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        imagesScrollView.pagingEnabled = YES;
        imagesScrollView.showsVerticalScrollIndicator = NO;
        imagesScrollView.showsHorizontalScrollIndicator = NO;
        imagesScrollView.userInteractionEnabled = YES;
        imagesScrollView.delegate = self;
        [self addSubview:imagesScrollView];
        
        //
        [scrollView insertSubview:self atIndex:0];
        scrollView.contentInset = UIEdgeInsetsMake(kPullImageViewHeight + insetTop, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -kPullImageViewHeight - insetTop);
        
        _bottomView_ = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kPullImageBottomViewHeight, self.bounds.size.width, kPullImageBottomViewHeight)];
        _bottomView_.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomView_];
    }
    return self;
}

- (void)setImageItems:(NSArray *)imageItems {
    _imageItems_ = [NSArray arrayWithArray:imageItems];
    for(int i=0; i<imagesScrollView.subviews.count; i++) {
        [[imagesScrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    for(int i=0; i<_imageItems_.count; i++) {
        ImageItem *imageItem = [_imageItems_ objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagesScrollView.bounds.size.width * i, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:imageItem.url] placeholderImage:nil];
        [imagesScrollView addSubview:imageView];
    }
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
    _pageIndex_ = 0;
}

- (void)setPageIndex:(NSUInteger)pageIndex {
    _pageIndex_ = pageIndex;
}

- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y + insetTop;
    if (yOffset < -kPullImageViewHeight) {
        CGFloat factor = ((ABS(yOffset) + kPullImageViewHeight) * (kPullImageViewWidth / 2)) / kPullImageViewHeight;
        CGFloat xOffset = (factor - kPullImageViewWidth) / 2;
        CGRect frame = CGRectMake(-xOffset, yOffset - insetTop, factor, -yOffset);
        
        // set self frame
        self.frame = frame;
        
        // set title view frame
        if(_bottomView_) {
            _bottomView_.frame = CGRectMake(-self.frame.origin.x, self.bounds.size.height - kPullImageBottomViewHeight, kPullImageViewWidth, kPullImageBottomViewHeight);
        }
        
        // set scroll view frame
        imagesScrollView.frame = self.bounds;
        imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
        imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * self.pageIndex, 0);
        
        // set scroll view content frame
        for(int i=0; i<imagesScrollView.subviews.count; i++) {
            UIView *imageView = [imagesScrollView.subviews objectAtIndex:i];
            imageView.frame = CGRectMake(imagesScrollView.bounds.size.width * i , 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height);
        }
    } else if(yOffset <= 0 && yOffset >= -kPullImageViewHeight) {
        CGRect frame;
        if(yOffset != -kPullImageViewHeight - insetTop) {
            frame = CGRectMake(0, 0, kPullImageViewWidth, kPullImageViewHeight);
            frame.origin.y = (-kPullImageViewHeight - insetTop + ((yOffset + kPullImageViewHeight) / 2));
        } else {
            frame = CGRectMake(0, -kPullImageViewHeight - insetTop, kPullImageViewWidth, kPullImageViewHeight);
        }
        
        self.frame = frame;
        
        if(_bottomView_) {
            _bottomView_.frame = CGRectMake(-self.frame.origin.x, self.bounds.size.height - kPullImageBottomViewHeight, kPullImageViewWidth, kPullImageBottomViewHeight);
        }
        
        imagesScrollView.frame = self.bounds;
        imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
        imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * self.pageIndex, 0);
        for(int i=0; i<imagesScrollView.subviews.count; i++) {
            UIView *imageView = [imagesScrollView.subviews objectAtIndex:i];
            imageView.frame = CGRectMake(imagesScrollView.bounds.size.width * i , 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height);
        }
    }
}

- (void)setScrollViewLocked:(BOOL)scrollViewLocked {
    _scrollViewLocked_ = scrollViewLocked;
    if(_scrollViewLocked_) {
        imagesScrollView.scrollEnabled = NO;
    } else {
        imagesScrollView.scrollEnabled = YES;
    }
}

- (void)recalculatedPageIndex {
    _pageIndex_ = floor(imagesScrollView.contentOffset.x) / floor(imagesScrollView.bounds.size.width);
    if(self.delegate != nil) {
        [self.delegate pullScrollZoomImagesView:self imagesPageIndexChangedTo:_pageIndex_];
    }
}

- (UIScrollView *)scrollView {
    return imagesScrollView;
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(self.scrollViewLocked) return;
    if(containerScrollView) {
        containerScrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(self.scrollViewLocked) return;
    if(!decelerate) {
        [self recalculatedPageIndex];
        containerScrollView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.scrollViewLocked) return;
    [self recalculatedPageIndex];
    containerScrollView.scrollEnabled = YES;
}

@end
