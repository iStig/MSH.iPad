//
//  KindInformation.m
//  SummerMatch
//
//  Created by mac on 13-6-17.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "IKApplyClaimsPhotoInformation.h"


@implementation IKApplyClaimsPhotoInformation

static IKApplyClaimsPhotoInformation *applyClaimsPhotoInformation = nil;



+(IKApplyClaimsPhotoInformation *)sharedApplyClaimsPhotoInformation
{
	@synchronized(self)
	{
		if (!applyClaimsPhotoInformation)
		{
			applyClaimsPhotoInformation = [[self alloc] init];
			//_kindArr = [[NSArray alloc] init];
		}
		return applyClaimsPhotoInformation;
	}
	
}

+(id)alloc
{
	@synchronized(self)
	{
		if (!applyClaimsPhotoInformation)
		{
			applyClaimsPhotoInformation = [super alloc];
		}
		return applyClaimsPhotoInformation;
	}
	
}

-(id)init
{

	if (self = [super init]) {
		self.photoCardArr = [[NSMutableArray alloc] init];
        
        self.photoOtherArr = [[NSMutableArray alloc] init];
        self.photoPaymentArr = [[NSMutableArray alloc] init];
		self.selectArray = [[NSMutableArray alloc] init];
//
	}
	return self;
}


@end
