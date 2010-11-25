//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTableStyledTextItem.h"

// Core
#import "TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableStyledTextItem

@synthesize text    = _text;
@synthesize margin  = _margin;
@synthesize padding = _padding;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
  if (self = [super init]) {
    _margin = UIEdgeInsetsZero;
    _padding = UIEdgeInsetsMake(6, 6, 6, 6);
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_text);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(TTStyledText*)text {
  TTTableStyledTextItem* item = [[[self alloc] init] autorelease];
  item.text = text;
  return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(TTStyledText*)text URL:(NSString*)URL {
  TTTableStyledTextItem* item = [[[self alloc] init] autorelease];
  item.text = text;
  item.URL = URL;
  return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(TTStyledText*)text URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL {
  TTTableStyledTextItem* item = [[[self alloc] init] autorelease];
  item.text = text;
  item.URL = URL;
  item.accessoryURL = accessoryURL;
  return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.text = [decoder decodeObjectForKey:@"text"];
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
  [super encodeWithCoder:encoder];
  if (self.text) {
    [encoder encodeObject:self.text forKey:@"text"];
  }
}


@end
