//
//  DDMManejoDB.m
//  iPipe
//
//  Created by Salvador Pamanes on 17/04/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "Tip.h"
#import "DDMManejoDB.h"
#import <CoreData/CoreData.h>

@implementation DDMManejoDB


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Metodos del singleton
//Metodos para crear e inicializar el singleton
- (id) init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (DDMManejoDB *) instancia
{
    static DDMManejoDB *_instancia = nil;
    static dispatch_once_t safer;
    dispatch_once (&safer, ^(void)
                   {
                       _instancia = [[DDMManejoDB alloc] init];
                   });
    return _instancia;
}

//Metodos para insertar en la BD
- (void) insertarTip: (NSString *) ntip conTiempo: (long long) tiempo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Tip *nuevoTip = [NSEntityDescription insertNewObjectForEntityForName:@"Tip" inManagedObjectContext:context];
    nuevoTip.tip = ntip;
    nuevoTip.timestamp = [NSNumber numberWithLongLong:tiempo];
    [self saveContext];
}

- (void) descargarTips {
    static dispatch_once_t safer;
    dispatch_once (&safer, ^(void)
                   {
                       _instancia = [[DDMManejoDB alloc] init];
                   });  
}



@end
