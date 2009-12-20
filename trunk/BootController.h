//
//  BootController.h
//  Chameleon Manager
//
//  Created by ronan on 19/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/NSApplication.h>
#define NSAppKitVersionNumber10_5 949

@interface BootController : NSObject {
	// spin
	IBOutlet NSProgressIndicator *progressIndicator;
	
	IBOutlet NSWindow *bootWindow;
	
	BOOL didMoveView;
	
	//refaire le plistboot
	IBOutlet id kernelPathUpdate;
	IBOutlet id timeOutNumBox;
	IBOutlet NSSlider *TimeOutSlide;
	IBOutlet NSComboBox *themeUpdate;
	IBOutlet NSTextView *basicView;
	
	//chekboxes
	IBOutlet NSButton *graphicsEnablerBox;
	IBOutlet NSButton *ethernetBuiltInBox;
	IBOutlet NSButton *USBBusFixBox;
	IBOutlet NSButton *EHCIacquireBox;
	IBOutlet NSButton *UHCIresetBox;
	IBOutlet NSButton *WakeBox;
	IBOutlet NSButton *ForceWakeBox;
	IBOutlet NSButton *WakeImageBox;
	IBOutlet NSButton *DropSSDTBox;
	IBOutlet NSButton *SMBIOSdefaultsBox;
	IBOutlet NSButton *RescanBox;
	IBOutlet NSButton *RescanPromptBox;
	IBOutlet NSButton *GUIBox;
	IBOutlet NSButton *InstantMenuBox;
	IBOutlet NSButton *forceHPETBox;	
	IBOutlet NSButton *quietBootBox;
	IBOutlet NSButton *vBiosBox;
	IBOutlet NSButton *bootBannerBox;
	IBOutlet NSButton *legacyLogoBox;
	IBOutlet NSButton *devPropsBox;
	IBOutlet NSButton *waitBox;
	IBOutlet NSButton *legacyBootBox;	
	
	//SL check pour Arch
	IBOutlet NSButton *SystemCheck;
	
	//animation
	IBOutlet NSButton *disclosureTriangle;
	IBOutlet NSButton *enableCheckBox;
	
	//selection theme: infos
	IBOutlet id fileCreatedDisplay;
	IBOutlet id themeThumbDisplay;
	IBOutlet id testMe;
	IBOutlet id testMeA;
	IBOutlet id bootSizeDisplay;
	IBOutlet id fileNameDisplay;
	IBOutlet NSComboBox *myComboBox;
	
	
	IBOutlet NSComboBox *theFlag;
	IBOutlet NSComboBox *thePart;
	IBOutlet NSTextField *updateFlag;
	
	NSMutableArray *dataOfArray;
	
	// indicateur pour version chameleon
	IBOutlet id imageStatus;
	IBOutlet id graphicsEnablerStatus;
	IBOutlet id ethernetStatus;
	IBOutlet id smbiosPathStatus;
	IBOutlet id vbiosStatus;
	IBOutlet id vromStatus;
	IBOutlet id logoStatus;
	IBOutlet id bannerStatus;
	IBOutlet id waitStatus;
	IBOutlet id hideStatus;
	IBOutlet id defpartStatus;
	IBOutlet id pciStatus;
	
	//image sauvegarde succès
	IBOutlet id saveGood;
	
	//information si com.boot systeme
	IBOutlet id systemBootStatus;
	
	//default partition combo
	IBOutlet NSComboBox *updateDP;
	
	//theme.plist controllers
	NSString *themeAuthor;
	NSString *themeVersion;
	NSString *themeWidth;
	NSString *themeHeight;
	
	//com.apple.Boot.plist controllers
	NSString *graphicsMode;
	NSString *kernelPath;
	NSString *kernelFlags;
	NSString *graphicsEnabler;
	NSString *timeOut;
	NSString *ethernetBuiltIn;
	NSString *selectedTheme;
	NSString *USBBusFix;
	NSString *EHCIacquire;
	NSString *UHCIreset;
	NSString *Wake;
	NSString *ForceWake;
	NSString *WakeImage;
	NSString *DropSSDT;
	NSString *DSDT;
	NSString *SMBIOSdefaults;
	NSString *Rescan;
	NSString *RescanPrompt;
	NSString *GUI;
	NSString *InstantMenu;
	NSString *DefaultPartition;
	NSString *themeName;
	NSString *setSmbioPath;
	NSString *forceHPET;	
	NSString *quietBoot;
	NSString *vBios;
	NSString *bootBanner;
	NSString *legacyLogo;
	NSString *videoROM;
	NSString *SLarch;
	NSString *devProps;
	NSString *wait;
	NSString *hidePartition;
	
	NSData *plistBootXML;
	NSData *viewBootData;
	NSMutableDictionary *bootTemp;
	
	NSString *pciRoot;
	NSString *comBootPath;
	
	//custom fields
	NSMutableArray *realKeys;
	NSMutableArray *chamKeys;
	NSMutableArray *customKeys;
	IBOutlet NSTableView *tableView;
	IBOutlet NSTextField *cStringField;
	IBOutlet NSTextField *cKeyField;
	
	//getPartitions
	NSArray *theicon;
	NSString *dpString;
	NSMutableArray *selectedPath;
	NSMutableArray *selectedPartition;
	
	NSMutableArray *diskType;
	NSMutableArray *diskUUID;
	NSMutableArray *diskROnly;
	NSNumber *actionTag;

}

@property (copy, nonatomic) NSString *graphicsMode;
@property (copy, nonatomic) NSString *kernelPath;
@property (copy, nonatomic) NSString *kernelFlags;
@property (copy, nonatomic) NSString *graphicsEnabler;
@property (copy, nonatomic) NSString *timeOut;
@property (copy, nonatomic) NSString *ethernetBuiltIn;
@property (copy, nonatomic) NSString *selectedTheme;
@property (copy, nonatomic) NSString *USBBusFix;
@property (copy, nonatomic) NSString *EHCIacquire;
@property (copy, nonatomic) NSString *UHCIreset;
@property (copy, nonatomic) NSString *Wake;
@property (copy, nonatomic) NSString *ForceWake;
@property (copy, nonatomic) NSString *WakeImage;
@property (copy, nonatomic) NSString *DropSSDT;
@property (copy, nonatomic) NSString *DSDT;
@property (copy, nonatomic) NSString *SMBIOSdefaults;
@property (copy, nonatomic) NSString *Rescan;
@property (copy, nonatomic) NSString *RescanPrompt;
@property (copy, nonatomic) NSString *GUI;
@property (copy, nonatomic) NSString *InstantMenu;
@property (copy, nonatomic) NSString *DefaultPartition;
@property (copy, nonatomic) NSString *setSmbioPath;
@property (copy, nonatomic) NSString *quietBoot;
@property (copy, nonatomic) NSString *vBios;
@property (copy, nonatomic) NSString *bootBanner;
@property (copy, nonatomic) NSString *legacyLogo;
@property (copy, nonatomic) NSString *videoROM;
@property (copy, nonatomic) NSString *forceHPET;
@property (copy, nonatomic) NSString *SLarch;
@property (copy, nonatomic) NSString *devProps;
@property (copy, nonatomic) NSString *wait;
@property (copy, nonatomic) NSString *pciRoot;
@property (copy, nonatomic) NSString *hidePartition;

@property (retain, nonatomic) NSData *viewBootData;

@property (copy, nonatomic) NSString *themeAuthor;
@property (copy, nonatomic) NSString *themeVersion;
@property (copy, nonatomic) NSString *themeWidth;
@property (copy, nonatomic) NSString *themeHeight;

//getPartitions
@property (retain, nonatomic) NSMutableArray *realKeys;
@property (retain, nonatomic) NSMutableArray *chamKeys;
@property (retain, nonatomic) NSMutableArray *customKeys;
@property (retain, nonatomic) NSArray *theicon;
@property (retain, nonatomic) NSString *dpString;
@property (retain, nonatomic) NSMutableArray *diskUUID;
@property (retain, nonatomic) NSMutableArray *selectedPath;
@property (retain, nonatomic) NSMutableArray *selectedPartition;
@property (retain, nonatomic) NSMutableArray *diskType;
@property (retain, nonatomic) NSMutableArray *diskROnly;

- (IBAction)getDevProps:(id)sender;
- (IBAction)saveBoot:(id)sender;
- (IBAction)timeOutValue:(id)sender;
- (IBAction)sendThemeUpdate:(id)sender;
- (IBAction)insertFlag:(id)sender;
- (IBAction)insertPart:(id)sender;
- (IBAction)setPCIRoot:(id)sender;

- (IBAction)getWakeImage:(id)sender;
- (IBAction)getDSDT:(id)sender;
- (IBAction)getSMPath:(id)sender;
- (IBAction)getVideoRom:(id)sender;

- (IBAction)bootPreview:(id)sender;

- (IBAction)addCustom:(id)sender;
- (IBAction)replaceCustom:(id)sender;
- (IBAction)removeCustom:(id)sender;

NSString *systemeBootPath = @"/Library/Preferences/SystemConfiguration/com.apple.Boot.plist";
NSString *bootPath = @"com.apple.Boot.plist";
NSString *smbiosPath = @"smbios.plist";
NSString *themePath = @"Themes/";

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

@end
