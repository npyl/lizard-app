//
//  IKBBrowserItem.m
//  IKBrowserViewDND
//
//  Created by David Gohara on 2/26/08.
//  Copyright 2008 SmackFu-Master. All rights reserved.
//  http://smackfumaster.com
//

#import "IKBBrowserItem.h"


@implementation IKBBrowserItem

@synthesize image;
@synthesize imageID, fullImagePath;

- (id)initWithImage:(NSImage*)anImage imageID:(NSString*)anImageID
{
	if (self = [super init]) {
		image = [anImage copy];
		imageID = [[anImageID lastPathComponent] copy];
		fullImagePath = [anImageID copy];
	}
	return self;
}

- (void)dealloc
{
	[image release];
	[imageID release];
	[fullImagePath release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Required Methods IKImageBrowserItem Informal Protocol
- (NSString *) imageUID
{
	return imageID;
}
- (NSString *) imageRepresentationType
{
	return IKImageBrowserNSImageRepresentationType; //type d'image retourne
}
- (id) imageRepresentation
{
	return image;
}

#pragma mark -
#pragma mark Optional Methods IKImageBrowserItem Informal Protocol
- (NSString*) imageTitle
{
	return imageID;
}

@end
