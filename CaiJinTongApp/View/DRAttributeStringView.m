//
//  DRAttributeStringView.m
//  NSMutableAttributedTest
//
//  Created by david on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRAttributeStringView.h"
#import <CoreGraphics/CoreGraphics.h>
#define LINE_PADDING 5
#define IMAGE_WIDTH 300
#define IMAGE_HEIGHT 200
#define Question_Content_Font [UIFont systemFontOfSize:15]
#define Answer_Content_Font [UIFont systemFontOfSize:15]
#define Reask_Content_Font [UIFont systemFontOfSize:15]
#define Reask_Title_Font [UIFont systemFontOfSize:10]
#define ReAnswer_Content_Font [UIFont systemFontOfSize:15]
#define ReAnswer_Title_Font [UIFont systemFontOfSize:10]

#define Question_Content_Color [UIColor blueColor]
#define Answer_Content_Color [UIColor blackColor]
#define Reask_Content_Color [UIColor grayColor]
#define Reask_Title_Color [UIColor lightGrayColor]
#define ReAnswer_Content_Color [UIColor grayColor]
#define ReAnswer_Title_Color [UIColor lightGrayColor]
@interface DRAttributeImageView:UIImageView
@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic,assign)DRURLFileType  urlFileType;
@property (nonatomic,strong) UIActivityIndicatorView *progress;
@end

@implementation DRAttributeImageView

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    if (imageURL) {
        __block  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
        [self.progress startAnimating];
        [request setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progress stopAnimating];
                [self setUserInteractionEnabled:YES];
                self.image =  [UIImage imageWithData:[request responseData]];
            });
        }];
        
        [request setFailedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progress stopAnimating];
                self.image = [UIImage imageNamed:@"财金通logo.png"];
                [self setUserInteractionEnabled:NO];
            });
        }];
        [request startAsynchronous];
    }
}
#pragma mark property
-(UIActivityIndicatorView *)progress{
    if (!_progress) {
        _progress = [[UIActivityIndicatorView alloc] initWithFrame:self.frame];
        _progress.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _progress.hidesWhenStopped = YES;
        [self addSubview:_progress];
    }
    return _progress;
}
#pragma mark --
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
    self.drawRect = [self drawHTMLContentString:answer.answerContent withStartPoint:(CGPoint){10,self.drawRect.origin.y} withContentType:DrawingContextType_AnswerContent];
    
    for (Reaskmodel *reask in answer.reaskModelArray) {
        self.drawRect = [self drawTitleString:[NSString stringWithFormat:@"追问 发表于%@",reask.reaskDate] withStartPoint:(CGPoint){0, CGRectGetMaxY(self.drawRect)+ LINE_PADDING} withContentType:DrawingContextType_ReaskTitle];
        self.drawRect = [self drawHTMLContentString:reask.reaskContent withStartPoint:(CGPoint){10,CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReaskContent];
        NSString *isteacher = @"";
        if ([reask.reAnswerIsTeacher isEqualToString:@"1"]) {
            isteacher = @"老师";
        }
        self.drawRect = [self drawTitleString:[NSString stringWithFormat:@"%@%@ 回复 发表于%@",reask.reAnswerNickName,isteacher,reask.reaskDate] withStartPoint:(CGPoint){0,CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReAnswerTitle];
        self.drawRect = [self drawHTMLContentString:reask.reAnswerContent withStartPoint:(CGPoint){10,CGRectGetMaxY(self.drawRect) + LINE_PADDING} withContentType:DrawingContextType_ReAnswerContent];
    }
}

-(void)drawQuestionmodel:(QuestionModel*)question{
    self.drawRect = CGRectZero;
    self.drawRect = [self drawHTMLContentString:question.questionName withStartPoint:(CGPoint){self.drawRect.origin.x,self.drawRect.origin.y} withContentType:DrawingContextType_QuestionContent];
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
    style.headIndent = 0;
    style.tailIndent = self.frame.size.width-startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            
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

-(CGRect)drawHTMLContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withContentType:(DrawingContextType)type{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return CGRectZero;
    }
    CGRect startRect = (CGRect){startPoint,self.frame.size.width,0};
    for (HTMLNode *node in parser.body.children) {
        if ([node.tagName isEqualToString:@"img"]) {
            NSString *imageUrl = [node getAttributeNamed:@"src"];
            if (imageUrl) {
                startRect = [self drawImage:imageUrl withStartPoint:(CGPoint){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING}];
            }
        }else
        if ([node.tagName isEqualToString:@"p"]) {
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
    CGRect rect = (CGRect){self.frame.size.width/2 - IMAGE_WIDTH/2,startPoint.y,IMAGE_WIDTH,IMAGE_HEIGHT};
    DRAttributeImageView *imageView = [[DRAttributeImageView alloc] initWithFrame:rect];
    imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHost,imageUrl]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
    [imageView addGestureRecognizer:tap];
    [self addSubview:imageView];
    if ([[[imageUrl pathExtension] lowercaseString] isEqualToString:@"pdf"]) {
        imageView.urlFileType = DRURLFileType_PDF;
    }else
        if ([[[imageUrl pathExtension] lowercaseString] isEqualToString:@"word"]) {
            imageView.urlFileType = DRURLFileType_WORD;
        }else
            if ([[[imageUrl pathExtension] lowercaseString] isEqualToString:@"png"] || [[[imageUrl pathExtension] lowercaseString] isEqualToString:@"jpg"] || [[[imageUrl pathExtension] lowercaseString] isEqualToString:@"jpeg"]) {
                imageView.urlFileType = DRURLFileType_IMAGR;
            }else{
                imageView.urlFileType = DRURLFileType_OTHER;
            }

    return (CGRect){startPoint,IMAGE_WIDTH,IMAGE_HEIGHT};
}

-(CGRect)drawContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;
    style.tailIndent = self.frame.size.width -startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            
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
    rect = [DRAttributeStringView drawHTMLContentString:answer.answerContent withStartPoint:(CGPoint){10,0} withWidth:width withContentType:DrawingContextType_AnswerContent];
    
    for (Reaskmodel *reask in answer.reaskModelArray) {
        rect = [DRAttributeStringView drawTitleString:[NSString stringWithFormat:@"追问 发表于%@",reask.reaskDate] withStartPoint:(CGPoint){0, CGRectGetMaxY(rect)+ LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReaskTitle];
        rect = [DRAttributeStringView drawHTMLContentString:reask.reaskContent withStartPoint:(CGPoint){10,CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReaskContent];
        NSString *isteacher = @"";
        if ([reask.reAnswerIsTeacher isEqualToString:@"1"]) {
            isteacher = @"老师";
        }
        rect  = [DRAttributeStringView drawTitleString:[NSString stringWithFormat:@"%@%@ 回复 发表于%@",reask.reAnswerNickName,isteacher,reask.reaskDate] withStartPoint:(CGPoint){0,CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReAnswerTitle];
        rect = [DRAttributeStringView drawHTMLContentString:reask.reAnswerContent withStartPoint:(CGPoint){10,CGRectGetMaxY(rect) + LINE_PADDING} withWidth:width withContentType:DrawingContextType_ReAnswerContent];
    }
    return (CGRect){0,0,CGRectGetWidth(rect),CGRectGetMaxY(rect)};
}
+(CGRect)boundsRectWithQuestion:(QuestionModel*)question withWidth:(float)width{
    CGRect rect = CGRectZero;
    rect = [DRAttributeStringView drawHTMLContentString:question.questionName withStartPoint:(CGPoint){rect.origin.x,rect.origin.y} withWidth:width withContentType:DrawingContextType_QuestionContent];
    return (CGRect){0,0,CGRectGetWidth(rect),CGRectGetMaxY(rect)};
}

+(CGRect)drawTitleString:(NSString*)titleString  withStartPoint:(CGPoint)startPoint withWidth:(float)width withContentType:(DrawingContextType)type{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString];
    [string beginEditing];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;
    style.tailIndent = width-startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            
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

+(CGRect)drawHTMLContentString:(NSString*)htmlString withStartPoint:(CGPoint)startPoint withWidth:(float)width withContentType:(DrawingContextType)type{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return CGRectZero;
    }
    CGRect startRect = (CGRect){startPoint,width,0};
    for (HTMLNode *node in parser.body.children) {
        if ([node.tagName isEqualToString:@"img"]) {
            NSString *imageUrl = [node getAttributeNamed:@"src"];
            if (imageUrl) {
                startRect = (CGRect){CGRectGetMinX(startRect),CGRectGetMaxY(startRect)+LINE_PADDING + IMAGE_HEIGHT};
            }
        }else
            if ([node.tagName isEqualToString:@"p"]) {
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
    style.headIndent = 0;
    style.tailIndent = width -startPoint.x;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    switch (type) {
        case DrawingContextType_QuestionTitle:
        {
            
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