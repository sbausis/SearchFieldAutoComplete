//
//  TZSuggestions.h
//  WebPageParser
//
//  Created by Simon Baur on 11/13/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZSuggestions : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString *_query;
    NSArray *_suggestions;
}

- (NSString*)query;
- (void)setQuery:(NSString*)query;

- (NSArray*)suggestions;
- (void)setSuggestions:(NSArray*)suggestions;

@property id _delegate;

-(id)init;
-(id)initWithQuery:(NSString*)q;
-(id)initWithQuery:(NSString*)q andDelegate:(id)delegate;

+ (NSArray*)getArrayFromJSONData:(NSData*)data;

@end
