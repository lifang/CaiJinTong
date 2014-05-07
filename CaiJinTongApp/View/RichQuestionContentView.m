//
//  RichQuestionContentView.m
//  CaiJinTongApp
//
//  Created by david on 14-4-22.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "RichQuestionContentView.h"
#define RichContent_imageMaxHeight 100
#define RichContent_TypeImageHeight 40
#define RichContent_Pading 10
#define Question_Color ([Utility colorWithHex:0x6F6F6F])
#define Question_Font ([UIFont systemFontOfSize:15])

@interface RichImagaeView : UIImageView
@property (nonatomic,strong) RichContextObj *richContentObj;
@end

@implementation RichImagaeView

@end

@implementation RichQuestionContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0,0);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    for (RichContextObj *richContent in self.contentObjsArray){
        if (richContent.richContentType == DRURLFileType_STRING) {
            [richContent.richAttributeString drawInRect:richContent.richContentRect];
        }else{
            RichImagaeView *imageView = [[RichImagaeView alloc] initWithFrame:richContent.richContentRect];
            imageView.richContentObj = richContent;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClickedTapGesture:)];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:tapGesture];
            [self addSubview:imageView];
            
            if (richContent.richContentType == DRURLFileType_IMAGR) {
                [imageView setImageWithURL:richContent.richFileUrl placeholderImage:[UIImage imageNamed:@"_money.png"]];
            }else{
                switch (richContent.richContentType) {
                    case DRURLFileType_PDF:
                        imageView.image = [UIImage imageNamed:@"pdf.png"];
                        break;
                    case DRURLFileType_WORD:
                        imageView.image = [UIImage imageNamed:@"word.png"];
                        break;
                    case DRURLFileType_TEXT:
                        imageView.image = [UIImage imageNamed:@"text.png"];
                        break;
                    case DRURLFileType_PPT:
                        imageView.image = [UIImage imageNamed:@"ppt.png"];
                        break;
                    case DRURLFileType_GIF: //表情
                        [imageView setImageWithURL:richContent.richFileUrl placeholderImage:[UIImage imageNamed:@"Q&A-myq_15.png"]];
                    case DRURLFileType_OTHER:
                    default:
                        imageView.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
                        break;
                }

            }
        }
    }
    
}

-(void)imageViewClickedTapGesture:(UITapGestureRecognizer*)tapGesture{
    RichImagaeView *imageView = (RichImagaeView*)(tapGesture.view);
    if (self.tapedimageTypeBlock) {
        self.tapedimageTypeBlock(imageView.richContentObj);
    }
}

///设置显示内容，contentArray 存放RichContextObj
-(void)addContentArray:(NSArray*)contentArray withWidth:(float)width finished:(void (^)(RichContextObj *richContent))finished {
    self.tapedimageTypeBlock = finished;
    self.contentObjsArray = contentArray;
//    [RichQuestionContentView richQuestionContentStringWithRichContentObjs:contentArray withWidth:260];
    [self setNeedsDisplay];
}
///组合所有的RichContextObj 内容得到高度，richContentArray存放RichContextObj对象数组
+(CGRect)richQuestionContentStringWithRichContentObjs:(NSArray*)richContentArray withWidth:(float)width{
    CGRect lastRect = (CGRect){0,0,width,0};
    for (RichContextObj *richContent in richContentArray) {
        if (richContent.richContentType == DRURLFileType_STRING) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:richContent.richContext];
            richContent.richContentRect = [RichQuestionContentView drawAttributeStringStartPoint:(CGPoint){CGRectGetMinX(lastRect),CGRectGetMaxY(lastRect)} withString:string withWidth:width];
            richContent.richAttributeString = string;
            lastRect = richContent.richContentRect;
        }else
        if (richContent.richContentType == DRURLFileType_IMAGR) {
            richContent.richContentRect = (CGRect){width/2- RichContent_imageMaxHeight/2,CGRectGetMaxY(lastRect)+RichContent_Pading,RichContent_imageMaxHeight,RichContent_imageMaxHeight};
            lastRect = (CGRect){0,CGRectGetMaxY(lastRect)+RichContent_Pading,width,RichContent_imageMaxHeight};
        }else{
            richContent.richContentRect = (CGRect){width/2- RichContent_TypeImageHeight/2,CGRectGetMaxY(lastRect)+RichContent_Pading,RichContent_TypeImageHeight,RichContent_TypeImageHeight};
            lastRect = (CGRect){0,CGRectGetMaxY(lastRect)+RichContent_Pading,width,RichContent_TypeImageHeight};
        }
    }
    
    return lastRect;
}

///画string 并返回位置
+(CGRect)drawAttributeStringStartPoint:(CGPoint)startPoint withString:(NSMutableAttributedString*)contentAttributeString withWidth:(float)width{
    if (!contentAttributeString || [contentAttributeString.string isEqualToString:@""]) {
        return (CGRect){startPoint,width,0};
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified|NSTextAlignmentNatural;
    style.headIndent = 0;
    style.tailIndent = 0;
    style.lineSpacing = 5;
    style.paragraphSpacing = 5;
    style.paragraphSpacingBefore = 0;
    [contentAttributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, contentAttributeString.length)];
    [contentAttributeString addAttribute:NSForegroundColorAttributeName value:Question_Color range:NSMakeRange(0, contentAttributeString.length)];
    [contentAttributeString addAttribute:NSFontAttributeName value:Question_Font range:NSMakeRange(0, contentAttributeString.length)];
    CGRect rect = [contentAttributeString boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    CGRect drawRect = (CGRect){startPoint,width,rect.size.height};
//    [string drawInRect:drawRect];
    return drawRect;
}
@end
