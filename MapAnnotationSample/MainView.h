//
//  MainView.h
//  MapAnnotationSample
//
//  Created by kubo naoko on 2013/11/06.
//  Copyright (c) 2013年 kubo naoko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BallonAnnotationView.h"

@interface BallonAnnotation : NSObject <MKAnnotation>
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString* mainTitle;
@property (nonatomic) NSString* desc1;
@property (nonatomic) NSString* desc2;
@property (nonatomic) UIImage* imageIcon1;
@property (nonatomic) UIImage* imageIcon2;
@end


@interface PinAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString* mainTitle;
@property (nonatomic) NSString* desc1;
@property (nonatomic) NSString* desc2;
@property (nonatomic) UIImage* imageIcon1;
@property (nonatomic) UIImage* imageIcon2;
@property (nonatomic) BallonAnnotation *calloutAnnotation;
- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;
@end

@interface MainView : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,BallonAnnotationViewDelegate>

@end
