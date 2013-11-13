//
//  TZAppDelegate.h
//  SearchFieldAutoComplete
//
//  Created by Simon Baur on 11/13/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TZAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
