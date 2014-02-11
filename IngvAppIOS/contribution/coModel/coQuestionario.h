//
//  coQuestionario.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coWhereLocation.h"

@interface coQuestionario : NSObject
@property (strong, nonatomic) NSDate *whenDetail;
@property (nonatomic) coWhereLocation *where;
@property (nonatomic) NSNumber* floor;
@property (nonatomic) NSNumber* totalFloors;
@property (nonatomic) NSInteger whereDetail;
@property (nonatomic) NSInteger what;
@property (nonatomic) NSInteger effects;
@property (nonatomic) NSInteger paura;
@property (nonatomic) NSInteger equilibrio;
@property (nonatomic) NSInteger animali;
@property (nonatomic) NSInteger lampadari;
@property (nonatomic) NSInteger porcellane;
@property (nonatomic) NSInteger soprammobili;
@property (nonatomic) NSInteger porte;
@property (nonatomic) NSInteger liquidi;
@property (nonatomic) NSInteger quadri;
@property (nonatomic) NSInteger mobili;
@property (nonatomic) NSInteger rumore;
@property (nonatomic) NSInteger inizioRumore;
@property (nonatomic) NSInteger provenienzaRumore;
@property (nonatomic) NSInteger piscine;
@property (nonatomic) NSInteger piante;
@end
