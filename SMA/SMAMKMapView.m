//
//  SMAMKMapView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAMKMapView.h"
#define MERCATOR_RADIUS 85445659.44705395 

@interface SMAMKMapView ()
@property (nonatomic, strong) NSMutableArray *polyliones;
@end

@implementation SMAMKMapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _polyliones = [NSMutableArray array];
    self.region=MKCoordinateRegionMake(CLLocationCoordinate2DMake(22.574192, 113.856248), MKCoordinateSpanMake(1, 1));
    self.rotateEnabled = NO;
    self.delegate = self;
    MKCoordinateRegion MKCoordinateRegionForMapRect(MKMapRect rect);
//    self.region
    
  
}

- (void)removeOverlayView{
    [self removeOverlays:_polyliones];
    [_polyliones removeAllObjects];
}

//绘制轨迹
- (void)drawOverlayWithPoints:(NSMutableArray *)points{
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i ++) {//若坐标量少于2个，会引起地图出现一片红色区域，原因不明
        NSMutableArray *detailPoints = [points objectAtIndex:i];
        CLLocationCoordinate2D commonPolylineCoordss[detailPoints.count];
        for (int j = 0; j < detailPoints.count; j ++) {
            NSDictionary *locationDic = detailPoints[j];
            commonPolylineCoordss[j].latitude = [locationDic[@"LATITUDE"] doubleValue];
            commonPolylineCoordss[j].longitude = [locationDic[@"LONGITUDE"] doubleValue];
            CLLocationCoordinate2D code;
            code.latitude = [locationDic[@"LATITUDE"] doubleValue];
            code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
            MKMapPoint annotationPoint = MKMapPointForCoordinate(code);
            MKMapRect rect1 = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = rect1;
                
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect1);
                
            }
        }
        SMAPolyline *routeLine = [SMAPolyline polylineWithCoordinates:commonPolylineCoordss count:detailPoints.count];
       
        [_polyliones addObject:routeLine];
    }
     [self addOverlays:_polyliones];
    [self updateMapviewVisibleRegionWithPoints:points];
}

- (void)addAnnotationsWithPoints:(NSMutableArray *)points{
    for (int i = 0; i < points.count; i ++) {
//        MKPointAnnotation
//        mk *annation=[[MKAnnotationView alloc]init];
//        
//        [annation setCoordinate:CLLocationCoordinate2DMake(30.23423,104.345354)];
//        
//        [_mapViewaddAnnotation:annation];
    }
}

//配置地图轨迹所有的点，计算地图显示轨迹区域
- (void)updateMapviewVisibleRegionWithPoints:(NSMutableArray *)points{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i ++) {//若坐标量少于2个，会引起地图出现一片红色区域，原因不明
        NSMutableArray *detailPoints = [points objectAtIndex:i];
        for (int j = 0; j < detailPoints.count; j ++) {
            NSDictionary *locationDic = detailPoints[j];
            CLLocationCoordinate2D code;
            code.latitude = [locationDic[@"LATITUDE"] doubleValue];
            code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
            MKMapPoint annotationPoint = MKMapPointForCoordinate(code);
            MKMapRect rect1 = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = rect1;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect1);
            }
        }
}
    zoomRect = [self mapRectThatFits:zoomRect];
    [self setVisibleMapRect:zoomRect animated:YES];
    
    int zoomlevel = [self getZoomLevel:self];
    //由于计算出区域刚好覆盖显示区域，所以需要进行调整
    NSLog(@"fwgeheh==%f  %f   %f",[self getZoomLevel:self],self.centerCoordinate.latitude ,self.centerCoordinate.longitude);
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomlevel > 2 ? (zoomlevel- 2) : zoomlevel animated:YES];
}

- (float)getZoomLevel:(MKMapView*)_mapView {
    
    return 21 - round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width)));
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if([overlay isKindOfClass:[SMAPolyline class]]){
        //轨迹
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 3.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:54/255.0 green:153/255.0 blue:230/255.0 alpha:1];
        return polylineRenderer;
    }
    return nil;
}


@end
