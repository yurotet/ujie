//
//  MTSignInNodeModel.h
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTSignInNodeModel : BaseModelClass

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) BOOL beSigned;
@end
