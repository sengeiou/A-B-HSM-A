//
//  PointAnnotation.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "PointAnnotation.h"

@implementation PointAnnotation

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //大头针的图片
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        [imageView setImage:[UIImage imageNamed:@"map_location_blue"]];
        
        [self addSubview:imageView];
        
    }  
    
    return self;
    
}  


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
