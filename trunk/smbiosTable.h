#import <Cocoa/Cocoa.h>

@interface smbiosTable : NSObject {
	
	// Nombre de clés pour les slots de ram
	NSMutableArray *smOne;
	NSMutableArray *smTwo;
	NSMutableArray *smThree;
	NSMutableArray *smFour;
	
	IBOutlet NSTableView * tableView;
	
	//les champs connectés aux colones
	IBOutlet id ramBank;
    IBOutlet id ramManufacter;
    IBOutlet id ramSerial;
    IBOutlet id ramPart;
}
- (IBAction)addRow:(id)sender;
- (IBAction)saveRow:(id)sender;
- (IBAction)removeRow:(id)sender;

@property (retain, nonatomic) NSMutableArray *smOne;
@property (retain, nonatomic) NSMutableArray *smTwo;
@property (retain, nonatomic) NSMutableArray *smThree;
@property (retain, nonatomic) NSMutableArray *smFour;

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;
@end