//
//  cdController.h
//  PropertyListExample
//
//  Created by ronan on 11/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface cdController : NSObject {
	// bouton agrandissement
	IBOutlet NSButton *disclosureTriangle;
    IBOutlet NSBox *extraBox;
	
	//options
	IBOutlet NSButton *disableUI;
	IBOutlet NSButton *mountISO;
	IBOutlet NSButton *refreshAll;
	
	//liste des fichiers/dossiers
	IBOutlet id browserView;
	NSMutableArray * browserData;
	
	// mesage de confiramtion creation ISO
	IBOutlet id cdConfirm;
	
	// spin
	IBOutlet NSProgressIndicator *progressIndicator;
	
	// objets log cdboot
	IBOutlet NSTextView             *cdbootView; 
    IBOutlet NSButton               *cdbootButton;
    NSTask                          *cdbootTask; 
    NSPipe                          *cdbootPipe; 
    BOOL                             cdbootIsRunning;
	
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
	NSString *forceHPET;	
	NSString *quietBoot;
	NSString *vBios;
	NSString *bootBanner;
	NSString *legacyLogo;
	NSString *videoROM;
	NSString *SLarch;
	NSString *devProps;
	NSString *setSmbioPath;
	NSString *hidePartition;
	NSString *pciRoot;
	
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
@property (copy, nonatomic) NSString *pciRoot;
@property (copy, nonatomic) NSString *hidePartition;

- (IBAction)createCdBoot:(id)sender;
- (IBAction)disclosureTrianglePressed:(id)sender;
- (IBAction)removeAll:(id)sender;

//cdboot data
- (void)cdbootData:(NSFileHandle*) theFileHandle;

// coverflow view
@property(readwrite,retain) NSMutableArray *browserData;

@end

