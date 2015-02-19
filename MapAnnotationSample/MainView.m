//
//  MainView.m
//  MapAnnotationSample
//
//  Created by kubo naoko on 2013/11/06.
//  Copyright (c) 2013年 kubo naoko. All rights reserved.
//

#import "MainView.h"

@implementation PinAnnotation

- (id) initWithCoordinate:(CLLocationCoordinate2D)c {
    _coordinate = c;
    return self;
}
/*-(void)setCoordinate:(CLLocationCoordinate2D)coordinate{
 _coordinate = coordinate;
 }*/
@end

@implementation BallonAnnotation
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    //    super.coordinate = coordinate;
    _coordinate = coordinate;
}
@end

@interface MainView (){
    CLLocationCoordinate2D coordinate;
    CLLocationManager* locmanager;
    
    IBOutlet MKMapView* _mapView;
    PinAnnotation* _pinAnnotation;
    
}

@end

@implementation MainView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(35.0212466, 135.7555968 );
    
    [self movePinLocationTo:coord];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKMapViewDelegate
-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation {
    if (annotation == _mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier;
    if ([annotation isKindOfClass:[PinAnnotation class]]) {
        MKPinAnnotationView *annotationView;
        // Pin annotation.
        NSString* identifier = @"Pin";
        annotationView = (MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(nil == annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        //        [annotationView setCanShowCallout:YES];
        [annotationView setAnnotation:annotation];
        annotationView.animatesDrop = YES;
        return annotationView;
    } else if ([annotation isKindOfClass:[BallonAnnotation class]]) {
        // Callout annotation.
        identifier = @"Callout";
        annotationView = (BallonAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ( !annotationView ) {
            annotationView = [[BallonAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        BallonAnnotation *ballonAnnotation = (BallonAnnotation *)annotation;
        [((BallonAnnotationView *)annotationView) setTitle: ballonAnnotation.mainTitle];
        [((BallonAnnotationView *)annotationView) setDesc1:ballonAnnotation.desc1];
        [((BallonAnnotationView *)annotationView) setDesc2:ballonAnnotation.desc2];
        [((BallonAnnotationView *)annotationView) setTopIconImage:ballonAnnotation.imageIcon1];
        [((BallonAnnotationView *)annotationView) setDownIconImage:ballonAnnotation.imageIcon2];
        [((BallonAnnotationView *)annotationView) setDelegate:self];
        [((BallonAnnotationView *)annotationView) initView];
        [annotationView setAnnotation: annotation];
        [annotationView setCenterOffset:CGPointMake(-135.0f, -215.0f)];
        [annotationView setNeedsDisplay];
        // Move the display position of MapView.
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                             _mapView.centerCoordinate = ballonAnnotation.coordinate;
                         }];
        return annotationView;
    }
    return nil;
    
}
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        // Selected the pin annotation.
        BallonAnnotation *ballonAnnotation = [[BallonAnnotation alloc] init];
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        [ballonAnnotation setMainTitle: pinAnnotation.mainTitle];
        [ballonAnnotation setCoordinate: pinAnnotation.coordinate];
        [ballonAnnotation setDesc1:pinAnnotation.desc1];
        [ballonAnnotation setDesc2:pinAnnotation.desc2];
        [ballonAnnotation setImageIcon1:pinAnnotation.imageIcon1];
        [ballonAnnotation setImageIcon2:pinAnnotation.imageIcon2];
        [pinAnnotation setCalloutAnnotation:ballonAnnotation];
        [mapView addAnnotation:ballonAnnotation];
    }
}
//  デスクロージャタップ対応
/*- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
 {
 printf("tap DetailDisclosure\n");
 }*/
-(void)annotationTapped:(MKAnnotationView *)sender tapped:(BOOL)tapped{
    if ([sender isKindOfClass:[BallonAnnotationView class]]) {
        if ( tapped ){
            [((BallonAnnotationView*)sender) animateBallon];
            return;
        }else{
            [self dismissBallonView:(BallonAnnotationView*)sender];
        }
    }else{
        NSLog(@"[%@]",[sender class]);
    }
}
-(void)dismissBallonView:(BallonAnnotationView*)ballonAnnotationView {

    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [ballonAnnotationView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                     }
     ];
}
- (void)mapView:(MKMapView *)mapView
 didDeselectAnnotationView:(MKAnnotationView *)view
 {
     if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
         PinAnnotation*  pinAnnotation = ((PinAnnotation *)view.annotation);
         MKAnnotationView *annotationView = [_mapView viewForAnnotation:pinAnnotation.calloutAnnotation];
         if( [((BallonAnnotationView*)annotationView) touchedInside] ){
             return;
         }
         [self dismissBallonView:(BallonAnnotationView*)annotationView];
     }
 }
- (void)reSelectAnnotationIfNoneSelected:(id<MKAnnotation>)annotation
{
    if (_mapView.selectedAnnotations.count == 0)
        [_mapView selectAnnotation:annotation animated:NO];
}
#pragma mark-
- (void)movePinLocationTo:(CLLocationCoordinate2D)coord {
    if (!_pinAnnotation) {
        _pinAnnotation = [[PinAnnotation alloc] initWithCoordinate:coord];
        [_mapView addAnnotation:_pinAnnotation];
    }
    [_pinAnnotation setMainTitle:@"タイトル"];
    [_pinAnnotation setDesc1:@"せつめい１"];
    NSData *dt = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-frc3/381550_186998818063770_390913600_n.jpg"]];
    UIImage *image = [[UIImage alloc] initWithData:dt];
    [_pinAnnotation setImageIcon1:image];
    dt = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-frc3/381550_186998818063770_390913600_n.jpg"]];
    image = [[UIImage alloc] initWithData:dt];
    [_pinAnnotation setImageIcon2:image];
    [_pinAnnotation setCoordinate:coord];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 20.0f, 20.0f);
    [_mapView setRegion:region animated:YES];
}
- (void)searhAddress:(NSString*)addressStr{
    if ([[addressStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return;
    }
    
    //    __weak UIViewController *weak_self = self;
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray * placemarks, NSError * error) {
        if (error) {
            return;
        }
        if ([placemarks count] == 0) {
            return;
        }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D coord = placemark.location.coordinate;
        [self movePinLocationTo:coord];
    }
     ];
}
@end
