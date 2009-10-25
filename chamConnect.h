//
//  chamConnect.h
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface chamConnect : NSObject {
	NSMutableArray *newItems;
	NSMutableArray *chamUrl;
	NSMutableData *responseData;
	NSURL *baseURL;
	NSURL *url;
	NSURLDownload* download;
	IBOutlet NSTableView *dlView;
	IBOutlet NSWindow *dlWindow;
}

@property (nonatomic, retain, readonly) NSArray *newItems;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableArray *chamUrl;

- (IBAction)download:(id)sender;

@end
