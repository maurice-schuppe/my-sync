
#import "TTStyledTextParser.h"

// Style
#import "TTStyledElement.h"
#import "TTStyledTextNode.h"
#import "TTStyledInline.h"
#import "TTStyledBlock.h"
#import "TTStyledLineBreakNode.h"
#import "TTStyledBoldNode.h"
#import "TTStyledButtonNode.h"
#import "TTStyledLinkNode.h"
#import "TTStyledItalicNode.h"
#import "TTStyledImageNode.h"

// Core
#import "TTCorePreprocessorMacros.h"
#import "TTDebug.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTStyledTextParser

@synthesize rootNode        = _rootNode;
@synthesize parseLineBreaks = _parseLineBreaks;
@synthesize parseURLs       = _parseURLs;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_rootNode);
  TT_RELEASE_SAFELY(_chars);
  TT_RELEASE_SAFELY(_stack);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addNode:(TTStyledNode*)node {
	NSLog(@"addNode: %@", node);
  if (!_rootNode) {
    _rootNode = [node retain];
    _lastNode = node;

  } else if (_topElement) {
    [_topElement addChild:node];

  } else {
    _lastNode.nextSibling = node;
    _lastNode = node;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushNode:(TTStyledElement*)element {
	NSLog(@"pushNode-> %@", element);
	
	// tag开始, 创建出该tag内容的node, 此时node为空, 在tag结束时为node初始化
	
  if (!_stack) {
    _stack = [[NSMutableArray alloc] init];
  }

  [self addNode:element];
  [_stack addObject:element];
  _topElement = element;
	NSLog(@"stack: %@\n_topElement:%@", _stack, _topElement);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popNode {
	TTStyledElement* element = [_stack lastObject];
	if (element) {
		NSLog(@"popNode: %@", element);
		NSLog(@"stack: %@, _topElement:%@", _stack, _topElement);
		[_stack removeLastObject];
	}

	_topElement = [_stack lastObject];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)flushCharacters {
	NSLog(@"flushCharacters");
  if (_chars.length) {
    [self parseText:_chars];
  }

  TT_RELEASE_SAFELY(_chars);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseURLs:(NSString*)string {
	NSLog(@"parseURLs: %@", string);
  NSInteger stringIndex = 0;

  while (stringIndex < string.length) {
    NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
    NSRange startRange = [string rangeOfString:@"http://" options:NSCaseInsensitiveSearch
                                 range:searchRange];
    if (startRange.location == NSNotFound) {
      NSString* text = [string substringWithRange:searchRange];
      TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:text] autorelease];
      [self addNode:node];
      break;

    } else {
      NSRange beforeRange = NSMakeRange(searchRange.location,
        startRange.location - searchRange.location);
      if (beforeRange.length) {
        NSString* text = [string substringWithRange:beforeRange];
        TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:text] autorelease];
        [self addNode:node];
      }

      NSRange subSearchRange = NSMakeRange(startRange.location, string.length - startRange.location);
      NSRange endRange = [string rangeOfString:@" " options:NSCaseInsensitiveSearch
                                 range:subSearchRange];
      if (endRange.location == NSNotFound) {
        NSString* URL = [string substringWithRange:subSearchRange];
        TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] initWithText:URL] autorelease];
        node.URL = URL;
        [self addNode:node];
        break;

      } else {
        NSRange URLRange = NSMakeRange(startRange.location,
                                             endRange.location - startRange.location);
        NSString* URL = [string substringWithRange:URLRange];
        TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] initWithText:URL] autorelease];
        node.URL = URL;
        [self addNode:node];
        stringIndex = endRange.location;
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSXMLParserDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	NSLog(@"didStartElement: %@", elementName);
	//逻辑是 在发现新的tag时去处理之前没有在tag中的内容.
	
  [self flushCharacters];// 在开始处理新tag之前, 处理无tag修饰的内容(之前foundCharacter找到的内容)

  NSString* tag = [elementName lowercaseString];
  if ([tag isEqualToString:@"span"]) {
    TTStyledInline* node = [[[TTStyledInline alloc] init] autorelease];
    node.className =  [attributeDict objectForKey:@"class"];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"br"]) {
    TTStyledLineBreakNode* node = [[[TTStyledLineBreakNode alloc] init] autorelease];
    node.className =  [attributeDict objectForKey:@"class"];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"div"] || [tag isEqualToString:@"p"]) {
    TTStyledBlock* node = [[[TTStyledBlock alloc] init] autorelease];
    node.className =  [attributeDict objectForKey:@"class"];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"b"]) {
    TTStyledBoldNode* node = [[[TTStyledBoldNode alloc] init] autorelease];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"i"]) {
    TTStyledItalicNode* node = [[[TTStyledItalicNode alloc] init] autorelease];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"a"]) {
    TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] init] autorelease];
    node.URL =  [attributeDict objectForKey:@"href"];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"button"]) {
    TTStyledButtonNode* node = [[[TTStyledButtonNode alloc] init] autorelease];
    node.URL =  [attributeDict objectForKey:@"href"];
    [self pushNode:node];

  } else if ([tag isEqualToString:@"img"]) {
    TTStyledImageNode* node = [[[TTStyledImageNode alloc] init] autorelease];
    node.className =  [attributeDict objectForKey:@"class"];
    node.URL =  [attributeDict objectForKey:@"src"];
    NSString* width = [attributeDict objectForKey:@"width"];
    if (width) {
      node.width = width.floatValue;
    }
    NSString* height = [attributeDict objectForKey:@"height"];
    if (height) {
      node.height = height.floatValue;
    }
    [self pushNode:node];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"foundCharacters: %@", string);
  if (!_chars) {
    _chars = [string mutableCopy];

  } else {
    [_chars appendString:string];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"didEndElement: %@", elementName);
  [self flushCharacters];// tag结束, 解析tag内容
  [self popNode];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID {
  static NSDictionary* entityTable = nil;
  if (!entityTable) {
    entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
      [NSData dataWithBytes:" " length:1], @"nbsp",
      [NSData dataWithBytes:"&" length:1], @"amp",
      [NSData dataWithBytes:"\"" length:1], @"quot",
      [NSData dataWithBytes:"<" length:1], @"lt",
      [NSData dataWithBytes:">" length:1], @"gt",
      nil];
  }
  return [entityTable objectForKey:entityName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseXHTML:(NSString*)html {
  NSString* document = [NSString stringWithFormat:@"<x>%@</x>", html];
	NSLog(@"parseXHTML: %@\n\n========================================\n", document);
  NSData* data = [document dataUsingEncoding:html.fastestEncoding];
  NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
  parser.delegate = self;
  [parser parse];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseText:(NSString*)string {
	NSLog(@"parseText: %@", string);
  if (_parseLineBreaks) {
    NSCharacterSet* newLines = [NSCharacterSet newlineCharacterSet];
    NSInteger stringIndex = 0;
    NSInteger length = string.length;

    while (1) {
      NSRange searchRange = NSMakeRange(stringIndex, length - stringIndex);
      NSRange range = [string rangeOfCharacterFromSet:newLines options:0 range:searchRange];
      if (range.location != NSNotFound) {
        // Find all text before the line break and parse it
        NSRange textRange = NSMakeRange(stringIndex, range.location - stringIndex);
        NSString* substr = [string substringWithRange:textRange];
        [self parseURLs:substr];

        // Add a line break node after the text
        TTStyledLineBreakNode* br = [[[TTStyledLineBreakNode alloc] init] autorelease];
        [self addNode:br];

        stringIndex = stringIndex + substr.length + 1;

      } else {
        // Find all text until the end of hte string and parse it
        NSString* substr = [string substringFromIndex:stringIndex];
        [self parseURLs:substr];
        break;
      }
    }

  } else if (_parseURLs) {
    [self parseURLs:string];

  } else {
    TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:string] autorelease];
    [self addNode:node];
  }
}


@end
