//
//  DDMManejoDB.h
//  iPipe
//
//  Created by Salvador Pamanes on 17/04/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMManejoDB : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Metodos para crear e inicializar el singleton
- (id) init;
+ (DDMManejoDB *) instancia;
//Metodos para insertar en la BD
- (void) insertarTip: (NSString *) ntip conTiempo: (long long) tiempo;
- (void) descargarTips;



@end
