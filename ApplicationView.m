//
//  ApplicationView.m
//  HomeView
//
//  Created by 姚君 on 15/11/21.
//  Copyright © 2015年 certus. All rights reserved.
//

#import "ApplicationView.h"

#define titleFont   [UIFont systemFontOfSize:22.f]
#define subTitleFont   [UIFont systemFontOfSize:10.f]

@implementation ApplicationView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        float multiply = self.frame.size.width/200;

        _appBgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _appBgImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_appBgImageView];
        
        _appTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 30)];
        _appTitleLabel.textAlignment =NSTextAlignmentLeft;
        _appTitleLabel.textColor = [UIColor whiteColor];
        [_appTitleLabel adjustsFontSizeToFitWidth];
        _appTitleLabel.backgroundColor = [UIColor clearColor];
        _appTitleLabel.font = [UIFont systemFontOfSize:22.f*multiply];
        [self addSubview:_appTitleLabel];
        
        _appSubTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
        _appSubTitleLabel.textAlignment =NSTextAlignmentLeft;
        _appSubTitleLabel.textColor = [UIColor whiteColor];
        _appSubTitleLabel.backgroundColor = [UIColor clearColor];
        _appSubTitleLabel.numberOfLines = 2;
        _appSubTitleLabel.font = [UIFont systemFontOfSize:10.f*multiply];
        [self addSubview:_appSubTitleLabel];

        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 30, 50, 50)];
        _appImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_appImageView];
        
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_app"] forState:0];
        _deleteButton.layer.cornerRadius = 15;
        [self addSubview:_deleteButton];
        
        [_appBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [_appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-25*multiply);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_centerX).offset(38*multiply);
            make.height.equalTo(_appImageView.mas_width);
        }];
        [_appTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(27*multiply);
            make.top.equalTo(_appImageView.mas_top).offset(-5);
            make.right.equalTo(_appImageView.mas_left);
            make.height.equalTo(@(23*multiply));
        }];
        [_appSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_appTitleLabel.mas_left);
            make.top.equalTo(_appTitleLabel.mas_bottom);
            make.right.equalTo(_appTitleLabel.mas_right);
            make.height.equalTo(@(25*multiply));
        }];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];

    }
    [_deleteButton setHidden:YES];

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
