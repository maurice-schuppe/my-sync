
#import "TTStyledNode.h"

// Core
#import "TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTStyledNode

@synthesize nextSibling = _nextSibling;
@synthesize parentNode  = _parentNode;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNextSibling:(TTStyledNode*)nextSibling {
  if (self = [super init]) {
    self.nextSibling = nextSibling;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
  if (self = [self initWithNextSibling:nil]) {
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_nextSibling);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNextSibling:(TTStyledNode*)node {
  if (node != _nextSibling) {
    [_nextSibling release];
    _nextSibling = [node retain];
    node.parentNode = _parentNode;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)outerText {
  return @"";
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)outerHTML {
  if (_nextSibling) {
    return _nextSibling.outerHTML;
  } else {
    return @"";
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)ancestorOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;
  } else {
    return [_parentNode ancestorOrSelfWithClass:cls];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) performDefaultAction {
}


@end
