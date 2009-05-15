/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: CubeMap.m
Abstract: Cube Map used for rotating background.

Version: 2.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "CubeMap.h"
#import "PhysicalObject.h"
#import "Utils.h"

@implementation CubeMap

- (id) initWithTextures:(Texture2D*)posX :(Texture2D*)posY :(Texture2D*)posZ :(Texture2D*)negX :(Texture2D*)negY :(Texture2D*)negZ
{
	float*			vPtr = _vtxData;
	float*			tPtr = _texData;
	unsigned		i;

	if ((self = [super init])) {
		_posX = [posX retain];
		_posY = [posY retain];
		_posZ = [posZ retain];
		_negX = [negX retain];
		_negY = [negY retain];
		_negZ = [negZ retain];
		
		Texture2D*	tex[6] = {_posX, _negZ, _negX, _posZ, _posY, _negY};
		for(i=0; i<6; i++)
		{
			GLfloat one  = 1.0f;
			GLfloat zero = 0.0f;
			tPtr[0] = zero; tPtr[1] = zero;  tPtr+=2;
			tPtr[0] = zero; tPtr[1] = one;   tPtr+=2;
			tPtr[0] = one;  tPtr[1] = zero;  tPtr+=2;
			tPtr[0] = one;  tPtr[1] = one;   tPtr+=2;
			
			[GameObject bindTexture2D:tex[i]];
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		}
		
		//Set-up cube vertices and tex coords.
		
		// posx
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;

		// negz
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;

		// negx
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;

		// posz
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;

		// posy
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]= 1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;

		// negy
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]= 1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]= 1.0f; vPtr[3]=1.0f; vPtr+=4;
		vPtr[0]=-1.0f; vPtr[1]=-1.0f; vPtr[2]=-1.0f; vPtr[3]=1.0f; vPtr+=4;
	}
	
	
	return self;
}

- (void) dealloc
{
	[_posX release];
	[_posY release];
	[_posZ release];
	[_negX release];
	[_negY release];
	[_negZ release];

	[super dealloc];
}

- (void) renderAtTime:(NSTimeInterval)time
{
	unsigned	i;
	Texture2D*	tex[6] = {_posX, _negZ, _negX, _posZ, _posY, _negY};

	glPushMatrix();
	glScalef(1000.0f, 1000.0f, 1000.0f);

	glDepthFunc(GL_ALWAYS);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	[GameObject setVertexPointer:_vtxData size:4 type:GL_FLOAT];
	[GameObject setTexcoordPointer:_texData size:2 type:GL_FLOAT];

	glColor4f(1.0, 0.92, 0.83, 1.0);
	//Renders all cube faces.
	for(i=0; i<6; i++) {
		[GameObject bindTexture2D:tex[i]];
		glDrawArrays(GL_TRIANGLE_STRIP, i*4, 4);
	}

	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	glDepthFunc(GL_LEQUAL);
	
	glPopMatrix();
}

@end