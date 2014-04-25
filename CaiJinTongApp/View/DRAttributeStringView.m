//
//  DRAttributeStringView.m
//  NSMutableAttributedTest
//
//  Created by david on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRAttributeStringView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "SDWebImageManager.h"
#define LINE_PADDING PAD(5,3)
#define IMAGE_WIDTH PAD(300,200)
#define IMAGE_HEIGHT PAD(200,150)
#define FLAG_HEIGHT PAD(44,44)

#define Question_Title_Font [UIFont systemFontOfSize:PAD(22,14)]
#define Question_Content_Font [UIFont systemFontOfSize:PAD(21,13)]
#define Answer_Content_Font [UIFont systemFontOfSize:PAD(21,13)]
#define Reask_Content_Font [UIFont systemFontOfSize:PAD(22,14)]
#define Reask_Title_Font [UIFont systemFontOfSize:10]
#define ReAnswer_Content_Font [UIFont systemFontOfSize:PAD(22,14)]
#define ReAnswer_Title_Font [UIFont systemFontOfSize:10]

#define Question_Title_Color [UIColor colorWithRed:0.082 green:0.416 blue:0.737 alpha:1.000]
#define Question_Content_Color [UIColor colorWithWhite:0.435 alpha:1.000]
#define Answer_Content_Color [UIColor colorWithWhite:0.435 alpha:1.000]
#define Reask_Content_Color [UIColor grayColor]
#define Reask_Title_Color [UIColor lightGrayColor]
#define ReAnswer_Content_Color [UIColor grayColor]
#define ReAnswer_Title_Color [UIColor lightGrayColor]

@interface DRAttributeImageView:UIImageView<SDWebImageManagerDelegate>
@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic,assign)DRURLFileType  urlFileType;
@end

@implementation DRAttributeImageView
#pragma mark SDWebImageManagerDelegate
-(void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error{
    [self setUserInteractionEnabled:NO];
    self.image = [UIImage imageNamed:@"logo.png"];
}

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image{
    [self setUserInteractionEnabled:YES];
    self.image = image;
}
#pragma mark --

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    if (imageURL) {
         self.image = [UIImage imageNamed:@"logo.png"];
        [[SDWebImageManager sharedManager] downloadWithURL:imageURL delegate:self];
    }
}

@end
typedef enum {
    DrawingContextType_QuestionContent,
    DrawingContextType_QuestionTitle,
    DrawingContextType_AnswerTitle,
    DrawingContextType_AnswerContent,
    DrawingContextType_ReaskTitle,
    DrawingContextType_ReaskContent,
    DrawingContextType_ReAnswerTitle,
    DrawingContextType_ReAnswerContent
}DrawingContextType;
@interface DRAttributeStringView ()
@property (assign,nonatomic) CGRect drawRect;
@end

@implementation DRAttributeStringView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [UIColor lightGrayColor];
    return self;
}

-(void)drawAnswermodel:(AnswerModel*)answer{
    self.drawRect = CGRectZero;
    self.drawRect = [self drawHTMLContentString:answer.answerContent withStartPoint:(CGPoint){PAD(10,0),self.drawRect.origin.y} withContentType:DrawingContextType_AnswerContent withTitle:nil];
    
    for (Reaskmodel *reask in answer.reaskModelArray) {
        self.drawRect = [self drawTitleString:[NSString stringWithFormat:@"追问 发表于%@",reask.reaskDate] withStartPoint:(CGPoint){0, CGRectGetMaxY(self.drawRect)+ LINE_PADDING} withContentType:DrawingContextType_ReaskTitle];
        self.drawRect = [self drawHTMLContentString:reask.reaskContent withStartPoint:(CGPoint){PAD(10,0),CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReaskContent withTitle:nil];
        NSString *isteacher = @"";
        if ([reask.reAnswerIsTeacher isEqualToString:@"1"]) {
            isteacher = @"老师";
        }
        if (reask.reAnswerContent && ![reask.reAnswerContent isEqualToString:@""]) {
            self.drawRect = [self drawTitleString:[NSString stringWithFormat:@"%@%@ 回复 发表于%@",reask.reAnswerNickName,isteacher,reask.reaskDate] withStartPoint:(CGPoint){0,CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReAnswerTitle];
            self.drawRect = [self drawHTMLContentString:reask.reAnswerContent withStartPoint:(CGPoint){PAD(10,0),CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReAnswerContent withTitle:nil];
        }
    }
}

-(void)drawQuestionmodel:(QuestionModel*)question{
    self.drawRect = CGRectZero;
    self.drawRect = [self drawHTMLContentString:question.questionName withStartPoint:(CGPoint){self.drawRect.origin.x,self.drawRect.origin.y} withContentType:DrawingContextType_QuestionContent withTitle:question.questiontitle];
}

-(void)drawQuestionModelWithTruncate:(QuestionModel*)question withTruncateHeight:(float)height{
    NSError *error = nil;
    CGPoint startPoint = (CGPoint){0,0};
    HTMLParser *parser = [[HTMLParser alloc] initWithString:question.questionName error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return ;
    }
    CGRect startRect = (CGRect){startPoint,self.frame.size.width,0};
    for (HTMLNode *node in parser.body.children) {
        if ([node.tagName isEqualToString:@"img"]) {
            NSString *imageUrl = [node getAttributeNamed:@"src"];
            if (imageUrl) {
                startRect = [self drawImage:imageUrl withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING}];
                startPoint = (CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING};
                if (CGRectGetMaxY(startRect) >= height) {
                    break;
                }
            }
        }else
            if ([node.tagName isEqualToString:@"p"]) {
                if (node.contents) {
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:node.contents];
                    [string beginEditing];
                    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
                    style.headIndent = 0;
                    //TODO:李宏亮修改
                    style.paragraphSpacing = 5;
                    style.lineSpacing = 5;
                    style.tailIndent = self.frame.size.width -startPoint.x;
                    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
                    [string addAttribute:NSForegroundColorAttributeName value:Question_Content_Color range:NSMakeRange(0, string.length)];
                    [string addAttribute:NSFontAttributeName value:Question_Content_Font range:NSMakeRange(0, string.length)];
                    [string endEditing];
                    CGRect rect = [self getAttributeStringRectWithAttributeString:string withStartPoint:startPoint];
                    if (CGRectGetMinY(rect) >= height) {
                        break;
                    }
                    float oneLineHeight = [string boundingRectWithSize:(CGSize){self.frame.size.width - startPoint.x*2,MAXFLOAT} options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading context:nil].size.height;
                    if (CGRectGetMaxY(rect) > height) {
                        rect = (CGRect){rect.origin,rect.size.width,height};
                       style.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping;
                    }
                    if (height - CGRectGetMinY(rect) <= oneLineHeight) {
                        style.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping;
                    }
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSaveGState(context);
                    CGContextTranslateCTM(context, startPoint.x,startPoint.y);
                    [string drawInRect: (CGRect){0,0,rect.size}];
                    CGContextRestoreGState(context);
                    startRect = rect;
                    startPoint = (CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING};
                    if (height - CGRectGetMinY(rect) <= oneLineHeight) {
                        break;
                    }
                }
            }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0,0);
     CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    if (self.answerModel) {
        [self drawAnswermodel:self.answerModel];
    }
    if (self.questionModel) {
        [self drawQuestionmodel:self.questionModel];
//        if (self.isTruncate) {
//            [self drawQuestionModelWithTruncate:self.questionModel withTruncateHeight:self.truncateHeight];
//        }else{
//            [self drawQuestionmodel:self.questionModel];
//        }
    }
    
    _answerModel = nil;
    _questionModel = nil;
}

-(CGRect)getAttributeStringRectWithAttributeString:(NSMutableAttributedString*)attriString withStartPoint:(CGPoint)startPoint{
 CGRect rect = [attriString boundingRectWithSize:(CGSize){self.frame.size.width - startPoint.x*2,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect;
}
-(CGRect)drawTitleString:(NSString*)titleString  withStartPoint:(CGPoint)startPoint withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.headIndent = 0;
    //TODO:李宏亮修改
    style.paragraphSpacing = 5;
    style.lineSpacing = 5;
    style.tailIndent = self.frame.size.width-startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_QuestionContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_AnswerTitle:
        {
            
        }
            break;
        case DrawingContextType_AnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Answer_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Answer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:ReAnswer_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        default:
            break;
    }

    [string endEditing];
    CGRect rect = [self getAttributeStringRectWithAttributeString:string withStartPoint:startPoint];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, startPoint.x,startPoint.y);
    [string drawInRect: (CGRect){0,0,rect.size}];
    CGContextRestoreGState(context);
    return (CGRect){startPoint,rect.size};
}

-(CGRect)drawHTMLContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withContentType:(DrawingContextType)type withTitle:(NSString*)title{
    CGRect startRect = (CGRect){startPoint,self.frame.size.width,0};
    if (!htmlString || [htmlString isEqualToString:@""]) {
        return startRect;
    }
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return startRect;
    }
    if (title && ![title isEqualToString:@""]) {
        startRect = [self drawContentString:title withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING} withContentType:DrawingContextType_QuestionTitle];
    }
   
    for (HTMLNode *node in parser.body.children) {
        if ([node.tagName isEqualToString:@"img"]) {
            NSString *imageUrl = [node getAttributeNamed:@"src"];
            if (imageUrl) {
                startRect = [self drawImage:imageUrl withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING}];
            }
        }else
        if ([node.tagName isEqualToString:@"p"]) {
            for (HTMLNode *child in node.children) {
                if ([child.tagName isEqualToString:@"img"]) {
                    NSString *imageUrl = [child getAttributeNamed:@"src"];
                    if (imageUrl) {
                        startRect = [self drawImage:imageUrl withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING}];
                    }
                }
            }
            if (node.contents) {
                startRect = [self drawContentString:node.contents withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING} withContentType:type];
            }
        }
    }
    return (CGRect){startRect.origin,startRect.size};
}

-(void)clickedImageView:(UITapGestureRecognizer*)tapGesture{
     DRAttributeImageView *imageview = (DRAttributeImageView*) tapGesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(drAttributeStringView:clickedFileURL:withFileType:)]) {
        [self.delegate drAttributeStringView:self clickedFileURL:imageview.imageURL withFileType:imageview.urlFileType];
    }
}

-(CGRect)drawImage:(NSString*)imageUrl withStartPoint:(CGPoint)startPoint{
    CGRect rect = (CGRect){self.frame.size.width/2 - FLAG_HEIGHT/2,startPoint.y,FLAG_HEIGHT,FLAG_HEIGHT};;
    NSString *extension = [[imageUrl pathExtension] lowercaseString];

    DRAttributeImageView *imageView = [[DRAttributeImageView alloc] initWithFrame:rect];
    if (!extension) {
        imageView.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
        imageView.urlFileType = DRURLFileType_OTHER;
    }else
    if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
        imageView.frame = (CGRect){self.frame.size.width/2 - IMAGE_WIDTH/2,startPoint.y,IMAGE_WIDTH,IMAGE_HEIGHT};
        imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHost,imageUrl]];
        imageView.urlFileType = DRURLFileType_IMAGR;
    }else
    if ([extension isEqualToString:@"pdf"]) {
        imageView.image = [UIImage imageNamed:@"pdf.png"];
        imageView.urlFileType = DRURLFileType_PDF;
    }else
    if ([extension isEqualToString:@"doc"] || [extension isEqualToString:@"docx"]) {
        imageView.image = [UIImage imageNamed:@"word.png"];
        imageView.urlFileType = DRURLFileType_WORD;
    }else
    if ([extension isEqualToString:@"txt"]) {
        imageView.image = [UIImage imageNamed:@"text.png"];
        imageView.urlFileType = DRURLFileType_TEXT;
    }else
    if ([extension isEqualToString:@"ppt"]) {
        imageView.image = [UIImage imageNamed:@"ppt.png"];
        imageView.urlFileType = DRURLFileType_PPT;
    }else
        if ([extension isEqualToString:@"gif"]) {
        imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHost,imageUrl]];
        imageView.urlFileType = DRURLFileType_GIF;
    }else{
        imageView.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
        imageView.urlFileType = DRURLFileType_OTHER;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
    [imageView addGestureRecognizer:tap];
    [self addSubview:imageView];
    
    if (imageView.urlFileType == DRURLFileType_IMAGR) {
        return (CGRect){startPoint,IMAGE_WIDTH,IMAGE_HEIGHT};
    }else{
        return (CGRect){startPoint,FLAG_HEIGHT,FLAG_HEIGHT};
    }
}

-(CGRect)drawContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.headIndent = 0;
    //TODO:李宏亮修改
    style.paragraphSpacing = 5;
    style.lineSpacing = 5;
    style.tailIndent = self.frame.size.width -startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_QuestionContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_AnswerTitle:
        {
            
        }
            break;
        case DrawingContextType_AnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Answer_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Answer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:ReAnswer_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        default:
            break;
    }
    
    [string endEditing];
    CGRect rect = [self getAttributeStringRectWithAttributeString:string withStartPoint:startPoint];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, startPoint.x,startPoint.y);
     [string drawInRect: (CGRect){0,0,rect.size}];
    CGContextRestoreGState(context);
   
    return (CGRect){startPoint,rect.size};
}


#pragma mark Static method

+(CGRect)boundsRectWithAnswer:(AnswerModel*)answer withWidth:(float)width{
    CGRect rect = CGRectZero;
    rect = [DRAttributeStringView drawHTMLContentString:answer.answerContent withStartPoint:(CGPoint){PAD(10,0),0} withWidth:width withContentType:DrawingContextType_AnswerContent withTitle:nil];
    
    for (Reaskmodel *reask in answer.reaskModelArray) {
        rect = [DRAttributeStringView drawTitleString:[NSString stringWithFormat:@"追问 发表于%@",reask.reaskDate] withStartPoint:(CGPoint){0, CGRectGetMaxY(rect)+ LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReaskTitle];
        rect = [DRAttributeStringView drawHTMLContentString:reask.reaskContent withStartPoint:(CGPoint){PAD(10,0),CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReaskContent withTitle:nil];
        NSString *isteacher = @"";
        if ([reask.reAnswerIsTeacher isEqualToString:@"1"]) {
            isteacher = @"老师";
        }
        if (reask.reAnswerContent && ![reask.reAnswerContent isEqualToString:@""]){
            rect  = [DRAttributeStringView drawTitleString:[NSString stringWithFormat:@"%@%@ 回复 发表于%@",reask.reAnswerNickName,isteacher,reask.reaskDate] withStartPoint:(CGPoint){0,CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReAnswerTitle];
            rect = [DRAttributeStringView drawHTMLContentString:reask.reAnswerContent withStartPoint:(CGPoint){PAD(10,0),CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReAnswerContent withTitle:nil];
        }
    }
    return (CGRect){0,0,CGRectGetWidth(rect),CGRectGetMaxY(rect)};
}
+(CGRect)boundsRectWithQuestion:(QuestionModel*)question withWidth:(float)width{
    CGRect rect = CGRectZero;
    rect = [DRAttributeStringView drawHTMLContentString:question.questionName withStartPoint:(CGPoint){rect.origin.x,rect.origin.y} withWidth:width withContentType:DrawingContextType_QuestionContent withTitle:question.questiontitle];
    return (CGRect){0,0,CGRectGetWidth(rect),CGRectGetMaxY(rect)};
}

+(CGRect)drawTitleString:(NSString*)titleString  withStartPoint:(CGPoint)startPoint withWidth:(float)width withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.headIndent = 0;
    //TODO:李宏亮修改
    style.paragraphSpacing = 5;
    style.lineSpacing = 5;
    style.tailIndent = width-startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_QuestionContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_AnswerTitle:
        {
            
        }
            break;
        case DrawingContextType_AnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Answer_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Answer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:ReAnswer_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        default:
            break;
    }
    [string endEditing];
    CGRect rect = [DRAttributeStringView getAttributeStringRectWithAttributeString:string withStartPoint:startPoint withWidth:width];
    return (CGRect){startPoint,rect.size};
}

+(CGRect)drawHTMLContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withWidth:(float)width withContentType:(DrawingContextType)type withTitle:(NSString*)title{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return CGRectZero;
    }
    CGRect startRect = (CGRect){startPoint,width,0};
    if (title && ![title isEqualToString:@""]) {
        startRect = [DRAttributeStringView drawContentString:title withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING} withWidth:width withContentType:DrawingContextType_QuestionTitle];
    }
    for (HTMLNode *node in parser.body.children) {
        if ([node.tagName isEqualToString:@"img"]) {
            NSString *imageUrl = [node getAttributeNamed:@"src"];
            if (imageUrl) {
                NSString *extension = [[imageUrl pathExtension] lowercaseString];
                if (extension) {
                    if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
                        startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + IMAGE_HEIGHT};
                    }else{
                        startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + FLAG_HEIGHT};
                    }
                }else{
                    startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + FLAG_HEIGHT};
                }
                
                
            }
        }else
            if ([node.tagName isEqualToString:@"p"]) {
                for (HTMLNode *child in node.children) {
                    if ([child.tagName isEqualToString:@"img"]) {
                        NSString *imageUrl = [child getAttributeNamed:@"src"];
                        if (imageUrl) {
                            NSString *extension = [[imageUrl pathExtension] lowercaseString];
                            if (extension) {
                                if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
                                    startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + IMAGE_HEIGHT};
                                }else{
                                    startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + FLAG_HEIGHT};
                                }
                            }else{
                                startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + FLAG_HEIGHT};
                            }
                            
                            
                        }
                    }
                }
                if (node.contents) {
                    startRect = [DRAttributeStringView drawContentString:node.contents withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING} withWidth:width withContentType:type];
                }
            }
    }
    return (CGRect){startRect.origin,startRect.size};
}
+(CGRect)drawContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withWidth:(float)width withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.headIndent = 0;
    //TODO:李宏亮修改
    style.paragraphSpacing = 5;
    style.lineSpacing = 5;
    style.tailIndent = width -startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_QuestionContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Question_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Question_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_AnswerTitle:
        {
            
        }
            break;
        case DrawingContextType_AnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Answer_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Answer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReaskContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:Reask_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerTitle:
        {
            [string addAttribute:NSForegroundColorAttributeName value:ReAnswer_Title_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Title_Font range:NSMakeRange(0, string.length)];
        }
            break;
        case DrawingContextType_ReAnswerContent:
        {
            [string addAttribute:NSForegroundColorAttributeName value:Reask_Content_Color range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:ReAnswer_Content_Font range:NSMakeRange(0, string.length)];
        }
            break;
        default:
            break;
    }
    [string endEditing];
    CGRect rect = [DRAttributeStringView getAttributeStringRectWithAttributeString:string withStartPoint:startPoint withWidth:width];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, startPoint.x,startPoint.y);
    [string drawInRect: (CGRect){0,0,rect.size}];
    CGContextRestoreGState(context);
    
    return (CGRect){startPoint,rect.size};
}

+(CGRect)getAttributeStringRectWithAttributeString:(NSMutableAttributedString*)attriString withStartPoint:(CGPoint)startPoint withWidth:(float)width{
    CGRect rect = [attriString boundingRectWithSize:(CGSize){width - startPoint.x*2,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect;
}
#pragma mark --

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[DRAttributeImageView class]]) {
            if (CGRectContainsPoint(subView.frame, point)) {
                return subView;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
#pragma mark property
-(CGRect)attributeStringRect{
    return (CGRect){0,0,self.drawRect.size};
}
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    [self setNeedsDisplay];
}

-(void)setAnswerModel:(AnswerModel *)answerModel{
    _answerModel = answerModel;
    [self setNeedsDisplay];
}
#pragma mark --
@end
