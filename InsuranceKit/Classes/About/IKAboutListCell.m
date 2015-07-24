//
//  IKAboutListCell.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAboutListCell.h"

@implementation IKAboutListCell
@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(12, 0, 260, 48) font:[UIFont boldSystemFontOfSize:19] textColor:[UIColor colorWithWhite:.68 alpha:1]];
        [self.contentView addSubview:lblTitle];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(14, 47, 285-14, 1.0f)];
        line.backgroundColor = [UIColor colorWithRed:.86 green:.85 blue:.85 alpha:1];

        
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
    
    lblTitle.textColor = selected?[UIColor colorWithRed:.99 green:.44 blue:.2 alpha:1]:[UIColor colorWithWhite:.68 alpha:1];
    line.backgroundColor = selected?[UIColor colorWithRed:.99 green:.44 blue:.2 alpha:1]:[UIColor colorWithRed:.86 green:.85 blue:.85 alpha:1];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)str{
    title = str;
    lblTitle.text = title;
}

- (NSString *)title{
    return title;
}


@end
