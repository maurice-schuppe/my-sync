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

File: mothership.m
Abstract: Mothership model.

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

#import "MotherShip.h"
#import "PhysicalObject.h"

void OGL_Set_Current_Texture_Map_MotherShip(char *texture_map_name, float u_scale, float v_scale, float u_offset, float v_offset)
{
	Texture2D *tex = nil;
	if (texture_map_name != NULL && motherShipTexArray != NULL)
	{
		if (!strcmp(texture_map_name, "mothership.png"))
		{
			tex = motherShipTexArray[0];
		}
		else
		{
			tex = nil;
		}
	}
	if (tex != nil)
	{
		glEnable(GL_TEXTURE_2D);
		[GameObject bindTexture2D:tex];
	}
	else
	{
		glDisable(GL_TEXTURE_2D);
	}
}

// Bounding box of geometry = (0,-0.221676,-14.7814) to (2.34569,1.75054,4.23873).
void MotherShipRender()
{
	static GLfloat VertexData[] = {
		1.23177f, 0.723436f, -4.77135f, 1.23177f, 0.723436f, -4.77135f, 1.23177f, 0.723436f, -4.77135f, 
		1.21633f, 0.802407f, -5.02032f, 1.21633f, 0.802407f, -5.02032f, 
		1.21633f, 0.802407f, -5.02032f, 1.11118f, 0.723436f, -4.77135f, 
		1.11118f, 0.723436f, -4.77135f, 1.11118f, 0.816279f, -5.02032f, 
		1.11118f, 0.712588f, -5.77135f, 1.11118f, 0.712588f, -5.77135f, 
		1.11118f, 0.816279f, -5.75533f, 1.23177f, 0.723436f, -5.77135f, 
		1.23177f, 0.723436f, -5.77135f, 1.23177f, 0.723436f, -5.77135f, 
		1.21633f, 0.802407f, -5.77135f, 1.21633f, 0.802407f, -5.77135f, 
		1.21633f, 0.802407f, -5.77135f, 1.18942f, 0.816279f, -5.02032f, 
		1.19000f, 0.816279f, -5.75533f, 1.23451f, 0.731438f, -4.77135f, 
		1.23451f, 0.731438f, -4.77135f, 1.23451f, 0.731438f, -4.77135f, 
		1.23451f, 0.731438f, -4.77135f, 1.11118f, 0.729771f, -4.77135f, 
		1.11118f, 0.729771f, -4.77135f, 1.22025f, 0.731346f, -4.77135f, 
		1.22025f, 0.731346f, -4.77135f, 1.11118f, 0.802407f, -5.77135f, 
		1.11118f, 0.802407f, -5.77135f, 1.13978f, 0.723436f, -4.77135f, 
		1.13978f, 0.723436f, -4.77135f, 1.13978f, 0.712588f, -5.77135f, 
		1.13978f, 0.712588f, -5.77135f, 1.23177f, 0.723436f, -4.91128f, 
		1.23177f, 0.723436f, -4.91128f, 1.23177f, 0.723436f, -4.91128f, 
		1.13978f, 0.712588f, -4.91128f, 1.13978f, 0.712588f, -4.91128f, 
		1.23177f, 0.723436f, -4.97541f, 1.23177f, 0.723436f, -4.97541f, 
		1.23177f, 0.723436f, -4.97541f, 1.23177f, 0.723436f, -4.97541f, 
		1.13978f, 0.712588f, -4.97541f, 1.13978f, 0.712588f, -4.97541f, 
		1.22896f, 0.723104f, -4.91128f, 1.22896f, 0.723104f, -4.91128f, 
		1.22896f, 0.723104f, -4.91128f, 1.22896f, 0.723104f, -4.91128f, 
		1.22861f, 0.723064f, -4.97541f, 1.22861f, 0.723064f, -4.97541f, 
		1.22861f, 0.723064f, -4.97541f, 1.22861f, 0.723064f, -4.97541f, 
		1.11118f, 0.712588f, -4.91128f, 1.11118f, 0.712588f, -4.91128f, 
		1.11118f, 0.712588f, -4.97541f, 1.11118f, 0.712588f, -4.97541f, 
		1.22873f, 0.725011f, -4.91128f, 1.22873f, 0.725011f, -4.91128f, 
		1.22839f, 0.724970f, -4.97541f, 1.22839f, 0.724970f, -4.97541f, 
		1.13967f, 0.714501f, -4.91128f, 1.13967f, 0.714501f, -4.97541f, 
		1.11118f, 0.714508f, -4.97541f, 1.11118f, 0.714508f, -4.91128f, 
		1.22808f, 0.730589f, -4.91128f, 1.22808f, 0.730589f, -4.91128f, 
		1.22808f, 0.730589f, -4.91128f, 1.22773f, 0.730548f, -4.97541f, 
		1.22773f, 0.730548f, -4.97541f, 1.13934f, 0.730576f, -4.91128f, 
		1.13934f, 0.730576f, -4.91128f, 1.13934f, 0.730576f, -4.91128f, 
		1.13934f, 0.730576f, -4.97541f, 1.11118f, 0.730602f, -4.97541f, 
		1.11118f, 0.730602f, -4.91128f, 1.11118f, 0.730602f, -4.91128f, 
		1.22839f, 0.724970f, -5.08004f, 1.22839f, 0.724970f, -5.08004f, 
		1.13967f, 0.714501f, -5.08004f, 1.22773f, 0.730548f, -5.08004f, 
		1.22773f, 0.730548f, -5.08004f, 1.22773f, 0.730548f, -5.08004f, 
		1.13934f, 0.730576f, -5.08004f, 1.13934f, 0.730576f, -5.08004f, 
		1.11118f, 0.714508f, -5.08004f, 1.11118f, 0.730602f, -5.08004f, 
		1.11118f, 0.730602f, -5.08004f, 1.23321f, 0.730071f, -5.77135f, 
		1.23321f, 0.730071f, -5.77135f, 1.23321f, 0.730071f, -5.77135f, 
		1.23321f, 0.730071f, -5.77135f, 1.11118f, 0.792441f, -5.77135f, 
		1.11118f, 0.792441f, -5.77135f, 1.22457f, 0.722587f, -5.77135f, 
		1.22457f, 0.722587f, -5.77135f, 1.22457f, 0.722587f, -5.77135f, 
		1.21236f, 0.795371f, -5.77135f, 1.21236f, 0.795371f, -5.77135f, 
		1.21236f, 0.795371f, -5.77135f, 1.22658f, 0.728786f, -5.77135f, 
		1.22658f, 0.728786f, -5.77135f, 1.22658f, 0.728786f, -5.77135f, 
		1.11118f, 0.816279f, -5.32019f, 1.18965f, 0.816279f, -5.32019f, 
		1.21633f, 0.802407f, -5.32019f, 1.21633f, 0.802407f, -5.32019f, 
		1.21633f, 0.802407f, -5.32019f, 1.23381f, 0.730700f, -5.32019f, 
		1.23381f, 0.730700f, -5.32019f, 1.23381f, 0.730700f, -5.32019f, 
		1.23381f, 0.730700f, -5.32019f, 1.23177f, 0.723436f, -5.32019f, 
		1.23177f, 0.723436f, -5.32019f, 1.23177f, 0.723436f, -5.32019f, 
		1.23424f, 0.731162f, -4.97541f, 1.23424f, 0.731162f, -4.97541f, 
		1.23424f, 0.731162f, -4.97541f, 1.23424f, 0.731162f, -4.97541f
	};
	static GLfloat NormalData[] = {
		0.949195f, -0.314687f, -0.000397000f, 0.0588150f, -0.997520f, 0.0386650f, 0.000000f, 0.000000f, 1.00000f, 
		0.761871f, 0.643755f, 0.0716310f, 0.761871f, 0.643755f, 0.0716310f, 
		0.761871f, 0.643755f, 0.0716310f, 0.000000f, -0.997009f, 0.0772900f, 
		0.000000f, 0.000000f, 1.00000f, -0.00403000f, 0.986242f, 0.165260f, 
		1.00000e-006f, 0.000000f, -1.00000f, 0.000000f, -1.00000f, 0.000000f, 
		0.000000f, 0.936988f, -0.349361f, 0.000000f, 5.00000e-006f, -1.00000f, 
		0.970074f, -0.242811f, -0.000472000f, 0.117111f, -0.993119f, 0.000000f, 
		0.404263f, 0.527367f, -0.747299f, 0.404263f, 0.527367f, -0.747299f, 
		0.404263f, 0.527367f, -0.747299f, 0.195985f, 0.968970f, 0.150623f, 
		0.167953f, 0.956867f, -0.237058f, 0.732342f, 0.665019f, 0.146373f, 
		0.949195f, -0.314687f, -0.000397000f, 0.732342f, 0.665019f, 0.146373f, 
		0.000000f, 0.000000f, 1.00000f, -0.00794900f, 0.945346f, 0.325973f, 
		0.000000f, 0.000000f, 1.00000f, 0.151380f, 0.943349f, 0.295257f, 
		0.000000f, 0.000000f, 1.00000f, 0.000000f, 0.415513f, -0.909587f, 
		0.000000f, 0.415513f, -0.909587f, 0.0294260f, -0.997882f, 0.0580130f, 
		0.000000f, 0.000000f, 1.00000f, 1.00000e-006f, 0.000000f, -1.00000f, 
		0.0586560f, -0.998278f, 0.000000f, 0.949195f, -0.314687f, -0.000397000f, 
		0.117111f, -0.993119f, 0.000000f, 0.0588150f, -0.997520f, 0.0386650f, 
		0.000000f, 2.00000e-006f, -1.00000f, 0.0294260f, -0.997882f, 0.0580130f, 
		0.949195f, -0.314687f, -0.000397000f, 0.957532f, -0.288328f, -0.000415000f, 
		0.117111f, -0.993119f, 0.000000f, 0.117111f, -0.993119f, 0.000000f, 
		0.000000f, 0.000000f, 1.00000f, 0.0586560f, -0.998278f, 0.000000f, 
		0.000000f, 3.00000e-006f, -1.00000f, -0.993103f, -0.117118f, 0.00543800f, 
		0.117111f, -0.993119f, 0.000000f, 0.0588150f, -0.997520f, 0.0386650f, 
		0.000000f, 0.000000f, 1.00000f, -0.993103f, -0.117118f, 0.00543800f, 
		0.117111f, -0.993119f, 0.000000f, 0.117111f, -0.993119f, 0.000000f, 
		0.000000f, 2.00000e-006f, -1.00000f, 0.000000f, -0.997009f, 0.0772900f, 
		0.000000f, 0.000000f, 1.00000f, 0.000000f, -1.00000f, 0.000000f, 
		0.000000f, 2.00000e-006f, -1.00000f, -0.993099f, -0.117152f, 0.00543800f, 
		0.000000f, 0.000000f, 1.00000f, -0.993106f, -0.117164f, 0.00362500f, 
		0.000000f, 1.00000e-006f, -1.00000f, 0.000000f, 0.000000f, 1.00000f, 
		0.000000f, 0.000000f, 1.00000f, 0.000000f, 1.00000e-006f, -1.00000f, 
		0.000000f, 0.000000f, -1.00000f, -0.993095f, -0.117185f, 0.00543800f, 
		-8.40000e-005f, -1.00000f, 0.000319000f, -0.993106f, -0.117187f, 0.00271900f, 
		-0.000200000f, -1.00000f, 0.000159000f, 0.000000f, 0.000000f, -1.00000f, 
		-0.000922000f, -1.00000f, 0.000000f, -8.40000e-005f, -1.00000f, 0.000319000f, 
		-0.000561000f, -1.00000f, 8.00000e-005f, -0.000921000f, -1.00000f, 0.000000f, 
		0.000000f, 0.000000f, -1.00000f, -0.000922000f, -1.00000f, 0.000000f, 
		0.000000f, -1.00000e-006f, 1.00000f, -0.993110f, -0.117187f, 0.000000f, 
		0.000000f, 0.000000f, 1.00000f, -0.000315000f, -1.00000f, 0.000000f, 
		0.000000f, -1.00000e-006f, 1.00000f, -0.993110f, -0.117187f, 0.000000f, 
		0.000000f, 0.000000f, 1.00000f, -0.000618000f, -1.00000f, 0.000000f, 
		0.000000f, 0.000000f, 1.00000f, 0.000000f, 0.000000f, 1.00000f, 
		-0.000921000f, -1.00000f, 0.000000f, 0.687541f, 0.163965f, -0.707391f, 
		0.000000f, 5.00000e-006f, -1.00000f, 0.970074f, -0.242811f, -0.000472000f, 
		0.687541f, 0.163965f, -0.707391f, 1.00000e-006f, -3.00000e-006f, -1.00000f, 
		1.00000e-006f, 0.000000f, -1.00000f, 0.000000f, 5.00000e-006f, -1.00000f, 
		1.00000e-006f, 0.000000f, -1.00000f, 0.117111f, -0.993119f, 0.000000f, 
		0.000000f, -2.00000e-006f, -1.00000f, 1.00000e-006f, -3.00000e-006f, -1.00000f, 
		1.00000e-006f, 0.000000f, -1.00000f, 0.000000f, -2.00000e-006f, -1.00000f, 
		0.000000f, 5.00000e-006f, -1.00000f, 1.00000e-006f, 0.000000f, -1.00000f, 
		0.000000f, 1.00000f, 0.000000f, 0.237661f, 0.971348f, 9.30000e-005f, 
		0.787182f, 0.616721f, -0.000350000f, 0.787182f, 0.616721f, -0.000350000f, 
		0.787182f, 0.616721f, -0.000350000f, 0.957532f, -0.288328f, -0.000415000f, 
		0.971750f, 0.236009f, -0.000818000f, 0.970074f, -0.242811f, -0.000472000f, 
		0.971750f, 0.236009f, -0.000818000f, 0.957532f, -0.288328f, -0.000415000f, 
		0.970074f, -0.242811f, -0.000472000f, 0.117111f, -0.993119f, 0.000000f, 
		0.949195f, -0.314687f, -0.000397000f, 0.970409f, 0.241466f, -0.00120400f, 
		0.957532f, -0.288328f, -0.000415000f, 0.970409f, 0.241466f, -0.00120400f
	};
	static GLfloat TexCoordData[] = {
		0.131949f, 0.998008f, 0.284539f, 0.998008f, 0.290891f, 0.00472000f, 
		0.106251f, 0.249974f, 0.456156f, 0.445673f, 
		0.639868f, 0.890167f, 0.164431f, 0.998008f, 
		0.290891f, 0.124827f, 0.00151900f, 0.249974f, 
		0.470146f, 0.194430f, 0.843230f, 0.00706100f, 
		0.00151900f, 0.982056f, 0.155403f, 0.222743f, 
		0.131949f, 0.00199200f, 0.993209f, 0.00706100f, 
		0.106251f, 0.998008f, 0.195693f, 0.428865f, 
		0.818499f, 0.00741700f, 0.0794450f, 0.249974f, 
		0.0800260f, 0.982056f, 0.124354f, 0.00199200f, 
		0.139919f, 0.998008f, 0.300613f, 0.991347f, 
		0.298862f, 0.00199200f, 0.00151900f, 0.00199200f, 
		0.297201f, 0.124827f, 0.110151f, 0.00199200f, 
		0.298769f, 0.0161950f, 0.00151900f, 0.998008f, 
		0.470146f, 0.428865f, 0.192915f, 0.998008f, 
		0.290891f, 0.0963440f, 0.395504f, 0.194430f, 
		0.878798f, 0.00706100f, 0.131949f, 0.858634f, 
		0.284539f, 0.858634f, 0.284539f, 0.858634f, 
		0.418901f, 0.0908180f, 0.192915f, 0.858634f, 
		0.131949f, 0.794753f, 0.131949f, 0.794753f, 
		0.284539f, 0.794753f, 0.993209f, 0.996986f, 
		0.424807f, 0.0904730f, 0.878798f, 0.996986f, 
		0.408427f, 0.00199200f, 0.276256f, 0.00199200f, 
		0.281741f, 0.858634f, 0.281741f, 0.858634f, 
		0.435241f, 0.00199200f, 0.276215f, 0.0658730f, 
		0.281396f, 0.794753f, 0.989285f, 0.996986f, 
		0.418901f, 0.119302f, 0.164431f, 0.858634f, 
		0.424807f, 0.118957f, 0.843230f, 0.996986f, 
		0.406528f, 0.00221600f, 0.278155f, 0.00199200f, 
		0.437140f, 0.00221600f, 0.278114f, 0.0658730f, 
		0.416996f, 0.0909300f, 0.426712f, 0.0905850f, 
		0.426719f, 0.118957f, 0.416990f, 0.119302f, 
		0.400972f, 0.00287200f, 0.283711f, 0.00199200f, 
		0.269735f, 0.170078f, 0.283670f, 0.0658730f, 
		0.269390f, 0.106197f, 0.400985f, 0.0912570f, 
		0.181350f, 0.170078f, 0.181350f, 0.170078f, 
		0.181350f, 0.106197f, 0.153307f, 0.106197f, 
		0.400959f, 0.119300f, 0.153307f, 0.170078f, 
		0.453579f, 0.00199200f, 0.278114f, 0.170078f, 
		0.443152f, 0.0903610f, 0.269390f, 0.00199200f, 
		0.459135f, 0.00264800f, 0.283670f, 0.170078f, 
		0.459163f, 0.0906880f, 0.181350f, 0.00199200f, 
		0.443158f, 0.118733f, 0.459189f, 0.118732f, 
		0.153307f, 0.00199200f, 0.151641f, 0.240063f, 
		0.151641f, 0.240063f, 0.138558f, 0.00199200f, 
		0.659961f, 0.00741700f, 0.470146f, 0.402852f, 
		0.470146f, 0.402852f, 0.174181f, 0.220529f, 
		0.174181f, 0.220529f, 0.984262f, 0.00706100f, 
		0.206053f, 0.410498f, 0.206053f, 0.410498f, 
		0.206053f, 0.410498f, 0.168931f, 0.236708f, 
		0.168931f, 0.236708f, 0.168931f, 0.236708f, 
		0.00151900f, 0.548647f, 0.0796740f, 0.548647f, 
		0.106251f, 0.548647f, 0.639868f, 0.232949f, 
		0.818499f, 0.996220f, 0.139184f, 0.451354f, 
		0.482707f, 0.232949f, 0.139184f, 0.451354f, 
		0.661338f, 0.996220f, 0.131949f, 0.451354f, 
		0.131949f, 0.451354f, 0.993209f, 0.568181f, 
		0.139644f, 0.794753f, 0.300007f, 0.544091f, 
		0.139644f, 0.794753f, 0.483719f, 0.988585f
	};
	static GLushort Indices[] = {
		2, 23, 2, 27, 2, 25, 2, 7, 2, 31, 91, 17, 91, 107, 91, 111, 
		14, 114, 14, 42, 14, 52, 14, 44, 33, 56, 33, 10, 14, 33, 14, 96, 
		26, 8, 26, 24, 9, 93, 9, 99, 9, 102, 9, 95, 9, 32, 36, 1, 
		36, 30, 38, 30, 54, 30, 6, 36, 38, 36, 48, 41, 35, 41, 47, 41, 
		51, 69, 67, 69, 72, 69, 73, 84, 73, 87, 73, 74, 71, 74, 76, 50, 
		46, 50, 58, 60, 66, 60, 68, 60, 82, 60, 78, 43, 49, 43, 59, 43, 
		62, 55, 62, 63, 37, 53, 37, 64, 61, 75, 61, 70, 57, 70, 65, 37, 
		61, 45, 57, 79, 77, 79, 81, 79, 83, 85, 83, 86, 69, 84, 69, 80, 
		13, 90, 13, 110, 13, 113, 101, 89, 101, 12, 101, 94, 92, 29, 92, 16, 
		92, 98, 97, 16, 97, 88, 97, 100, 109, 106, 109, 5, 109, 118, 112, 108, 
		112, 117, 112, 40, 116, 4, 116, 22, 39, 115, 39, 21, 39, 0, 39, 34, 
		3, 104, 18, 103, 18, 8, 18, 26, 18, 20, 3, 11, 103, 11, 104, 19, 
		105, 19, 15, 19, 28, 11, 105, 104, 105, 3
	};
	
	[GameObject setTexcoordPointer:TexCoordData size:2 type:GL_FLOAT];
	[PhysicalObject setNormalPointer:NormalData type:GL_FLOAT];
	[GameObject setVertexPointer:VertexData size:3 type:GL_FLOAT];
	
	
	// Material attributes for surface 'lambert2SG'
	SetMaterialParameters(32.0000f, 0.000000f, 0.000000f, 0.000000f, 1.00000f, 1.00000f, 1.00000f);
	
	// Set a new diffuse texture map
	OGL_Set_Current_Texture_Map_MotherShip("mothership.png", 1.00000f, 1.00000f, 0.000000f, 0.000000f);
	
	glDrawElements(GL_TRIANGLE_STRIP, 10, GL_UNSIGNED_SHORT, &Indices[0]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[10]);
	glDrawElements(GL_TRIANGLE_STRIP, 12, GL_UNSIGNED_SHORT, &Indices[16]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[28]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[32]);
	glDrawElements(GL_TRIANGLE_STRIP, 10, GL_UNSIGNED_SHORT, &Indices[36]);
	glDrawElements(GL_TRIANGLE_STRIP, 9, GL_UNSIGNED_SHORT, &Indices[46]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[55]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[59]);
	glDrawElements(GL_TRIANGLE_STRIP, 14, GL_UNSIGNED_SHORT, &Indices[65]);
	glDrawElements(GL_TRIANGLE_STRIP, 12, GL_UNSIGNED_SHORT, &Indices[79]);
	glDrawElements(GL_TRIANGLE_STRIP, 9, GL_UNSIGNED_SHORT, &Indices[91]);
	glDrawElements(GL_TRIANGLE_STRIP, 11, GL_UNSIGNED_SHORT, &Indices[100]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[111]);
	glDrawElements(GL_TRIANGLE_STRIP, 9, GL_UNSIGNED_SHORT, &Indices[115]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[124]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[128]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[134]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[140]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[146]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[152]);
	glDrawElements(GL_TRIANGLE_STRIP, 6, GL_UNSIGNED_SHORT, &Indices[158]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[164]);
	glDrawElements(GL_TRIANGLE_STRIP, 8, GL_UNSIGNED_SHORT, &Indices[168]);
	glDrawElements(GL_TRIANGLE_STRIP, 11, GL_UNSIGNED_SHORT, &Indices[176]);
	glDrawElements(GL_TRIANGLE_STRIP, 11, GL_UNSIGNED_SHORT, &Indices[187]);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, &Indices[198]);
}