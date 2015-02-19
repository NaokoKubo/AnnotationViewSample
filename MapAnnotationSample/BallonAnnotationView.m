//
//  BallonAnnotationView.m
//  favlis
//
//  Created by kubo naoko on 2013/11/03.
//  Copyright (c) 2013年 interrupt All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "BallonAnnotationView.h"
#define TOP_YPOS (90)
const NSString* title_ViewHTML = @"<html><head></head><body><div style=\"position: absolute;display:table-cell;vertical-align: middle;width:270px;height:180px;word-wrap: break-word;font-family:HiraKakuProN-W3;font-size:12pt;text-align:left;font-weight:bold;line-height:1.2;color:white;\">%@</div></body></html>";

@interface BallonAnnotationView (){
    IBOutlet UIView* topView;
    IBOutlet UIWebView* titleWebView;
    IBOutlet UIImageView* topIconImageView;

    IBOutlet UIView* downView;
    IBOutlet UILabel* descLabel1;
    IBOutlet UILabel* descLabel2;
    IBOutlet UIImageView* downIconImageView;
    
    BOOL _touchedInside;
    
    
}

@end

@implementation BallonAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"BallonAnnotationView" owner:self options:nil];
        if (_loadedView){
            [self addSubview:_loadedView];
        }
    }
    [topIconImageView.layer setBackgroundColor: [[UIColor colorWithWhite:1.0f alpha:0.5f]CGColor]];
    [topIconImageView.layer setBorderWidth : 2.0f];
    [topIconImageView.layer setBorderColor: [[UIColor whiteColor]CGColor]];
    [topIconImageView.layer setCornerRadius: 3.0f];
    [topIconImageView.layer setShadowColor: [[UIColor darkGrayColor]CGColor]];
    [topIconImageView.layer setShadowOpacity : 0.7f];
    [topIconImageView.layer setShadowOffset: CGSizeMake(3.0f, 3.0f)];
    _touchedInside = NO;
    
    return self;
}
-(void)setTitle:(NSString *)title{
    NSString* html = [NSString stringWithFormat:(NSString*)title_ViewHTML,title];
    
    [titleWebView setOpaque:NO];
    [titleWebView setBackgroundColor:[UIColor clearColor]];
    [titleWebView loadHTMLString:html baseURL:nil];
    
}
-(void)setDesc1:(NSString *)desc1{
    [descLabel1 setText:desc1];
}
-(void)setDesc2:(NSString *)desc2{
    [descLabel2 setText:desc2];
}
-(void)setDownIconImage:(UIImage *)downIconImage{
    [downIconImageView setImage:downIconImage];
}
-(void)setTopIconImage:(UIImage *)topIconImage{
    [topIconImageView setImage:topIconImage];
}
-(BOOL)touchedInside{
    return _touchedInside;
}
//開閉のアニメーション
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    CGRect frame = downView.frame;
    BOOL tapped = NO;
    if( point.y > frame.origin.y && point.y < frame.origin.y+frame.size.height ){
        tapped = YES;
    }
    [self.delegate annotationTapped:self tapped:tapped];
}
#pragma mark MSAnnotationView
/*- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    // Return YES if the point is inside an area you want to be touchable
    int i = 0;
    i++;
    return YES;
}*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // Return the deepest view that the point is inside of.
    CGRect rect = topView.frame;
    
    if (CGRectContainsPoint(rect, point)) {
        _touchedInside = YES;
    }else{
        _touchedInside = NO;
    }
    return self;
}
-(void)animateBallon{
    CGRect frame = topView.frame;
    frame.origin.y = frame.origin.y == 0.0f ? TOP_YPOS : 0.0f;
    CGFloat alpha = downView.alpha ? 0.0f : 1.0f;
    [UIView animateWithDuration:0.4f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [topView setFrame:frame];
                         [downView setAlpha:alpha];
                     }
                     completion:^(BOOL finished){
                     }];
    
}
-(void)dismissAnimation{
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.delegate dismissAnimationFinished];
                         [self setAlpha:1.0f];//もとにもどしておく
                     }
     ];
    
}
/*-(void)didMoveToSuperview{

}*/
/*-(void)animationDidStart:(CAAnimation *)anim{
    
}*/
#pragma mark -
-(void)initView{
    CGRect frame = topView.frame;
    frame.origin.y = TOP_YPOS;
    [topView setFrame:frame];
    [downView setAlpha:0.0f];
}
@end
