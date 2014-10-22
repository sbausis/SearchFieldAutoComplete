//
//  TZAppDelegate.m
//  SearchFieldAutoComplete
//
//  Created by Simon Baur on 11/13/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZAppDelegate.h"
#import "TZSuggestions.h"

@implementation TZAppDelegate {
    BOOL amDoingAutoComplete;
    NSString *lastcompletionstring;
    TZSuggestions *torrentzSuggestions;
}
@synthesize searchField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /*
    [self getTorrentzSuggestionsFor:@"mo"];
    
    torrentzSuggestions = [[TZSuggestions alloc] initWithQuery:@""];
    NSLog(@"suggestions: %@ %@", torrentzSuggestions.query, torrentzSuggestions.suggestions);
    
    torrentzSuggestions.query = @"mo";
    NSLog(@"suggestions: %@ %@", torrentzSuggestions.query, torrentzSuggestions.suggestions);
    
    //[self getSuggestions:torrentzSuggestions];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector: @selector(timerFireMethod:)
                                   userInfo:torrentzSuggestions
                                    repeats:NO];
    */
    torrentzSuggestions = [[TZSuggestions alloc] initWithQuery:@""];
    NSLog(@"suggestions: %@ %@", torrentzSuggestions.query, torrentzSuggestions.suggestions);
    
    [searchField setDelegate:self];
}
/*
- (void)getTorrentzSuggestionsFor:(NSString*)query {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://torrentz.eu/suggestions.php?q=%@", query]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]  initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3];
    [request addValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1" forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (err == Nil) {
        
        NSArray *json_arr = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:&err];
        if (err == Nil) {
            
            NSLog(@"Query: %@", [json_arr objectAtIndex:0]);
            
            NSArray *suggestions = [json_arr objectAtIndex:1];
            if ([suggestions count] > 0) {
                
                NSLog(@"Suggestions: %@ %lu", suggestions, (unsigned long)[suggestions count]);
            }
            else {
                
                NSLog(@"no Suggestions");
            }
        }
    }
}

- (void)getSuggestions:(TZSuggestions*)tzSuggestions {
    while (tzSuggestions.suggestions == Nil) {
        [self performSelector:@selector(getSuggestions:) withObject:tzSuggestions afterDelay:0.35];
    }
    NSLog(@"suggestions: %@ %@", tzSuggestions.query, tzSuggestions.suggestions);
}

- (void)timerFireMethod:(NSTimer*)theTimer {
    TZSuggestions *tzSuggestions = theTimer.userInfo;
    if (tzSuggestions.suggestions == Nil) {
        NSLog(@"timerFireMethod");
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:self
                                       selector: @selector(timerFireMethod:)
                                       userInfo:tzSuggestions
                                        repeats:NO];
    }
    else {
        NSLog(@"suggestions: %@ %@", tzSuggestions.query, tzSuggestions.suggestions);
    }
}
*/

 /*
 -(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
 NSLog(@"textShouldEndEditing %@ %@", control,fieldEditor);
 //[fieldEditor complete:<#(id)#>]
 return YES;
 }
 */

/*
 -(void)controlTextDidChange:(NSNotification *)obj {
 
 NSLog(@"controlTextDidChange %@", obj);
 if( amDoingAutoComplete ){
 return;
 } else {
 amDoingAutoComplete = YES;
 [[[obj userInfo] objectForKey:@"NSFieldEditor"] complete:nil];
 }
 }
 */

-(void)controlTextDidChange:(NSNotification *)obj {
    
    NSLog(@"controlTextDidChange[%@]", obj);
    /*if([searchField.stringValue isEqualToString:[lastcompletionstring substringToIndex:[searchField.stringValue length]]]) {
        return;
    }
    else*/
    if([searchField.stringValue isEqualToString:lastcompletionstring]) {
        return;
    }
    else if ([searchField.stringValue isEqualToString:@""]) {
        lastcompletionstring = [searchField.stringValue copy];
        NSLog(@"new string %@", lastcompletionstring);
        torrentzSuggestions.query = lastcompletionstring;
    }
    else {
        
        lastcompletionstring = [searchField.stringValue copy];
        NSLog(@"new string %@", lastcompletionstring);
        torrentzSuggestions.query = lastcompletionstring;
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:self
                                       selector: @selector(completionarrive:)
                                       userInfo:[obj userInfo]
                                        repeats:NO];
    }
}
- (void)completionarrive:(NSTimer*)theTimer {
    if (torrentzSuggestions.suggestions == Nil) {
        NSLog(@"completionarrive");
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:self
                                       selector: @selector(completionarrive:)
                                       userInfo:theTimer.userInfo
                                        repeats:NO];
    }
    else {
        NSLog(@"suggestions: %@ %@", torrentzSuggestions.query, torrentzSuggestions.suggestions);
        [[theTimer.userInfo objectForKey:@"NSFieldEditor"] complete:nil];
    }
}
-(NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    
    //NSLog(@"completions: %@ %@ %@ %lu %lu", control, textView, words, (unsigned long)charRange.location, (unsigned long)charRange.length);
    NSLog(@"completions");
    
    return torrentzSuggestions.suggestions;
}

- (IBAction)searchFieldAction:(id)sender {
    
    NSLog(@"searchFieldAction %@", sender);
}
-(void)gotSuggestions:(NSArray*)suggestions {
    
    NSLog(@"gotSuggestions %@", suggestions);
}


@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "ch.0rca.SearchFieldAutoComplete" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"ch.0rca.SearchFieldAutoComplete"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SearchFieldAutoComplete" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"SearchFieldAutoComplete.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
