//
//  Controller.m
//  tableview-test
//
//  Created by ronan on 12/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "smbiosTable.h"


@implementation smbiosTable
@synthesize smOne;
@synthesize smTwo;
@synthesize smThree;
@synthesize smFour;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.smOne.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
	
	if ([[pTableColumn identifier] isEqualToString:@"smBank"]) {
		return [smOne objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:@"SMmemmanufacter_"]) {
		return [smTwo objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:@"SMmemserial_"]) {
		return [smThree objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:@"SMmempart_"]) {
		return [smFour objectAtIndex:pRowIndex];
	}
	return NULL;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
	
} 
- (id) init {
	
    if (self = [super init]) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath = @"/Data.plist";
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
											  propertyListFromData:plistXML
											  mutabilityOption:NSPropertyListMutableContainersAndLeaves
											  format:&format
											  errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        self.smOne = [NSMutableArray arrayWithArray:[temp objectForKey:@"smBank"]];
		self.smTwo = [NSMutableArray arrayWithArray:[temp objectForKey:@"SMmemmanufacter_"]];
		self.smThree = [NSMutableArray arrayWithArray:[temp objectForKey:@"SMmemserial_"]];
		self.smFour = [NSMutableArray arrayWithArray:[temp objectForKey:@"SMmempart_"]];
		
    }
    return self;
}
- (IBAction)addRow:(id)sender
{	
	NSString *ramBankWrite = [ramBank stringValue];
	NSString *ramMemWrite = [ramManufacter stringValue];
	NSString *ramSerialWrite = [ramSerial stringValue];
	NSString *ramPartWrite = [ramPart stringValue];
	NSString *UserMen = [@"SMmemmanufacter_" stringByAppendingString:ramBankWrite];
	NSString *UserSerial = [@"SMmemserial_" stringByAppendingString:ramBankWrite];
	NSString *UserPart = [@"SMmempart_" stringByAppendingString:ramBankWrite];
	
	//une ligne selectionne
	if ([tableView selectedRow] > -1) {
		[self.smOne insertObject:ramBankWrite atIndex:[tableView selectedRow]];
		[self.smTwo insertObject:ramMemWrite atIndex:[tableView selectedRow]];
		[self.smThree insertObject:ramSerialWrite atIndex:[tableView selectedRow]];
		[self.smFour insertObject:ramPartWrite atIndex:[tableView selectedRow]];
	}
	//dans le vide
	else {
		[self.smOne addObject:ramBankWrite];
		[self.smTwo addObject:ramMemWrite];
		[self.smThree addObject:ramSerialWrite];
		[self.smFour addObject:ramPartWrite];
	}
	
	//stockage des paramêtres
	if ([ramBankWrite isEqualToString:@"1"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"2"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"3"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"4"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"5"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"6"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"7"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	if ([ramBankWrite isEqualToString:@"8"]) {
		[[NSUserDefaults standardUserDefaults] setValue:ramMemWrite forKey:UserMen];
		[[NSUserDefaults standardUserDefaults] setValue:ramSerialWrite forKey:UserSerial];
		[[NSUserDefaults standardUserDefaults] setValue:ramPartWrite forKey:UserPart];
	}
	
	//rafraichir le tout
	[[NSUserDefaults standardUserDefaults] synchronize];
	[tableView reloadData];
}
- (IBAction)removeRow:(id)sender
{	
	if ([tableView selectedRow] > -1) {
		NSString *ramBankWrite = [ramBank stringValue];
		NSString *UserMen = [@"SMmemmanufacter_" stringByAppendingString:ramBankWrite];
		NSString *UserSerial = [@"SMmemserial_" stringByAppendingString:ramBankWrite];
		NSString *UserPart = [@"SMmempart_" stringByAppendingString:ramBankWrite];
		
		[self.smOne removeObjectAtIndex:[tableView selectedRow]];
		[self.smThree removeObjectAtIndex:[tableView selectedRow]];
		[self.smFour removeObjectAtIndex:[tableView selectedRow]];
		[self.smTwo removeObjectAtIndex:[tableView selectedRow]];
		
		
		// ne fonctionnera que si binding avec la case ramBank
		if ([ramBankWrite isEqualToString:@"1"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"2"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"3"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"4"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"5"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"6"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"7"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		if ([ramBankWrite isEqualToString:@"8"]) {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserMen];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSerial];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPart];
		}
		//rafraichir le tout
		[[NSUserDefaults standardUserDefaults] synchronize];
		[tableView reloadData];
	} // end if
	
}

- (IBAction)saveRow:(id)sender {
    NSString *error;
	NSString *plistPath = @"/Data.plist";
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
							   [NSArray arrayWithObjects: smOne, smTwo, smThree, smFour, nil]
														  forKeys:[NSArray arrayWithObjects: @"smBank", @"SMmemmanufacter_", @"SMmemserial_", @"SMmempart_", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(error);
        [error release];
    }
}
@end