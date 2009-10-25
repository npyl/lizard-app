//
//  chamConnect.m
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "chamConnect.h"


@implementation chamConnect

@synthesize newItems;
@synthesize url;
@synthesize chamUrl;

- (void)dealloc
{
	[newItems release];
	[responseData release];
	[baseURL release];
	[super dealloc];
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {

	return;
}

- (void)awakeFromNib
{
	responseData = [[NSMutableData data] retain];
	baseURL = [[NSURL URLWithString:@"http://chameleon.osx86.hu"] retain];
	
    NSURLRequest *request =
	[NSURLRequest requestWithURL:baseURL];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
    willSendRequest:(NSURLRequest *)request
    redirectResponse:(NSURLResponse *)redirectResponse
{
    [baseURL autorelease];
    baseURL = [[request URL] retain];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

/*- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSAlert alertWithError:error] beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	NSImage *updateIcon = [NSImage imageNamed:@"NSNetwork"];
    // Once this method is invoked, "responseData" contains the complete result
	NSError *error;
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:responseData options:NSXMLDocumentTidyHTML error:&error];
	
	// Deliberately ignore error: with most HTML it will be filled numerous
	// "tidy" warnings.
	
	NSXMLElement *rootNode = [document rootElement];
	
	NSString *xpathQueryString =
		@"//ul[@class='file_download_list']/li/a";
	NSArray *newItemsNodes = [rootNode nodesForXPath:xpathQueryString error:&error];

	if (error)
	{
		[[NSAlert alertWithError:error] beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		return;
	}
	int i =0;
	[self willChangeValueForKey:@"newItems"];
	[newItems release];
	newItems = [[NSMutableArray array] retain];
	chamUrl = [[NSMutableArray array] retain];
	for (NSXMLElement *node in newItemsNodes)
	{
		NSString *relativeString = [[node attributeForName:@"href"] stringValue];
		self.url = [NSURL URLWithString:relativeString relativeToURL:baseURL];
					//NSLog ([url description]);
		
		NSString *linkText = [[node childAtIndex:0] stringValue];
		//decompose le string en array pour filtrer les resultats
		NSArray *ChamBinFilter = [linkText componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
		
		//la comdition du filtrage
		if ([ChamBinFilter containsObject:@"bin"] && [ChamBinFilter containsObject:@"Chameleon"]) {
			 [newItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[url absoluteString], @"linkURL",linkText, @"linkText",nil]];
			 
			//construire l'array avec les url
			[chamUrl insertObject:url atIndex:i];
			 i++;
		}
	}
		[self didChangeValueForKey:@"newItems"];
	
	//compte le nombre d'elements et compare pour l'update	
	//NSString *updatable = [NSString stringWithFormat:@"%i", self.chamUrl.count];
	//check prefs
	BOOL updateState;
	updateState = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableUpdates"];
	if (updateState == NO) {
		NSArray *storedInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"Chameleon Update"];
		if (!storedInfo) {
			[[NSUserDefaults standardUserDefaults] setObject:newItems forKey:@"Chameleon Update"];
		}
		else if (chamUrl.count > storedInfo.count) {
			NSAlert *alert = [[NSAlert alloc] init];
			[alert setAlertStyle:NSInformationalAlertStyle];
			[alert setIcon:updateIcon];
			[alert setMessageText:@"New Chameleon Update Avaible!"];
			[alert setInformativeText:@"Go to 'Install and Update', then click on 'Download file' for more informations and download link"];
			[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
			
			[[NSUserDefaults standardUserDefaults] setObject:newItems forKey:@"Chameleon Update"];
		}
	}
} 
/*- (void)download:(NSURLDownload *)aDownload decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString* path = [[@"~/Downloads/" stringByExpandingTildeInPath] stringByAppendingPathComponent:filename];
    [aDownload setDestination:path allowOverwrite:NO];
}*/
- (IBAction)download:(id)sender {
 
NSURL *urlString = [chamUrl objectAtIndex:[dlView selectedRow]];
	//NSLog([urlString description]);
		if (!urlString) {
        NSBeep();
        return;
    }
	// on ouvre le lien dans le navigateur
	[[NSWorkspace sharedWorkspace] openURL:urlString];
	 
	//NSURLRequest* request = [NSURLRequest requestWithURL:urlString];
	//download = [[NSURLDownload alloc] initWithRequest:request delegate:self];

}
@end
