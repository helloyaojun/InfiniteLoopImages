//
//  TimeStampleView.m
//  HomeView
//
//  Created by 姚君 on 15/11/21.
//  Copyright © 2015年 certus. All rights reserved.
//

#import "TimeStampleView.h"


@implementation TimeStampleView

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 115+leftTap, 30);
        
        _stampleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftTap, self.frame.size.height/2-0.5, stampleWidth, 1)];
        _stampleLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:_stampleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(stampleWidth+gapWidth+leftTap, 0, self.frame.size.width-stampleWidth-gapWidth, self.frame.size.height)];
        _timeLabel.textAlignment =NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor greenColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = timeFont;
        [self addSubview:_timeLabel];
        
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
