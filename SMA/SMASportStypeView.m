//
//  SMASportStypeView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMASportStypeView.h"

@implementation SMASportStypeView
{
    NSMutableArray *boundaryPoints;//纵坐标点
    NSMutableArray *bottomPoints;//横坐标点
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        boundaryPoints = [NSMutableArray array];
        bottomPoints = [NSMutableArray array];
    }
    return self;
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < _YleftTits.count; i ++) {
        //左则Y轴坐标
        CGRect rect = CGRectMake(2, (self.frame.size.height - 25)/5 * i + 4, CGRectGetWidth(self.frame)/7.3 - 2, (self.frame.size.height - 25)/5 - 8);
        UILabel *yTextLab = [[UILabel alloc] initWithFrame:rect];
        yTextLab.font = FontGothamLight(15);
        yTextLab.numberOfLines = 0;
        yTextLab.text = [_YleftTits objectAtIndex:i];
        [self addSubview:yTextLab];
        
        //颜色背景
        CGRect hrRect = CGRectMake(CGRectGetMaxX(yTextLab.frame) + 2, (self.frame.size.height - 25)/5 * i, CGRectGetWidth(self.frame) - CGRectGetWidth(yTextLab.frame) - 4, (self.frame.size.height - 25)/5);
        CALayer *layer = [CALayer layer];
        layer.frame = hrRect;
        layer.backgroundColor = [[_colors objectAtIndex:i] CGColor];
        [self.layer addSublayer:layer];
        [boundaryPoints addObject:[NSNumber numberWithFloat:(self.frame.size.height - 25)/5 * i]];
        if (i == _YleftTits.count - 1) {
            [boundaryPoints addObject:[NSNumber numberWithFloat:self.frame.size.height - 25]];
        }
    }
    
    //多颜色背景左右则标注
    CGFloat yFloat = 0.0;
    for (int j = 0; j < _rightTits.count; j ++) {
        CATextLayer * leftText = [CATextLayer layer];
        CATextLayer * rightText = [CATextLayer layer];
        CGSize leftSize = [_leftTits[j] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        CGSize rightSize = [_rightTits[j] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        if (j == 0) {
            yFloat = 0;
        }
        else if (j == 5){
            yFloat = self.frame.size.height - 25 - leftSize.height;
        }
        else{
            yFloat = (self.frame.size.height - 25)/5 * j - leftSize.height/2;
        }
        CGRect textRect = CGRectMake(CGRectGetWidth(self.frame)/7.3 + 4, yFloat, leftSize.width, leftSize.height);
        leftText.frame = textRect;
        leftText.string =  [[NSAttributedString alloc] initWithString:_leftTits[j] attributes:self.textStyleDict];
        leftText.contentsScale   = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:leftText];
        
        CGRect rightRect = CGRectMake(self.frame.size.width - 4 - rightSize.width, yFloat, rightSize.width, rightSize.height);
        rightText.frame = rightRect;
        rightText.string =  [[NSAttributedString alloc] initWithString:_rightTits[j] attributes:self.textStyleDict];
        rightText.contentsScale   = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:rightText];
    }
    
    //底部X轴标注
    CGSize size = [@"1000" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
    for (int k = 0; k < _XbottomTits.count; k ++) {
        CALayer *layer0 = [CALayer layer];
        UILabel *textLab = [[UILabel alloc] init];
        if (k == 0) {
            layer0.frame = CGRectMake(CGRectGetWidth(self.frame)/7.3 + 4 + size.width, CGRectGetHeight(self.frame) - 30, 1, 5);
            textLab.frame = CGRectMake(CGRectGetWidth(self.frame)/7.3/2.5, self.frame.size.height - 25, (CGRectGetMidX(layer0.frame) - (CGRectGetWidth(self.frame)/7.3/2.5)) * 2, 25);
            textLab.textAlignment = NSTextAlignmentCenter;
        }
        else{
            layer0.frame = CGRectMake(CGRectGetWidth(self.frame) - size.width - 8, CGRectGetHeight(self.frame) - 30, 1, 5);
            textLab.frame = CGRectMake(CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) - CGRectGetMidX(layer0.frame)) * 3.2 - 4, self.frame.size.height - 25, (CGRectGetWidth(self.frame) - CGRectGetMidX(layer0.frame)) * 3.2 - 0, 25);
            textLab.textAlignment = NSTextAlignmentRight;
        }
        textLab.font = FontGothamLight(14);
        textLab.text = _XbottomTits[k];
        textLab.numberOfLines = 0;
        layer0.backgroundColor = [UIColor whiteColor].CGColor;
        [bottomPoints addObject:[NSNumber numberWithFloat:layer0.frame.origin.x]];
        [self.layer addSublayer:layer0];
        [self addSubview:textLab];
    }
    
    UIBezierPath *pathPath = [UIBezierPath bezierPath];
    for (int l = 0; l < _hrDatas.count; l ++) {
        float y = [self toComparePoint:[[_hrDatas[l] objectForKey:@"REAT"] intValue]];
        float xInterval = [[bottomPoints objectAtIndex:1] floatValue] - [[bottomPoints objectAtIndex:0] floatValue];
        float x = xInterval/(_hrDatas.count - 1) * l + [[bottomPoints firstObject] floatValue];
        if (l == 0) {
            [pathPath moveToPoint:CGPointMake(x, y)];
        }
        else{
            [pathPath addLineToPoint:CGPointMake(x, y)];
        }
        NSLog(@"fw3gghfwfwghh===%@",pathPath);
    }
    
    CAShapeLayer * path = [CAShapeLayer layer];
//    path.backgroundColor = [UIColor blueColor].CGColor;
    path.frame       = self.bounds;
    path.lineCap     = kCALineCapSquare;
    path.fillColor   = nil;
    path.strokeColor = [UIColor whiteColor].CGColor;
    path.path        = pathPath.CGPath;
    [self.layer addSublayer:path];
}

//判断心率在于哪个区间内
- (float)toComparePoint:(int)point{
    int interval = 0; //心率所在区间
    float hrPoor = 0.0;   //区间的心率差
    float intervalDis = 0.0; //区间的距离
    int hr0 = [_leftTits[0] intValue];
    int hr1 = [_leftTits[1] intValue];
    int hr2 = [_leftTits[2] intValue];
    int hr3 = [_leftTits[3] intValue];
    int hr4 = [_leftTits[4] intValue];
    int hr5 = [_leftTits[5] intValue];
    
    float di0 = [boundaryPoints[0] floatValue];
    float di1 = [boundaryPoints[1] floatValue];
    float di2 = [boundaryPoints[2] floatValue];
    float di3 = [boundaryPoints[3] floatValue];
    float di4 = [boundaryPoints[4] floatValue];
    float di5 = [boundaryPoints[5] floatValue];
    if (point >= hr1 && point <= hr0) {
        interval = 0;
        intervalDis = di1 - di0;
        hrPoor = hr0 - hr1;
    }
    else if (point >= hr2 && point < hr1){
        interval = 1;
        intervalDis = di2 - di1;
         hrPoor = hr1 - hr2;
    }
    else if (point >= hr3 && point < hr2){
        interval = 2;
        intervalDis = di3 - di2;
         hrPoor = hr2 - hr3;
    }
    else if (point >= hr4 && point < hr3){
        interval = 3;
        intervalDis = di4 - di3;
         hrPoor = hr3 - hr4;
    }
    else if (point >= hr5 && point < hr4){
        interval = 4;
        intervalDis = di5 - di4;
        hrPoor = hr4 - hr5;
    }

    //根据区间内心率差计算所在区域心率占用距离（由于每个区间心率差不一样）
    float allPoor = intervalDis/hrPoor;
    float hrLocation = ([_leftTits[interval] intValue] - point) * allPoor;//所在区域的心率需要把该区域最大的心率减去该心率，得到心率差方才乘以区域中每个心率的区间
    return hrLocation + [boundaryPoints[interval] floatValue];
}

- (NSDictionary *)textStyleDict{
    if (!_textStyleDict){
        UIFont *font = FontGothamLight(13);
        NSMutableParagraphStyle *sytle = [[NSMutableParagraphStyle alloc]init];
        sytle.alignment = NSTextAlignmentCenter;
        _textStyleDict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:sytle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    return _textStyleDict;
}

@end
