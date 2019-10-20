//
//  CurrentWeatherView.h
//  WeatherLogger
//
//  Created by Radim Langer on 17/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeatherView : UIView

- (instancetype)init;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;

@end

NS_ASSUME_NONNULL_END
