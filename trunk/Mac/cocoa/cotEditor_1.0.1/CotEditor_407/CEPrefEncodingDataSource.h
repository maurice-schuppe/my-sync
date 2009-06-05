/*
=================================================
CEPrefEncodingDataSource
(for CotEditor)

Copyright (C) 2004-2007 nakamuxu.
http://www.aynimac.com/
=================================================

encoding="UTF-8"
Created:2004.12.16

-------------------------------------------------

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. 


=================================================
*/

#import <Cocoa/Cocoa.h>
#import "constants.h"

@interface CEPrefEncodingDataSource : NSObject
{
    IBOutlet id _tableView;
    IBOutlet id _delSeparatorButton;
    IBOutlet id _revertButton;

    NSMutableArray *_encodingsForTmp;
    NSArray *_draggedItems;
}

// Public method
- (void)setupEncodingsToEdit;
- (void)writeEncodingsToUserDefaults;

// Action Message
- (IBAction)revertDefaultEncodings:(id)sender;
- (IBAction)addSeparator:(id)sender;
- (IBAction)deleteSeparator:(id)sender;


@end