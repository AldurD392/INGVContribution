//
//  coQuestionario.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coWhereLocation.h"

#define LATITUDE_KEY    @"latitude"
#define LONGITUDE_KEY   @"longitude"
#define STATO_KEY       @"stato"
#define REGIONE_KEY     @"regione"
#define PROVINCIA_KEY   @"provincia"
#define COMUNE_KEY      @"comune"
#define FRAZIONE_KEY    @"frazione"
#define VIA_KEY         @"via"

#define TERREMOTO_ID    @"terremoto"
#define UTENTE_ID    	@"utente"
#define WHEN_DETAIL    @"whenDetail"
#define WHEN_COMPILED   @"whenCompiled"
#define WHERE    @"where"
#define FLOOR    @"floor"
#define TOTAL_FLOORS @"floors"
#define WHERE_DETAIL    @"whereDetail"
#define WHAT    @"what"
#define EFFECTS    @"effects"
#define PAURA    @"paura"
#define EQUILIBRIO    @"equilibrio"
#define ANIMALI    @"animali"
#define LAMPADARI    @"lampadari"
#define PORCELLANE    @"porcellane"
#define SOPRAMMOBILI    @"soprammobili"
#define PORTE    @"porte"
#define LIQUIDI    @"liquidi"
#define QUADRI    @"quadri"
#define MOBILI    @"mobili"
#define RUMORE    @"rumore"
#define INIZIO_RUMORE    @"inizioRumore"
#define PROVENIENZA_RUMORE    @"provenienzaRumore"
#define PISCINE    @"piscine"
#define PIANTE    @"piante"
#define ALTRI_FENOMENI    @"altriFenomeni"
#define DANNI    @"danni"
#define STRUTTURA    @"struttura"
#define MURI    @"muri"
#define TEGOLE    @"tegole"
#define CAMINI    @"camini"


@interface coQuestionario : NSObject
@property (strong, nonatomic) NSString *terremotoID;
@property (strong, nonatomic) NSString *utenteID;
@property (strong, nonatomic) NSDate *whenDetail;
@property (strong, nonatomic) NSDate *whenCompiled;
@property (nonatomic) NSMutableDictionary *where;
@property (nonatomic) NSNumber* floor;
@property (nonatomic) NSNumber* totalFloors;
@property (nonatomic) NSNumber* whereDetail;
@property (nonatomic) NSNumber* what;
@property (nonatomic) NSNumber* effects;
@property (nonatomic) NSNumber* paura;
@property (nonatomic) NSNumber* equilibrio;
@property (nonatomic) NSNumber* animali;
@property (nonatomic) NSNumber* lampadari;
@property (nonatomic) NSNumber* porcellane;
@property (nonatomic) NSNumber* soprammobili;
@property (nonatomic) NSNumber* porte;
@property (nonatomic) NSNumber* liquidi;
@property (nonatomic) NSNumber* quadri;
@property (nonatomic) NSNumber* mobili;
@property (nonatomic) NSNumber* rumore;
@property (nonatomic) NSNumber* inizioRumore;
@property (nonatomic) NSNumber* provenienzaRumore;
@property (nonatomic) NSNumber* piscine;
@property (nonatomic) NSNumber* piante;
@property (strong, nonatomic) NSString *altriFenomeni;
@property (nonatomic) NSNumber* danni;
@property (nonatomic) NSNumber* struttura;
@property (nonatomic) NSNumber* muri;
@property (nonatomic) NSNumber* tegole;
@property (nonatomic) NSNumber* camini;

- (void) resetBuildingAnswer;
- (void) resetOpenAirAnswer;
- (void) resetAllAnswer;

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
+ (coQuestionario*) dictionaryToQuestionario:(NSDictionary*) dizionario;
- (NSString *) questionarioToPostString;

@end
