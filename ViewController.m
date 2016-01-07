//
//  ViewController.m
//  InfiniteLoopImages
//
//  Created by 姚君 on 15/12/25.
//  Copyright © 2015年 coco. All rights reserved.
//

#import "ViewController.h"
#import "TimeStampleView.h"
#import "ApplicationView.h"
#import "RTXCAppModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height

#define leftPartWidth       120
#define TimeStampleHeight   40

#define appTop          130

#define appHeight       ((MainHeight-appTop)/4)
#define appWidth        (appHeight *1.6)
#define rightAppGap     (appHeight-appHeight/4)

#define EditHeight        76

#define timeTagBaseInteger     2333
#define appTagBaseInteger     233333

@interface ViewController () {

    UIView *leftView;
    UIView *rightView;
    NSMutableArray *leftViewArray;
    NSMutableArray *rightViewArray;
    UIImageView *indexImageView;
    UIImageView *indexContainerView;
    NSUInteger selectedIndex;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backgroundView.image = [UIImage imageNamed:@"home_background"];
    _backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:_backgroundView];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 100)];
    topImage.backgroundColor = [UIColor clearColor];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.image = [UIImage imageNamed:@"home_top"];
    [topImage addSubview:indexImageView];
    [_backgroundView addSubview:topImage];

    leftViewArray = [NSMutableArray array];
    rightViewArray = [NSMutableArray array];

    _timeAppList = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        RTXCAppModel *model = [[RTXCAppModel alloc]init];
        model.timeNode = [NSString stringWithFormat:@"%d :00",i];
        model.id = [NSString stringWithFormat:@"%d",i];
        [_timeAppList addObject:model];
    }
    [self buildAreaParts];
    [self buildTimeStamples];
    [self buildApplications];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimeAppRightPlace];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buildAreaParts {
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, leftPartWidth, CGRectGetMaxY(self.view.frame)-53.3-160)];
    leftView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftView];
    
    rightView = [[UIScrollView alloc]initWithFrame:CGRectMake(MainWidth-14-appWidth, appTop, 300, rightAppGap*5)];
    rightView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightView];
    
    indexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(leftView.frame)-TimeStampleHeight+stampleWidth/2, leftPartWidth, TimeStampleHeight)];
    indexImageView.backgroundColor = [UIColor clearColor];
    indexImageView.userInteractionEnabled = YES;
    indexImageView.image = [UIImage imageNamed:@"home_selected"];
    [_backgroundView addSubview:indexImageView];
    [indexImageView setHidden:YES];
    
    indexContainerView = [[UIImageView alloc]initWithFrame:CGRectMake(MainWidth-14-appWidth, CGRectGetMidY(rightView.frame)-rightAppGap/2, appWidth, rightAppGap)];
    indexContainerView.backgroundColor = [UIColor redColor];
    [_backgroundView addSubview:indexContainerView];
    [indexContainerView setHidden:YES];
    
}
- (void)buildTimeStamples {
    
    for (TimeStampleView *timeLabel in leftViewArray) {
        [timeLabel removeFromSuperview];
    }
    [leftViewArray removeAllObjects];
    for (int i=0; i < _timeAppList.count; i++) {
        RTXCAppModel *model = [_timeAppList objectAtIndex:i];
        
        TimeStampleView *timeLabel = [[TimeStampleView alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.center = CGPointMake(77, TimeStampleHeight*i+timeLabel.bounds.size.height/2+CGRectGetMinY(leftView.frame));
        timeLabel.tag = timeTagBaseInteger+i;
        timeLabel.timeLabel.text = model.timeNode;
        [leftViewArray addObject:timeLabel];
        
        [timeLabel setHidden:[self timeShoudHide:timeLabel.center]];
        [self.view addSubview:timeLabel];
    }
    if (_timeAppList.count == 0) {
        [indexImageView setHidden:YES];
    }else {
        [indexImageView setHidden:NO];
    }
}

- (void)buildApplications {
    
    for (ApplicationView *app in rightViewArray) {
        [app removeFromSuperview];
    }
    [rightViewArray removeAllObjects];
    for (int i=0; i < _timeAppList.count; i++) {
        RTXCAppModel *model = [_timeAppList objectAtIndex:i];
        
        ApplicationView *appView = [[ApplicationView alloc]initWithFrame:CGRectMake(160, 300, appWidth, appHeight)];
        appView.center = CGPointMake(MainWidth-14-appWidth/2, rightAppGap*i+CGRectGetMinY(rightView.frame)+rightAppGap/2);
        [self.view addSubview:appView];
        [rightViewArray addObject:appView];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",model.appIcon,[self appendAppindex:i]];
//        [appView.appImageView sd_setImageWithString:imagePath placeholderImage:[UIImage imageNamed:@"syjz_ios_l"]];
        appView.appTitleLabel.text = model.appName;
        appView.appSubTitleLabel.text = model.appIntroduction;
        [appView setHidden:[self appShoudHide:appView.center]];
        appView.tag = appTagBaseInteger + i;

        [self selectAppBgImage:appView index:i];
    }
    [self applicationViewMovedOffsetY:0.0001f];
    
}

- (void)selectAppBgImage:(ApplicationView *)app index:(int)index {
    
    int colorIndex = index%5;
    switch (colorIndex) {
        case 0:
            app.appBgImageView.image = [UIImage imageNamed:@"orange_normal"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"orange_highlight"];
            break;
            
        case 1:
            app.appBgImageView.image = [UIImage imageNamed:@"blue_normal"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"blue_highlight"];
            break;
            
        case 2:
            app.appBgImageView.image = [UIImage imageNamed:@"yellow_normal"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"yellow_highlight"];
            break;
            
        case 3:
            app.appBgImageView.image = [UIImage imageNamed:@"pupple_normal"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"pupple_highlight"];
            break;
            
        case 4:
            app.appBgImageView.image = [UIImage imageNamed:@"green_normal"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"green_highlight"];
            break;
            
        default:
            break;
    }
    
}

- (void)selectAppBgAddImage:(ApplicationView *)app index:(int)index {
    
    int colorIndex = index%5;
    app.appImageView.image = [UIImage imageNamed:@""];
    switch (colorIndex) {
        case 0:
            app.appBgImageView.image = [UIImage imageNamed:@"orange_add"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"orange_add_highlight"];
            break;
            
        case 1:
            app.appBgImageView.image = [UIImage imageNamed:@"blue_add"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"blue_add_highlight"];
            break;
            
        case 2:
            app.appBgImageView.image = [UIImage imageNamed:@"yellow_add"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"yellow_add_highlight"];
            break;
            
        case 3:
            app.appBgImageView.image = [UIImage imageNamed:@"pupple_add"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"pupple_add_highlight"];
            break;
            
        case 4:
            app.appBgImageView.image = [UIImage imageNamed:@"green_add"];
            app.appBgImageView.highlightedImage = [UIImage imageNamed:@"green_add_highlight"];
            break;
            
        default:
            break;
    }
    
}


- (NSString *)appendAppindex:(NSInteger)index {
    
    NSString *appending = @"";
    int colorIndex = index%5;
    switch (colorIndex) {
        case 0:
            appending = @"_ios_1l.png";
            break;
            
        case 1:
            appending = @"_ios_2l.png";
            break;
            
        case 2:
            appending = @"_ios_3l.png";
            break;
            
        case 3:
            appending = @"_ios_4l.png";
            break;
            
        case 4:
            appending = @"_ios_5l.png";
            break;
            
        default:
            appending = @"_ios_1l.png";
            break;
    }
    return  appending;
}

- (void)resetTimeAppRightPlace{
    
    if (!leftViewArray || leftViewArray.count == 0) {
        return;
    }
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    NSArray *arrnowHour = [timeStr componentsSeparatedByString:@":"];
    NSString *nowHour1 = [arrnowHour firstObject];
    NSString *nowHour2 = [arrnowHour lastObject];
    
    int nowHour = nowHour1.intValue;
    if (nowHour2.floatValue > 30) {
        nowHour ++;
    }
    
    TimeStampleView *timeStampleStart = [leftViewArray firstObject];
    NSArray *arrStart = [timeStampleStart.timeLabel.text componentsSeparatedByString:@":"];
    NSString *timeStrStart = [arrStart firstObject];
    int nowHourStart = timeStrStart.intValue;
    
    TimeStampleView *timeStampleEnd = [leftViewArray lastObject];
    NSArray *arrEnd = [timeStampleEnd.timeLabel.text componentsSeparatedByString:@":"];
    NSString *timeEnd = [arrEnd firstObject];
    int nowHourEnd = timeEnd.intValue;
    
    NSUInteger currentShouldIndex = 0;
    if (nowHour < nowHourStart) {
        currentShouldIndex = 0;
    }else if (nowHour > nowHourEnd) {
        currentShouldIndex = leftViewArray.count -1;
    }else {
        for (TimeStampleView *timeStample in leftViewArray) {
            
            NSArray *arr = [timeStample.timeLabel.text componentsSeparatedByString:@":"];
            NSString *timeStr1 = [arr firstObject];
            int nowHour1 = timeStr1.intValue;
            
            if (nowHour == nowHour1) {
                currentShouldIndex = [leftViewArray indexOfObject:timeStample];
                break;
            }
        }
    }
    
    selectedIndex = currentShouldIndex;
    float centerY = CGRectGetMidY(indexImageView.frame);
    TimeStampleView *timeStample = [leftViewArray objectAtIndex:selectedIndex];
    [self timeStampleViewMovedOffsetY:centerY-timeStample.center.y];
    
    float RcenterY = CGRectGetMidY(indexContainerView.frame);
    ApplicationView *selectApp = [rightViewArray objectAtIndex:selectedIndex];
    [self applicationViewMovedOffsetY:RcenterY-selectApp.center.y];
    
}
- (BOOL)timeShoudHide:(CGPoint)center {
    
    BOOL b = NO;
    if (center.y < CGRectGetMinY(leftView.frame) || center.y > CGRectGetMaxY(leftView.frame)) {
        b = YES;
    }else {
        b = NO;
    }
    return b;
}

- (BOOL)appShoudHide:(CGPoint)center {
    
    BOOL b = NO;
    if (center.y < CGRectGetMinY(rightView.frame)||center.y > CGRectGetMaxY(rightView.frame)) {
        b = YES;
    }else {
        b = NO;
    }
    return b;
}

- (void)timeStampleViewMovedOffsetY:(CGFloat)offsetY{
    
    for (TimeStampleView *timeLabel in leftViewArray) {
        CGPoint center = timeLabel.center;
        center.y += offsetY;
        
        //无限循环滑动的位置
        float timeAmountHeight = leftViewArray.count*TimeStampleHeight;
        if (center.y > CGRectGetMaxY(leftView.frame)) {
            center.y = center.y-timeAmountHeight;
        }else if (center.y < CGRectGetMinY(leftView.frame)) {
            center.y = center.y+timeAmountHeight;
        }
        
        //选中time颜色为白色
        BOOL ifContain = CGRectContainsPoint(indexImageView.frame, center);
        if (ifContain) {
            timeLabel.timeLabel.textColor = [UIColor whiteColor];
            timeLabel.timeLabel.font = timeBoldFont;
        }else {
            timeLabel.timeLabel.textColor = [UIColor greenColor];;
            timeLabel.timeLabel.font = timeFont;
        }
        
        //是否可见
        [timeLabel setHidden:[self timeShoudHide:center]];
        timeLabel.center = center;
    }
}

- (void)applicationViewMovedOffsetY:(CGFloat)offsetY{
    
    for (ApplicationView *appview in rightViewArray) {
        CGPoint center = appview.center;
        center.y += offsetY;
        
        //无限循环滑动的位置
        float appAmountHeight = rightViewArray.count*rightAppGap;
        if (center.y > CGRectGetMaxY(rightView.frame)) {
            center.y = center.y-appAmountHeight;
        }else if (center.y < CGRectGetMinY(rightView.frame)) {
            center.y = center.y+appAmountHeight;
        }
        [appview.deleteButton setHidden:YES];
        
        //透明度，大小
        float centerY = CGRectGetMidY(indexContainerView.frame);
        double offsettY = centerY-center.y;
        double offserY = fabs(centerY-center.y);
        
        if (offserY > rightAppGap*1.5) {
            [appview.appBgImageView setHighlighted:NO];
            appview.appBgImageView.alpha = 0.7f;
            appview.frame = CGRectMake(center.x, center.y, appWidth*0.8, appHeight);
            if ([self.view.subviews indexOfObject:appview] > self.view.subviews.count-3) {
                [self.view exchangeSubviewAtIndex:self.view.subviews.count-10 withSubviewAtIndex:[self.view.subviews indexOfObject:appview]];
            }
            
        }else if (offserY < rightAppGap*1.5 && offserY > rightAppGap/2) {
            [appview.appBgImageView setHighlighted:NO];
            appview.appBgImageView.alpha = 0.9f;
            appview.frame = CGRectMake(center.x, center.y, appWidth*0.9, appHeight);
            
            if ([self.view.subviews indexOfObject:appview] < self.view.subviews.count-3) {
                if (offsettY < 0) {
                    [self.view exchangeSubviewAtIndex:self.view.subviews.count-3 withSubviewAtIndex:[self.view.subviews indexOfObject:appview]];
                }else {
                    [self.view exchangeSubviewAtIndex:self.view.subviews.count-2 withSubviewAtIndex:[self.view.subviews indexOfObject:appview]];
                }
            }
            
        }else if (offserY <= rightAppGap/2) {
            [appview.appBgImageView setHighlighted:YES];
            appview.appBgImageView.alpha = 1.0;
            appview.frame = CGRectMake(center.x, center.y, appWidth, appHeight);
            [self.view exchangeSubviewAtIndex:self.view.subviews.count-1 withSubviewAtIndex:[self.view.subviews indexOfObject:appview]];
            
        }
        
        //显示或消失
        [appview setHidden:[self appShoudHide:center]];
        
        appview.center = center;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint previousTouchPoint = [touch previousLocationInView:self.view];
    CGPoint touchPoint = [touch locationInView:self.view];
    float offsetY = touchPoint.y - previousTouchPoint.y;
    
    if ([touch.view isKindOfClass:[TimeStampleView class]]) {
        
        [self timeStampleViewMovedOffsetY:offsetY];
        
    }else if ([touch.view isKindOfClass:[ApplicationView class]]) {
        
        [self applicationViewMovedOffsetY:offsetY];
    }
}

- (void)applicationViewConnectMove {
    
    //选中time
    for (ApplicationView *appView in rightViewArray) {
        CGPoint center = appView.center;
        BOOL ifContain = CGRectContainsPoint(indexContainerView.frame, center);
        if (ifContain) {
            
            selectedIndex = appView.tag - appTagBaseInteger;
            float centerY = CGRectGetMidY(indexContainerView.frame);
            [self applicationViewMovedOffsetY:centerY-appView.center.y];
            
            break;
        }
    }
    //连动
    float centerY = CGRectGetMidY(indexImageView.frame);
    TimeStampleView *selectTime = [leftViewArray objectAtIndex:selectedIndex];
    [self timeStampleViewMovedOffsetY:centerY-selectTime.center.y];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint previousTouchPoint = [touch previousLocationInView:self.view];
    CGPoint touchPoint = [touch locationInView:self.view];
    float offsetY = touchPoint.y - previousTouchPoint.y;
    
    if ([touch.view isKindOfClass:[TimeStampleView class]]) {
        //选中time
        for (TimeStampleView *timeLabel in leftViewArray) {
            CGPoint center = timeLabel.center;
            center.y += offsetY;
            BOOL ifContain = CGRectContainsPoint(indexImageView.frame, center);
            if (ifContain) {
                selectedIndex = timeLabel.tag - timeTagBaseInteger;
                break;
            }
        }
        //连动
        float centertY = CGRectGetMidY(indexImageView.frame);
        TimeStampleView *timeStample = [leftViewArray objectAtIndex:selectedIndex];
        [self timeStampleViewMovedOffsetY:centertY-timeStample.center.y];
        
        float centerY = CGRectGetMidY(indexContainerView.frame);
        ApplicationView *selectApp = [rightViewArray objectAtIndex:selectedIndex];
        [self applicationViewMovedOffsetY:centerY-selectApp.center.y];
        
    }else if ([touch.view isKindOfClass:[ApplicationView class]]) {
        
        [self applicationViewConnectMove];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint previousTouchPoint = [touch previousLocationInView:self.view];
    CGPoint touchPoint = [touch locationInView:self.view];
    float offsetY = touchPoint.y - previousTouchPoint.y;
    
    if ([touch.view isKindOfClass:[TimeStampleView class]]) {
        //选中time
        for (TimeStampleView *timeLabel in leftViewArray) {
            CGPoint center = timeLabel.center;
            center.y += offsetY;
            BOOL ifContain = CGRectContainsPoint(indexImageView.frame, center);
            if (ifContain) {
                selectedIndex = timeLabel.tag - timeTagBaseInteger;
                break;
            }
        }
        //连动
        float centertY = CGRectGetMidY(indexImageView.frame);
        TimeStampleView *timeStample = [leftViewArray objectAtIndex:selectedIndex];
        [self timeStampleViewMovedOffsetY:centertY-timeStample.center.y];
        
        float centerY = CGRectGetMidY(indexContainerView.frame);
        ApplicationView *selectApp = [rightViewArray objectAtIndex:selectedIndex];
        [self applicationViewMovedOffsetY:centerY-selectApp.center.y];
        
    }else if ([touch.view isKindOfClass:[ApplicationView class]]) {
        
        [self applicationViewConnectMove];
    }
    
}

@end
