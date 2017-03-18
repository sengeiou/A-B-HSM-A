//
//  SMAMKMapView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SMAPolyline.h"
#import "MKMapView+ZoomLevel.h"
@interface SMAMKMapView : MKMapView<MKMapViewDelegate>
- (void)drawOverlayWithPoints:(NSMutableArray *)points;
@end
