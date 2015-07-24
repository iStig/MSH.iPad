//
//  IKNewsListCell.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKNewsListCell.h"

@implementation IKNewsListCell
@synthesize dicInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        
        // Initialization code 193h
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(32, 22, 500, 17) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.27 alpha:1]];
        [self.contentView addSubview:lblTitle];
        
        lblContent = [UILabel createLabelWithFrame:CGRectMake(32, 55, 375, 64) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithWhite:.53 alpha:1]];
        lblContent.numberOfLines = 0;
        [self.contentView addSubview:lblContent];
        
        imgvContent = [[SWImageView alloc] initWithFrame:CGRectMake(450, 54, 207, 129)];
        imgvContent.layer.borderWidth = 1;
        imgvContent.layer.borderColor = [UIColor grayColor].CGColor;
        imgvContent.delegate = self;
        [self.contentView addSubview:imgvContent];
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(32, 136, 95, 13) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithRed:.96 green:.36 blue:0 alpha:1]];
        lbl.text = @"Read More >>";
        [self.contentView addSubview:lbl];
        
        CGRect rect = lbl.frame;
        rect.origin.y += lbl.frame.size.height+3;
        rect.size = CGSizeMake(78, 1);
        
        UIView *line = [[UIView alloc] initWithFrame:rect];
        line.backgroundColor = lbl.textColor;
        [self.contentView addSubview:line];
                    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showInfo{
    lblTitle.text = [dicInfo objectForKey:@"title"];
    
    lblContent.text = [self filterHTML:[dicInfo objectForKey:@"content"]];
    [imgvContent loadURL:[dicInfo objectForKey:@"path"]];
    
    CGSize size = [lblContent.text sizeWithFont:lblContent.font constrainedToSize:CGSizeMake(lblContent.frame.size.width, FLT_MAX)];
    if (size.height>70)
        size.height = 70;
    CGRect rect = lblContent.frame;
    rect.size = size;
    lblContent.frame = rect;
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    
      html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" IKNewsListCell"];
    return html;
}

- (void)setDicInfo:(NSDictionary *)info{
    dicInfo = info;
    
    [self showInfo];
}

- (NSDictionary *)dicInfo{
    return dicInfo;
}

#pragma mark - SWImageView Delegate
- (void)swImageViewLoadFinished:(SWImageView *)swImageView{
    if (!swImageView.image)
        return;
    
    float ratioV = imgvContent.frame.size.width/imgvContent.frame.size.height;
    float ratioIMG = swImageView.image.size.width/swImageView.image.size.height;
    
    float w,h;
    
    if (ratioV>ratioIMG){
        h = swImageView.image.size.height;
        w = h*ratioV;
    }else{
        w = swImageView.image.size.width;
        h = w/ratioV;
    }
    
    float W = swImageView.image.size.width;
    float H = swImageView.image.size.height;
    
    CGRect rect = CGRectMake((W-w)/2, (H-h)/2, w, h);
    
    UIImage *img = [swImageView.image croppedImage:rect];
    
    [swImageView setImage:img];
    
    
}

@end
