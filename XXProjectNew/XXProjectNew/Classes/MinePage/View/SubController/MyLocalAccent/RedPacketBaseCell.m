//
//  RedPacketBaseCell.m
//  XXProjectNew
//
//  Created by apple on 1/9/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "RedPacketBaseCell.h"
#import "SimpleMessage.h"
@implementation RedPacketBaseCell

/*!
自定义消息Cell的Size

@param model               要显示的消息model
@param collectionViewWidth cell所在的collectionView的宽度
@param extraHeight         cell内容区域之外的高度

@return 自定义消息Cell的Size

@discussion 当应用自定义消息时，必须实现该方法来返回cell的Size。
其中，extraHeight是Cell根据界面上下文，需要额外显示的高度（比如时间、用户名的高度等）。
一般而言，Cell的高度应该是内容显示的高度再加上extraHeight的高度。
 
 
*/

//+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
//      withCollectionViewWidth:(CGFloat)collectionViewWidth
//         referenceExtraHeight:(CGFloat)extraHeight{
//    
//    
//    return CGSizeMake(320, 50);
//    
//}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void)initialize{
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.briberyBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.briberyBackgroundView.userInteractionEnabled = YES;
    [self.bubbleBackgroundView addSubview:self.briberyBackgroundView];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.font = [UIFont systemFontOfSize:15.f];
    [self.briberyBackgroundView addSubview:self.descLabel];
    
    self.subNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    //修改
    self.subNameLabel.text = @"查看红包";
    
    self.subNameLabel.backgroundColor = [UIColor clearColor];
    self.subNameLabel.textColor = [UIColor whiteColor];
    self.subNameLabel.font = [UIFont systemFontOfSize:14];
    [self.briberyBackgroundView addSubview:self.subNameLabel];
    
    self.nameLabel = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.briberyBackgroundView addSubview:self.nameLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer * TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.bubbleBackgroundView addGestureRecognizer:TapGes];
    
}


- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        //DebugLog(@”long press end”);
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

- (void)tapGesture:(id)sender {
    [self.delegate didTapMessageCell:self.model];
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}


- (void)setAutoLayout {
    SimpleMessage *_textMessage = (SimpleMessage *)self.model.content;
    if (_textMessage) {
//                if (self.model.messageDirection == MessageDirection_SEND) {
//                    //发送
//                    self.subNameLabel.text = @"查看红包";
//                }
//                else {
//                    self.subNameLabel.text = @"领取红包";
//                }
//        self.subNameLabel.text = @"领取红包";
        self.descLabel.text = _textMessage.briberyDesc;
        self.nameLabel.text = _textMessage.briberyName;
    } else {
        //DebugLog(@”[RongIMKit]: RCMessageModel.content is NOT RCTextMessage object”);
    }
    
    CGSize __bubbleSize = CGSizeMake(223.f, 93.f);
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    self.briberyBackgroundView.frame = CGRectMake(0.f, 0.f, 223.f, 93.f);
    
    messageContentViewRect.size.width = __bubbleSize.width;
    messageContentViewRect.size.height = __bubbleSize.height;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {//接收
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.briberyBackgroundView.image = [UIImage imageNamed:@"bg_to_hongbao"];
        self.descLabel.frame = CGRectMake(7.f+13.f+31.f+9.f, 13.f, 160.f, 24.f);
        self.subNameLabel.frame = CGRectMake(7.f+13.f+31.f+9.f, 34.f, 150.f, 20.f);
        self.nameLabel.frame = CGRectMake(7.f+14.f, 93.f-21.f, 180.f, 21.f);
    } else {
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + 10 + [[RCIM sharedRCIM] globalMessagePortraitSize].width + 10);
        
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.briberyBackgroundView.image = [UIImage imageNamed:@"bg_from_hongbao"];
        self.descLabel.frame = CGRectMake(13.f+31.f+9.f, 13.f, 160.f, 24.f);
        self.subNameLabel.frame = CGRectMake(13.f+31.f+9.f, 34.f, 150.f, 20.f);
        self.nameLabel.frame = CGRectMake(14.f, 93.f-21.f, 180.f, 21.f);
    }
}


//cell大小,必重写

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    
    BOOL isGroup = YES;
    if (model.conversationType == ConversationType_PRIVATE) {
        isGroup = NO;
    }
    
    float Cell_H = 93.f;
    CGSize cellSize = CGSizeMake(collectionViewWidth, Cell_H + extraHeight);
    
    return cellSize;
    
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}


@end
