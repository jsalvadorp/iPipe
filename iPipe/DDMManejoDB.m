//
//  DDMManejoDB.m
//  iPipe
//
//  Created by Salvador Pamanes on 17/04/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "Tip.h"
#import "Juego.h"
#import "Ranking.h"
#import "DDMManejoDB.h"
#import <CoreData/CoreData.h>
#import <stdlib.h>

@implementation DDMManejoDB {
    //NSMutableArray *_libros;
    NSURLConnection *connection;
    NSMutableData *responseData;
}


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
- (Tip *) randomTip {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tip"];
    NSError *error;
    //NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSArray *todos = [context executeFetchRequest:request error:&error];
    
    if (error != nil || todos.count == 0) {
        return nil;
    }
    else {
        return todos[arc4random() % todos.count];
    }
}

- (NSArray *) juegos {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Juego"];
    NSError *error;
    //NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSArray *todos = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        return @[];
    }
    else {
        return todos;
    }
}

- (Tip *) insertarTip: (NSString *) ntip conTiempo: (long long) tiempo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Tip *nuevoTip = [NSEntityDescription insertNewObjectForEntityForName:@"Tip" inManagedObjectContext:context];
    nuevoTip.tip = ntip;
    nuevoTip.timestamp = [NSNumber numberWithLongLong:tiempo];
    NSLog(@"tip %@ : %@", nuevoTip.tip, nuevoTip.timestamp);
    [self saveContext];
    return nuevoTip;
}

- (Juego *) insertarJuego: (NSString *) nombre dificultad: (int) dificultad
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Juego *nuevoJuego = [NSEntityDescription insertNewObjectForEntityForName:@"Juego" inManagedObjectContext:context];
    nuevoJuego.nombre = nombre;
    nuevoJuego.dificultad = [NSNumber numberWithInt:dificultad];
    nuevoJuego.new = @YES;
    [self saveContext];
    return nuevoJuego;
}

- (BOOL) insertarRanking: (NSString *) nombre dificultad: (int) dificultad puntos: (int) puntos
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithContentsOfFile:@"rankings.plist"];
    
    if(values == nil)
        values = [[NSMutableArray alloc] init];
    
    [values addObject:
     @{@"nombre" : nombre,
       @"dificultad" : [NSNumber numberWithInt: dificultad],
       @"puntos" : [NSNumber numberWithInt: puntos]}];
    
    [values sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[@"puntos"] compare:obj2[@"puntos"]];
    }];
    
    while(values.count > 10)
        [values removeLastObject];
    
    [values writeToFile:@"rankings.plist" atomically:YES];
    
    return YES;
}

- (NSArray *) rankings {
     NSMutableArray *values = [[NSMutableArray alloc] initWithContentsOfFile:@"rankings.plist"];
    
    return values;
}

- (void) descargarTips {
    
    long long ultimaActualizacion = 0;
    // hallar la fecha del tip mas nuevo
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdFetching.html
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tip" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // se obtendra un diccionario con la timestamp de ultima actualizacion
    [request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"timestamp"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"ultimaActualizacion"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // hacer la query
    NSError *error = nil;
    NSArray *objects = [_managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        // no se hallaron tips previos, no se hace nada
        // (ultima actualizacion es 0, es decir 1 enero 1970)
        // se pediran al servidor todas las actualizaciones
    }
    else {
        if ([objects count] > 0) {
            NSLog(@"Ultima actualizacion: %@", [[objects objectAtIndex:0] valueForKey:@"ultimaActualizacion"]);
            ultimaActualizacion = [objects[0][@"ultimaActualizacion"] longLongValue];
        }
    }

    
    
    NSString *url = [[NSString alloc] initWithFormat:DDM_SERVIDOR_TIPS, ultimaActualizacion];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSURLRequest *urlRequest =
    [[NSURLRequest alloc]
     initWithURL:[[NSURL alloc] initWithString:url]
     cachePolicy:NSURLRequestReloadIgnoringCacheData
     timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    responseData = [[NSMutableData alloc] init];
}


#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    
    int statusCode = [httpResponse statusCode];
    NSLog(@"status code %d", statusCode);
    
    if(statusCode == 404) { // servicio da not found
        //[self.esperaAI stopAnimating];
        //[self despliegaError:@"El servicio se ha caído o no existe."];
    }
    
    responseData.length = 0;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    NSArray *datos = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    for(NSDictionary *d in datos) {
        [self insertarTip:d[@"tip"] conTiempo:[d[@"timestamp"] longLongValue]];
    }
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html
    //[self.esperaAI stopAnimating];
    switch (error.code) {
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorInternationalRoamingOff:
      //      [self despliegaError:@"Sin conexión a Internet."];
            break;
        case NSURLErrorTimedOut:
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorBadServerResponse:
      //      [self despliegaError:@"El servicio se ha caído o no existe."];
            break;
            
        default: // error de otros tipos
      //      [self despliegaError:@"Algo salió mal :("];
            break;
    }
}


@end
