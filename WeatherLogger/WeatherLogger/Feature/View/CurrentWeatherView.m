//
//  CurrentWeatherView.m
//  WeatherLogger
//
//  Created by Radim Langer on 17/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

#import "CurrentWeatherView.h"

@implementation CurrentWeatherView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.backgroundColor = UIColor.whiteColor;

        self.tableView = [UITableView new];
        self.saveButton = [UIButton new];

        self.tableView.tableFooterView = [UIView new];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:self.tableView];
        [self addSubview:self.saveButton];

        [self.saveButton setBackgroundImage:[self imageWithColor:[UIColor colorNamed:@"OrangeSelectedColor"]] forState:UIControlStateHighlighted];
        [self.saveButton setBackgroundImage:[self imageWithColor:[UIColor colorNamed:@"OrangeColor"]] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        self.saveButton.clipsToBounds = YES;
        [self.saveButton.layer setCornerRadius:11];
    }

    [self setNeedsUpdateConstraints];

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat saveButtonHeight = 44;
    CGFloat tableViewAndSaveButtonPadding = 16;
    CGFloat buttonHorizontalPadding = 8;
    CGFloat buttonBottomPadding = 8;

    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) { // todo:

    }
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.saveButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.saveButton.topAnchor constant:-tableViewAndSaveButtonPadding],
        [self.saveButton.heightAnchor constraintEqualToConstant:saveButtonHeight],
        [self.saveButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:buttonHorizontalPadding],
        [self.saveButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-buttonHorizontalPadding],
        [self.saveButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-buttonBottomPadding]
    ]];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect imgBounds = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(imgBounds.size, NO, 0);
    [color setFill];
    UIRectFill(imgBounds);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
