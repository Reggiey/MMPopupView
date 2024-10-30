//
//  MMAlertView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMAlertView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"

@interface MMAlertView()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) NSArray     *actionItems;

@property (nonatomic, copy) MMPopupInputHandler inputHandler;

@end

@implementation MMAlertView

- (instancetype) initWithInputTitle:(NSString *)title
                             detail:(NSString *)detail
                        placeholder:(NSString *)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler
{
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    
    NSArray *items =@[
                      MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                      MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                      ];
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler];
}

- (instancetype) initWithConfirmTitle:(NSString*)title
                               detail:(NSString*)detail
{
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    
    NSArray *items =@[
                      MMItemMake(config.defaultTextOK, MMItemTypeHighlight, nil)
                      ];
    
    return [self initWithTitle:title detail:detail items:items];
}

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items
{
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:nil inputHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(MMPopupInputHandler)inputHandler {
    self = [super init];
    
    if ( self ) {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
        
        self.type = MMPopupTypeAlert;
        self.withKeyboard = (inputHandler!=nil);
        
        self.inputHandler = inputHandler;
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.widthAnchor constraintEqualToConstant:config.width]
        ]];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        NSLayoutAnchor *lastAttribute = self.topAnchor;
        if ( title.length > 0 ) {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.titleLabel.topAnchor constraintEqualToAnchor: lastAttribute constant:config.innerMargin],
                [self.titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:config.innerMargin],
                [self.titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-config.innerMargin]
            ]];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.bottomAnchor;
        }
        
        if ( detail.length > 0 ) {
            self.detailLabel = [UILabel new];
            [self addSubview:self.detailLabel];
            self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.detailLabel.topAnchor constraintEqualToAnchor: lastAttribute constant:5],
                [self.detailLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:config.innerMargin],
                [self.detailLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-config.innerMargin]
            ]];
            self.detailLabel.textColor = config.detailColor;
            self.detailLabel.textAlignment = NSTextAlignmentCenter;
            self.detailLabel.font = [UIFont systemFontOfSize:config.detailFontSize];
            self.detailLabel.numberOfLines = 0;
            self.detailLabel.backgroundColor = self.backgroundColor;
            self.detailLabel.text = detail;
            
            lastAttribute = self.detailLabel.bottomAnchor;
        }
        
        if (self.inputHandler) {
            self.inputView = [UITextField new];
            [self addSubview:self.inputView];
            self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.inputView.topAnchor constraintEqualToAnchor: lastAttribute constant:10],
                [self.inputView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:config.innerMargin],
                [self.inputView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-config.innerMargin],
                [self.inputView.heightAnchor constraintEqualToConstant:40]
            ]];
            self.inputView.backgroundColor = self.backgroundColor;
            self.inputView.layer.borderWidth = MM_SPLIT_WIDTH;
            self.inputView.layer.borderColor = config.splitColor.CGColor;
            self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            self.inputView.leftViewMode = UITextFieldViewModeAlways;
            self.inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputView.placeholder = inputPlaceholder;
            
            lastAttribute = self.inputView.bottomAnchor;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.buttonView.topAnchor constraintEqualToAnchor: lastAttribute constant:config.innerMargin],
            [self.buttonView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
            [self.buttonView.rightAnchor constraintEqualToAnchor:self.rightAnchor]
        ]];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i ) {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            
            if (items.count <= 2) {
                [NSLayoutConstraint activateConstraints:@[
                    [btn.topAnchor constraintEqualToAnchor:self.buttonView.topAnchor],
                    [btn.bottomAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor],
                    [btn.heightAnchor constraintEqualToConstant:config.buttonHeight],
                ]];
                
                if (!firstButton) {
                    firstButton = btn;
                    [NSLayoutConstraint activateConstraints:@[
                        [btn.leftAnchor constraintEqualToAnchor:self.buttonView.leftAnchor constant:-MM_SPLIT_WIDTH]
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [btn.leftAnchor constraintEqualToAnchor:lastButton.rightAnchor constant:-MM_SPLIT_WIDTH],
                        [btn.widthAnchor constraintEqualToAnchor:firstButton.widthAnchor]
                    ]];
                }
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [btn.leftAnchor constraintEqualToAnchor:self.buttonView.leftAnchor],
                    [btn.rightAnchor constraintEqualToAnchor:self.buttonView.rightAnchor],
                    [btn.heightAnchor constraintEqualToConstant:config.buttonHeight],
                ]];
                
                if (!firstButton) {
                    firstButton = btn;
                    [NSLayoutConstraint activateConstraints:@[
                        [btn.topAnchor constraintEqualToAnchor:self.buttonView.topAnchor constant:-MM_SPLIT_WIDTH]
                    ]];
                } else {
                    [NSLayoutConstraint activateConstraints:@[
                        [btn.topAnchor constraintEqualToAnchor:lastButton.bottomAnchor constant:-MM_SPLIT_WIDTH],
                        [btn.widthAnchor constraintEqualToAnchor:firstButton.widthAnchor]
                    ]];
                }
            }
            
            lastButton = btn;
            
            [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (item==items.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
        }
        
        // 确保禁用自动翻译约束
        lastButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;

        // 清除以前的约束
        [lastButton removeConstraints:lastButton.constraints];
        [self removeConstraints:self.constraints];

        // 创建新的约束
        NSMutableArray *constraints = [NSMutableArray array];

        if (items.count <= 2) {
            [constraints addObject:[lastButton.trailingAnchor constraintEqualToAnchor:self.buttonView.trailingAnchor constant:MM_SPLIT_WIDTH]];
        } else {
            [constraints addObject:[lastButton.bottomAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor constant:MM_SPLIT_WIDTH]];
        }

        // 添加总是存在的约束
        [constraints addObject:[self.bottomAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor]];

        // 激活约束
        [NSLayoutConstraint activateConstraints:constraints];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    if ( self.withKeyboard && (btn.tag==1) )
    {
        if ( self.inputView.text.length > 0 )
        {
            [self hide];
        }
    }
    else
    {
        [self hide];
    }
    
    if ( self.inputHandler && (btn.tag>0) )
    {
        self.inputHandler(self.inputView.text);
    }
    else
    {
        if ( item.handler )
        {
            item.handler(btn.tag);
        }
    }
}

- (void)notifyTextChange:(NSNotification *)n
{
    if ( self.maxInputLength == 0 )
    {
        return;
    }
    
    if ( n.object != self.inputView )
    {
        return;
    }
    
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;

    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString mm_truncateByCharLength:self.maxInputLength];
        }
    }
}

- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.inputView resignFirstResponder];
}

@end


@interface MMAlertViewConfig()

@end

@implementation MMAlertViewConfig

+ (MMAlertViewConfig *)globalConfig
{
    static MMAlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [MMAlertViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 275.0f;
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 25.0f;
        self.cornerRadius   = 5.0f;

        self.titleFontSize  = 18.0f;
        self.detailFontSize = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x333333FF);
        self.detailColor        = MMHexColor(0x333333FF);
        self.splitColor         = MMHexColor(0xCCCCCCFF);

        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
    }
    
    return self;
}

@end
