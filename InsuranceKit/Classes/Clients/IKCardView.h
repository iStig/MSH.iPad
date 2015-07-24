//
//  IKCardView.h
//  InsuranceKit
//
//  Created by iStig on 14-9-28.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKCardView : UIView{


    UILabel *cardType;

}
@property (nonatomic,strong)    UIImageView *cardImageV;

- (id)initWithFrame:(CGRect)frame cardName:(NSString*)string;

@end
