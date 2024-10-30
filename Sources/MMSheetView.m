//
//  MMSheetView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"

@interface MMSheetView()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;

@end

@implementation MMSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        
        self.backgroundColor = config.splitColor;

        // 设置宽度约束
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width]
        ]];

        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        NSLayoutAnchor *lastAttribute = self.topAnchor;
        if (title.length > 0)
        {
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.titleView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                [self.titleView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                [self.titleView.topAnchor constraintEqualToAnchor:lastAttribute]
            ]];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.titleLabel.topAnchor constraintEqualToAnchor:self.titleView.topAnchor constant:config.innerMargin],
                [self.titleLabel.leftAnchor constraintEqualToAnchor:self.titleView.leftAnchor constant:config.innerMargin],
                [self.titleLabel.rightAnchor constraintEqualToAnchor:self.titleView.rightAnchor constant:-config.innerMargin],
                [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.titleView.bottomAnchor constant:-config.innerMargin]
            ]];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.bottomAnchor;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.buttonView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
            [self.buttonView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
            [self.buttonView.topAnchor constraintEqualToAnchor:lastAttribute]
        ]];

        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for (NSInteger i = 0; i < items.count; ++i)
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            btn.translatesAutoresizingMaskIntoConstraints = NO;

            // 按钮约束
            [NSLayoutConstraint activateConstraints:@[
                [btn.leftAnchor constraintEqualToAnchor:self.buttonView.leftAnchor constant:-MM_SPLIT_WIDTH],
                [btn.rightAnchor constraintEqualToAnchor:self.buttonView.rightAnchor constant:MM_SPLIT_WIDTH],
                [btn.heightAnchor constraintEqualToConstant:config.buttonHeight]
            ]];

            if (!firstButton)
            {
                firstButton = btn;
                [NSLayoutConstraint activateConstraints:@[
                    [btn.topAnchor constraintEqualToAnchor:self.buttonView.topAnchor constant:-MM_SPLIT_WIDTH]
                ]];
            }
            else
            {
                [NSLayoutConstraint activateConstraints:@[
                    [btn.topAnchor constraintEqualToAnchor:lastButton.bottomAnchor constant:-MM_SPLIT_WIDTH],
                    [btn.heightAnchor constraintEqualToAnchor:firstButton.heightAnchor]
                ]];
            }
            
            lastButton = btn;

            // 按钮样式
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight ? config.itemHighlightColor : item.disabled ? config.itemDisableColor : config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
        }
        
        // 更新最后一个按钮的底部约束
        [NSLayoutConstraint activateConstraints:@[
            [lastButton.bottomAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor constant:MM_SPLIT_WIDTH]
        ]];
        
        self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.cancelButton];
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.cancelButton.leftAnchor constraintEqualToAnchor:self.buttonView.leftAnchor],
            [self.cancelButton.rightAnchor constraintEqualToAnchor:self.buttonView.rightAnchor],
            [self.cancelButton.heightAnchor constraintEqualToConstant:config.buttonHeight],
            [self.cancelButton.topAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor constant:8]
        ]];
        
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
        // 更新整体的底部约束
        [NSLayoutConstraint activateConstraints:@[
            [self.bottomAnchor constraintEqualToAnchor:self.cancelButton.bottomAnchor]
        ]];
    }
    
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    [self hide];
    
    if (item.handler)
    {
        item.handler(btn.tag);
    }
}

- (void)actionCancel
{
    [self hide];
}

@end

@interface MMSheetViewConfig()

@end

@implementation MMSheetViewConfig

+ (MMSheetViewConfig *)globalConfig
{
    static MMSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [MMSheetViewConfig new];
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 19.0f;
        
        self.titleFontSize  = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x666666FF);
        self.splitColor         = MMHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemDisableColor   = MMHexColor(0xCCCCCCFF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"取消";
    }
    
    return self;
}

@end

