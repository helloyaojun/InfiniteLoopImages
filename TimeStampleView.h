//
//  TimeStampleView.h
//  HomeView
//
//  Created by 姚君 on 15/11/21.
//  Copyright © 2015年 certus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define stampleWidth    22
#define gapWidth    11
#define leftTap     40

#define timeFont   [UIFont systemFontOfSize:13.f]
#define timeBoldFont   [UIFont boldSystemFontOfSize:13.f]
#define timeTextColor     _COLOR_HEX(0x7ee3c5)

@interface TimeStampleView : UIView

@property (nonatomic,strong)UILabel *stampleLabel;
@property (nonatomic,strong)UILabel *timeLabel;

- (id)init;

@end
