//
//  TZSuggestions.m
//  WebPageParser
//
//  Created by Simon Baur on 11/13/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZSuggestions.h"

#define TORRENTZ_SUGGESTIONS_URL @"http://torrentz.eu/suggestions.php?q=%@"
#define TORRENTZ_USER_AGENT @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

@implementation TZSuggestions {
    NSMutableData *_responseData;
    NSMutableURLRequest *_request;
    NSURLConnection *_connection;
}

- (NSString*)query {
    return _query;
}
- (void)setQuery:(NSString*)query {
    if (![_query isEqualToString:query]) {
        
        if (_connection != Nil) {
            [_connection cancel];
        }
        
        _query = query;
        //_suggestions = [NSArray arrayWithObjects:@"", [[NSArray alloc] init], nil];
        
        [_request setURL:[NSURL URLWithString:[NSString stringWithFormat:TORRENTZ_SUGGESTIONS_URL, query]]];
        _connection = [NSURLConnection connectionWithRequest:_request delegate:self];
        
    }
}

- (NSArray*)suggestions {
    NSLog(@"suggestions for %@: %@", _query, _suggestions);
    if ([_suggestions count] > 0 && [[_suggestions objectAtIndex:0] isEqualToString:_query]) {
        return [_suggestions objectAtIndex:1];
    }
    return Nil;
}
- (void)setSuggestions:(NSArray*)suggestions {
    //_suggestions = suggestions;
}

-(id)init {
    self = [super init];
    if (self) {
        
        _responseData = [[NSMutableData alloc] init];
        
        _request = [[NSMutableURLRequest alloc] init];
        [_request setTimeoutInterval:3];
        [_request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [_request addValue:TORRENTZ_USER_AGENT forHTTPHeaderField:@"User-Agent"];
        
        _suggestions = [[NSArray alloc] init];
        
    }
    return self;
}

-(id)initWithQuery:(NSString *)q {
    self = [self init];
    if (self) {
        
        self.query = q;
    }
    return self;
}

+ (NSArray*)getArrayFromJSONData:(NSData*)data {
    NSError *error;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return arr;
}

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

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse: %ld", (long)((NSHTTPURLResponse*)response).statusCode );
    /*
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        //If you need the response, you can use it here
    }
    */
    [_responseData setLength:0];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData %lu", (unsigned long)[data length]);
    [_responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //[self connectionDidFinishLoading:connection];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    if ([_responseData length] > 0) {
        NSString *_dataString = [NSString stringWithUTF8String:[_responseData bytes]];
        NSLog(@"dataString %lu %@ %lu", (unsigned long)[_responseData length], _dataString, (unsigned long)[_dataString length]);
        _suggestions = [[self class] getArrayFromJSONData:_responseData];
    }
}

@end
