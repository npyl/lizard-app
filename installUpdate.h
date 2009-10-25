//
//  installUpdate.h
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/NSApplication.h>
#define NSAppKitVersionNumber10_5 949

@interface installUpdate : NSObject {
	IBOutlet NSTableView *theView;
	
	IBOutlet NSTextField *theFormat;
	IBOutlet NSTextField *theUUID;
	IBOutlet NSTextField *theROnly;
	IBOutlet NSTextField *theRDisk;
	
	IBOutlet NSTextField *checkBoot;
	IBOutlet NSTextField *checkBoot1h;
	IBOutlet NSTextField *checkBoot0;
	IBOutlet NSTextField *currentFolder;
	
	IBOutlet NSBox *extraBox;
	
	//checkboxes
	IBOutlet NSButton *bBoot;
	IBOutlet NSButton *bBoot1h;
	IBOutlet NSButton *bBoot0;
	IBOutlet NSButton *bExtensions;
	IBOutlet NSButton *bSmbios;
	IBOutlet NSButton *bThemes;
	
	//images de validation
	IBOutlet id iBoot;
	IBOutlet id iBoot1h;
	IBOutlet id iBoot0;
	IBOutlet id iExtensions;
	IBOutlet id iSmbios;
	IBOutlet id iThemes;
	
	IBOutlet NSWindow *dlWindow;
	// spin
	IBOutlet NSProgressIndicator *progressIndicator;

	NSArray *volumeURLs;
	NSArray *resourceKeys;
	NSArray *iconKey;
	NSArray *theicon;
	NSMutableArray *rDisk;
	NSString *selectedDevice;
	NSString *rDiskX;
	
	NSMutableArray *selectedPath;
	NSMutableArray *diskType;
	NSMutableArray *diskUUID;
	NSMutableArray *diskROnly;
	NSMutableArray *warmImages;
	NSMutableArray *rDiskXArray;
	
	//chemins
	NSString *i386Path;
	NSString *opExtra;
	NSString *boot;
	NSString *boot0;
	NSString *boot1h;
	NSString *helperToolPath;
	NSString *theRootPath;
	
	//fichiers
	NSString *smPlist;
	NSMutableArray *vThemes;
	NSMutableArray *lExtensions;
	NSMutableArray *coExtensions;
	
}
@property (retain, nonatomic) NSArray *volumeURLs;
@property (retain, nonatomic) NSArray *resourceKeys;
@property (retain, nonatomic) NSArray *theicon;
@property (retain, nonatomic) NSArray *iconKey;
@property (retain, nonatomic) NSMutableArray *rDisk;

@property (retain, nonatomic) NSString *selectedDevice;
@property (retain, nonatomic) NSString *rDiskX;
@property (retain, nonatomic) NSString *i386Path;
@property (retain, nonatomic) NSString *boot0;
@property (retain, nonatomic) NSString *boot;
@property (retain, nonatomic) NSString *boot1h;
@property (retain, nonatomic) NSString *theRootPath;
@property (retain, nonatomic) NSString *opExtra;
@property (retain, nonatomic) NSString *smPlist;
@property (retain, nonatomic) NSMutableArray *vThemes;
@property (retain, nonatomic) NSMutableArray *lExtensions;
@property (retain, nonatomic) NSMutableArray *coExtensions;

@property (retain, nonatomic) NSMutableArray *diskUUID;
@property (retain, nonatomic) NSMutableArray *selectedPath;
@property (retain, nonatomic) NSMutableArray *diskType;
@property (retain, nonatomic) NSMutableArray *diskROnly;
@property (retain, nonatomic) NSMutableArray *warmImages;
@property (retain, nonatomic) NSMutableArray *rDiskXArray;

@property (readonly) IBOutlet NSWindow *dlWindow;


- (id)tableView:(NSTableView *)theView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;


- (void)loopAccrosExtensions;
- (void)loopAccrosVerion;
- (void)loopAccrosThemes;

- (IBAction)selectDevice:(id)sender;
- (IBAction)launchInstall:(id)sender;
- (IBAction)selectFolder:(id)sender;
- (IBAction)serverUpdate:(id)sender;
- (IBAction)installExtra:(id)sender;

@end
