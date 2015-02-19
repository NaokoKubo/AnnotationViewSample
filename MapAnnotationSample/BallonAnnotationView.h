//
//  BallonAnnotationView.h
//  favlis
//
//  Created by kubo naoko on 2013/11/03.
//  Copyright (c) 2013年 interrupt All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol BallonAnnotationViewDelegate <NSObject>
-(void)annotationTapped :(MKAnnotationView*)sender tapped:(BOOL)tapped;
-(void)dismissAnimationFinished;
@end

@interface BallonAnnotationView : MKAnnotationView

@property (nonatomic) IBOutlet UIView* loadedView;
@property (nonatomic,assign) NSString* title;
@property (nonatomic,assign) NSString* desc1;
@property (nonatomic,assign) NSString* desc2;
@property (nonatomic,assign) UIImage* topIconImage;
@property (nonatomic,assign) UIImage* downIconImage;
@property (nonatomic, assign) id<BallonAnnotationViewDelegate> delegate;

-(void)initView;
-(void)animateBallon;
-(void)dismissAnimation;
-(BOOL)touchedInside;

@end
