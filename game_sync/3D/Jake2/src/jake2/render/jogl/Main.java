/*
 * Main.java
 * Copyright (C) 2003
 *
 * $Id: Main.java,v 1.8 2005/05/07 18:23:26 cawe Exp $
 */
/*
Copyright (C) 1997-2001 Id Software, Inc.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
package jake2.render.jogl;

import jake2.Defines;
import jake2.Globals;
import jake2.client.*;
import jake2.game.*;
import jake2.game.cplane_t;
import jake2.game.cvar_t;
import jake2.qcommon.*;
import jake2.render.*;
import jake2.util.Math3D;
import jake2.util.Vargs;

import java.awt.Dimension;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import net.java.games.jogl.GL;
import net.java.games.jogl.Version;

/**
 * Main
 * 
 * @author cwei
 */
public abstract class Main extends Base {

	public static int[] d_8to24table = new int[256];

	int c_visible_lightmaps;
	int c_visible_textures;

	int registration_sequence;

	// this a hack for function pointer test
	// default disabled
	boolean qglColorTableEXT = false;
	boolean qglSelectTextureSGIS = false;
	boolean qglActiveTextureARB = false;
	boolean qglPointParameterfEXT = false;
	boolean qglLockArraysEXT = false;
	boolean qglMTexCoord2fSGIS = false;
	boolean qwglSwapIntervalEXT = false;

	//	=================
	//  abstract methods
	//	=================
	protected abstract void Draw_GetPalette();

	abstract void GL_ImageList_f();
	abstract void GL_ScreenShot_f();
	abstract void GL_SetTexturePalette(int[] palette);
	abstract void GL_Strings_f();

	abstract void Mod_Modellist_f();
	abstract mleaf_t Mod_PointInLeaf(float[] point, model_t model);

	abstract void GL_SetDefaultState();

	abstract void GL_InitImages();
	abstract void Mod_Init(); // Model.java
	abstract void R_InitParticleTexture(); // MIsc.java
	abstract void R_DrawAliasModel(entity_t e); // Mesh.java
	abstract void R_DrawBrushModel(entity_t e); // Surf.java
	abstract void Draw_InitLocal();
	abstract void R_LightPoint(float[] p, float[] color);
	abstract void R_PushDlights();
	abstract void R_MarkLeaves();
	abstract void R_DrawWorld();
	abstract void R_RenderDlights();
	abstract void R_DrawAlphaSurfaces();

	abstract void Mod_FreeAll();

	abstract void GL_ShutdownImages();
	abstract void GL_Bind(int texnum);
	abstract void GL_TexEnv(int mode);
	abstract void GL_TextureMode(String string);
	abstract void GL_TextureAlphaMode(String string);
	abstract void GL_TextureSolidMode(String string);
	abstract void GL_UpdateSwapInterval();

	/*
	====================================================================
	
	from gl_rmain.c
	
	====================================================================
	*/

	int GL_TEXTURE0 = GL.GL_TEXTURE0;
	int GL_TEXTURE1 = GL.GL_TEXTURE1;

	model_t r_worldmodel;

	float gldepthmin, gldepthmax;

	glconfig_t gl_config = new glconfig_t();
	glstate_t gl_state = new glstate_t();

	image_t r_notexture; // use for bad textures
	image_t r_particletexture; // little dot for particles

	entity_t currententity;
	model_t currentmodel;

	cplane_t frustum[] = { new cplane_t(), new cplane_t(), new cplane_t(), new cplane_t()};

	int r_visframecount; // bumped when going to a new PVS
	int r_framecount; // used for dlight push checking

	int c_brush_polys, c_alias_polys;

	float v_blend[] = { 0, 0, 0, 0 }; // final blending color

	//
	//	   view origin
	//
	float[] vup = { 0, 0, 0 };
	float[] vpn = { 0, 0, 0 };
	float[] vright = { 0, 0, 0 };
	float[] r_origin = { 0, 0, 0 };

	float r_world_matrix[] = new float[16];
	float r_base_world_matrix[] = new float[16];

	//
	//	   screen size info
	//
	refdef_t r_newrefdef = new refdef_t();

	int r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2;

	cvar_t r_norefresh;
	cvar_t r_drawentities;
	cvar_t r_drawworld;
	cvar_t r_speeds;
	cvar_t r_fullbright;
	cvar_t r_novis;
	cvar_t r_nocull;
	cvar_t r_lerpmodels;
	cvar_t r_lefthand;

	cvar_t r_lightlevel;
	// FIXME: This is a HACK to get the client's light level

	cvar_t gl_nosubimage;
	cvar_t gl_allow_software;

	cvar_t gl_vertex_arrays;

	cvar_t gl_particle_min_size;
	cvar_t gl_particle_max_size;
	cvar_t gl_particle_size;
	cvar_t gl_particle_att_a;
	cvar_t gl_particle_att_b;
	cvar_t gl_particle_att_c;

	cvar_t gl_ext_swapinterval;
	cvar_t gl_ext_palettedtexture;
	cvar_t gl_ext_multitexture;
	cvar_t gl_ext_pointparameters;
	cvar_t gl_ext_compiled_vertex_array;

	cvar_t gl_log;
	cvar_t gl_bitdepth;
	cvar_t gl_drawbuffer;
	cvar_t gl_driver;
	cvar_t gl_lightmap;
	cvar_t gl_shadows;
	cvar_t gl_mode;
	cvar_t gl_dynamic;
	cvar_t gl_monolightmap;
	cvar_t gl_modulate;
	cvar_t gl_nobind;
	cvar_t gl_round_down;
	cvar_t gl_picmip;
	cvar_t gl_skymip;
	cvar_t gl_showtris;
	cvar_t gl_ztrick;
	cvar_t gl_finish;
	cvar_t gl_clear;
	cvar_t gl_cull;
	cvar_t gl_polyblend;
	cvar_t gl_flashblend;
	cvar_t gl_playermip;
	cvar_t gl_saturatelighting;
	cvar_t gl_swapinterval;
	cvar_t gl_texturemode;
	cvar_t gl_texturealphamode;
	cvar_t gl_texturesolidmode;
	cvar_t gl_lockpvs;

	cvar_t gl_3dlabs_broken;

	cvar_t vid_gamma;
	cvar_t vid_ref;

	// ============================================================================
	// to port from gl_rmain.c, ...
	// ============================================================================

	/*
	=================
	R_CullBox
	
	Returns true if the box is completely outside the frustom
	=================
	*/
	final boolean R_CullBox(float[] mins, float[] maxs) {
		assert(mins.length == 3 && maxs.length == 3) : "vec3_t bug";

		if (r_nocull.value != 0)
			return false;

		for (int i = 0; i < 4; i++) {
			if (Math3D.BoxOnPlaneSide(mins, maxs, frustum[i]) == 2)
				return true;
		}
		return false;
	}

	final void R_RotateForEntity(entity_t e) {

		gl.glTranslatef(e.origin[0], e.origin[1], e.origin[2]);

		gl.glRotatef(e.angles[1], 0, 0, 1);
		gl.glRotatef(-e.angles[0], 0, 1, 0);
		gl.glRotatef(-e.angles[2], 1, 0, 0);
	}

	/*
	=============================================================
	
	   SPRITE MODELS
	
	=============================================================
	*/

	/*
	=================
	R_DrawSpriteModel
	
	=================
	*/
	void R_DrawSpriteModel(entity_t e) {
		float alpha = 1.0F;
		float[] point = { 0, 0, 0 };

		qfiles.dsprframe_t frame;
		qfiles.dsprite_t psprite;

		// don't even bother culling, because it's just a single
		// polygon without a surface cache

		psprite = (qfiles.dsprite_t) currentmodel.extradata;

		e.frame %= psprite.numframes;

		frame = psprite.frames[e.frame];

		if ((e.flags & Defines.RF_TRANSLUCENT) != 0)
			alpha = e.alpha;

		if (alpha != 1.0F)
			gl.glEnable(GL.GL_BLEND);

		gl.glColor4f(1, 1, 1, alpha);

		GL_Bind(currentmodel.skins[e.frame].texnum);

		GL_TexEnv(GL.GL_MODULATE);

		if (alpha == 1.0)
			gl.glEnable(GL.GL_ALPHA_TEST);
		else
			gl.glDisable(GL.GL_ALPHA_TEST);

		gl.glBegin(GL.GL_QUADS);

		gl.glTexCoord2f(0, 1);
		Math3D.VectorMA(e.origin, -frame.origin_y, vup, point);
		Math3D.VectorMA(point, -frame.origin_x, vright, point);
		gl.glVertex3f(point[0], point[1], point[2]);

		gl.glTexCoord2f(0, 0);
		Math3D.VectorMA(e.origin, frame.height - frame.origin_y, vup, point);
		Math3D.VectorMA(point, -frame.origin_x, vright, point);
		gl.glVertex3f(point[0], point[1], point[2]);

		gl.glTexCoord2f(1, 0);
		Math3D.VectorMA(e.origin, frame.height - frame.origin_y, vup, point);
		Math3D.VectorMA(point, frame.width - frame.origin_x, vright, point);
		gl.glVertex3f(point[0], point[1], point[2]);

		gl.glTexCoord2f(1, 1);
		Math3D.VectorMA(e.origin, -frame.origin_y, vup, point);
		Math3D.VectorMA(point, frame.width - frame.origin_x, vright, point);
		gl.glVertex3f(point[0], point[1], point[2]);

		gl.glEnd();

		gl.glDisable(GL.GL_ALPHA_TEST);
		GL_TexEnv(GL.GL_REPLACE);

		if (alpha != 1.0F)
			gl.glDisable(GL.GL_BLEND);

		gl.glColor4f(1, 1, 1, 1);
	}

	// ==================================================================================

	/*
	=============
	R_DrawNullModel
	=============
	cwei :-)
	*/
	void R_DrawNullModel() {
		float[] shadelight = { 0, 0, 0 };

		if ((currententity.flags & Defines.RF_FULLBRIGHT) != 0) {
			// cwei wollte blau: shadelight[0] = shadelight[1] = shadelight[2] = 1.0F;
			shadelight[0] = shadelight[1] = shadelight[2] = 0.0F;
			shadelight[2] = 0.8F;
		}
		else {
			R_LightPoint(currententity.origin, shadelight);
		}

		gl.glPushMatrix();
		R_RotateForEntity(currententity);

		gl.glDisable(GL.GL_TEXTURE_2D);
		gl.glColor3f(shadelight[0], shadelight[1], shadelight[2]);

		// this replaces the TRIANGLE_FAN
		glut.glutWireCube(gl, 20);

		/*
			gl.glBegin(GL.GL_TRIANGLE_FAN);
		gl.glVertex3f(0, 0, -16);
		int i;
		for (i=0 ; i<=4 ; i++) {
			gl.glVertex3f((float)(16.0f * Math.cos(i * Math.PI / 2)), (float)(16.0f * Math.sin(i * Math.PI / 2)), 0.0f);
		}
		gl.glEnd();
		
		gl.glBegin(GL.GL_TRIANGLE_FAN);
		gl.glVertex3f (0, 0, 16);
		for (i=4 ; i>=0 ; i--) {
			gl.glVertex3f((float)(16.0f * Math.cos(i * Math.PI / 2)), (float)(16.0f * Math.sin(i * Math.PI / 2)), 0.0f);
		}
		gl.glEnd();
		*/
		gl.glColor3f(1, 1, 1);
		gl.glPopMatrix();
		gl.glEnable(GL.GL_TEXTURE_2D);
	}

	/*
	=============
	R_DrawEntitiesOnList
	=============
	*/
	void R_DrawEntitiesOnList() {
		int i;

		if (r_drawentities.value == 0.0f)
			return;

		// draw non-transparent first
		for (i = 0; i < r_newrefdef.num_entities; i++) {
			currententity = r_newrefdef.entities[i];
			if ((currententity.flags & Defines.RF_TRANSLUCENT) != 0)
				continue; // solid

			if ((currententity.flags & Defines.RF_BEAM) != 0) {
				R_DrawBeam(currententity);
			}
			else {
				currentmodel = currententity.model;
				if (currentmodel == null) {
					R_DrawNullModel();
					continue;
				}
				switch (currentmodel.type) {
					case mod_alias :
						R_DrawAliasModel(currententity);
						break;
					case mod_brush :
						R_DrawBrushModel(currententity);
						break;
					case mod_sprite :
						R_DrawSpriteModel(currententity);
						break;
					default :
						Com.Error(Defines.ERR_DROP, "Bad modeltype");
						break;
				}
			}
		}
		// draw transparent entities
		// we could sort these if it ever becomes a problem...
		gl.glDepthMask(false); // no z writes
		for (i = 0; i < r_newrefdef.num_entities; i++) {
			currententity = r_newrefdef.entities[i];
			if ((currententity.flags & Defines.RF_TRANSLUCENT) == 0)
				continue; // solid

			if ((currententity.flags & Defines.RF_BEAM) != 0) {
				R_DrawBeam(currententity);
			}
			else {
				currentmodel = currententity.model;

				if (currentmodel == null) {
					R_DrawNullModel();
					continue;
				}
				switch (currentmodel.type) {
					case mod_alias :
						R_DrawAliasModel(currententity);
						break;
					case mod_brush :
						R_DrawBrushModel(currententity);
						break;
					case mod_sprite :
						R_DrawSpriteModel(currententity);
						break;
					default :
						Com.Error(Defines.ERR_DROP, "Bad modeltype");
						break;
				}
			}
		}
		gl.glDepthMask(true); // back to writing
	}
	
	/*
	** GL_DrawParticles
	**
	*/
	void GL_DrawParticles(int num_particles) {
		float[] up = { 0, 0, 0 };
		float[] right = { 0, 0, 0 };
		float scale;
		int color;

		float origin_x, origin_y, origin_z;

		Math3D.VectorScale(vup, 1.5f, up);
		Math3D.VectorScale(vright, 1.5f, right);
		
		GL_Bind(r_particletexture.texnum);
		gl.glDepthMask(false); // no z buffering
		gl.glEnable(GL.GL_BLEND);
		GL_TexEnv(GL.GL_MODULATE);
		
		gl.glBegin(GL.GL_TRIANGLES);

		FloatBuffer sourceVertices = particle_t.vertexArray;
		IntBuffer sourceColors = particle_t.colorArray;
		for (int j = 0, i = 0; i < num_particles; i++) {
			origin_x = sourceVertices.get(j++);
			origin_y = sourceVertices.get(j++);
			origin_z = sourceVertices.get(j++);

			// hack a scale up to keep particles from disapearing
			scale =
				(origin_x - r_origin[0]) * vpn[0]
					+ (origin_y - r_origin[1]) * vpn[1]
					+ (origin_z - r_origin[2]) * vpn[2];

			scale = (scale < 20) ? 1 :  1 + scale * 0.004f;

			color = sourceColors.get(i);
			gl.glColor4ub(
				(byte)((color >> 0) & 0xFF),
				(byte)((color >> 8) & 0xFF),
				(byte)((color >> 16) & 0xFF),
				(byte)((color >> 24) & 0xFF)
			);
			// first vertex
			gl.glTexCoord2f(0.0625f, 0.0625f);
			gl.glVertex3f(origin_x, origin_y, origin_z);
			// second vertex
			gl.glTexCoord2f(1.0625f, 0.0625f);
			gl.glVertex3f(origin_x + up[0] * scale, origin_y + up[1] * scale, origin_z + up[2] * scale);
			// third vertex
			gl.glTexCoord2f(0.0625f, 1.0625f);
			gl.glVertex3f(origin_x + right[0] * scale, origin_y + right[1] * scale, origin_z + right[2] * scale);
		}
		gl.glEnd();
		
		gl.glDisable(GL.GL_BLEND);
		gl.glColor4f(1, 1, 1, 1);
		gl.glDepthMask(true); // back to normal Z buffering
		GL_TexEnv(GL.GL_REPLACE);
	}

	/*
	===============
	R_DrawParticles
	===============
	*/
	void R_DrawParticles() {

		if (gl_ext_pointparameters.value != 0.0f && qglPointParameterfEXT) {

			gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
			gl.glVertexPointer(3, GL.GL_FLOAT, 0, particle_t.vertexArray);
			gl.glEnableClientState(GL.GL_COLOR_ARRAY);
			gl.glColorPointer(4, GL.GL_UNSIGNED_BYTE, 0, particle_t.colorArray);
			
			gl.glDepthMask(false);
			gl.glEnable(GL.GL_BLEND);
			gl.glDisable(GL.GL_TEXTURE_2D);
			gl.glPointSize(gl_particle_size.value);
			
			gl.glDrawArrays(GL.GL_POINTS, 0, r_newrefdef.num_particles);
			
			gl.glDisableClientState(GL.GL_COLOR_ARRAY);
			gl.glDisableClientState(GL.GL_VERTEX_ARRAY);

			gl.glDisable(GL.GL_BLEND);
			gl.glColor4f(1.0F, 1.0F, 1.0F, 1.0F);
			gl.glDepthMask(true);
			gl.glEnable(GL.GL_TEXTURE_2D);

		}
		else {
			GL_DrawParticles(r_newrefdef.num_particles);
		}
	}

	/*
	============
	R_PolyBlend
	============
	*/
	void R_PolyBlend() {
		if (gl_polyblend.value == 0.0f)
			return;

		if (v_blend[3] == 0.0f)
			return;

		gl.glDisable(GL.GL_ALPHA_TEST);
		gl.glEnable(GL.GL_BLEND);
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glDisable(GL.GL_TEXTURE_2D);

		gl.glLoadIdentity();

		// FIXME: get rid of these
		gl.glRotatef(-90, 1, 0, 0); // put Z going up
		gl.glRotatef(90, 0, 0, 1); // put Z going up

		gl.glColor4f(v_blend[0], v_blend[1], v_blend[2], v_blend[3]);

		gl.glBegin(GL.GL_QUADS);

		gl.glVertex3f(10, 100, 100);
		gl.glVertex3f(10, -100, 100);
		gl.glVertex3f(10, -100, -100);
		gl.glVertex3f(10, 100, -100);
		gl.glEnd();

		gl.glDisable(GL.GL_BLEND);
		gl.glEnable(GL.GL_TEXTURE_2D);
		gl.glEnable(GL.GL_ALPHA_TEST);

		gl.glColor4f(1, 1, 1, 1);
	}

	// =======================================================================

	int SignbitsForPlane(cplane_t out) {
		// for fast box on planeside test
		int bits = 0;
		for (int j = 0; j < 3; j++) {
			if (out.normal[j] < 0)
				bits |= (1 << j);
		}
		return bits;
	}

	void R_SetFrustum() {
		// rotate VPN right by FOV_X/2 degrees
		Math3D.RotatePointAroundVector(frustum[0].normal, vup, vpn, - (90f - r_newrefdef.fov_x / 2f));
		// rotate VPN left by FOV_X/2 degrees
		Math3D.RotatePointAroundVector(frustum[1].normal, vup, vpn, 90f - r_newrefdef.fov_x / 2f);
		// rotate VPN up by FOV_X/2 degrees
		Math3D.RotatePointAroundVector(frustum[2].normal, vright, vpn, 90f - r_newrefdef.fov_y / 2f);
		// rotate VPN down by FOV_X/2 degrees
		Math3D.RotatePointAroundVector(frustum[3].normal, vright, vpn, - (90f - r_newrefdef.fov_y / 2f));

		for (int i = 0; i < 4; i++) {
			frustum[i].type = Defines.PLANE_ANYZ;
			frustum[i].dist = Math3D.DotProduct(r_origin, frustum[i].normal);
			frustum[i].signbits = (byte) SignbitsForPlane(frustum[i]);
		}
	}

	// =======================================================================

	/*
	===============
	R_SetupFrame
	===============
	*/
	void R_SetupFrame() {
		int i;
		mleaf_t leaf;

		r_framecount++;

		//	build the transformation matrix for the given view angles
		Math3D.VectorCopy(r_newrefdef.vieworg, r_origin);

		Math3D.AngleVectors(r_newrefdef.viewangles, vpn, vright, vup);

		//	current viewcluster
		if ((r_newrefdef.rdflags & Defines.RDF_NOWORLDMODEL) == 0) {
			r_oldviewcluster = r_viewcluster;
			r_oldviewcluster2 = r_viewcluster2;
			leaf = Mod_PointInLeaf(r_origin, r_worldmodel);
			r_viewcluster = r_viewcluster2 = leaf.cluster;

			// check above and below so crossing solid water doesn't draw wrong
			if (leaf.contents == 0) { // look down a bit
				float[] temp = { 0, 0, 0 };

				Math3D.VectorCopy(r_origin, temp);
				temp[2] -= 16;
				leaf = Mod_PointInLeaf(temp, r_worldmodel);
				if ((leaf.contents & Defines.CONTENTS_SOLID) == 0 && (leaf.cluster != r_viewcluster2))
					r_viewcluster2 = leaf.cluster;
			}
			else { // look up a bit
				float[] temp = { 0, 0, 0 };

				Math3D.VectorCopy(r_origin, temp);
				temp[2] += 16;
				leaf = Mod_PointInLeaf(temp, r_worldmodel);
				if ((leaf.contents & Defines.CONTENTS_SOLID) == 0 && (leaf.cluster != r_viewcluster2))
					r_viewcluster2 = leaf.cluster;
			}
		}

		for (i = 0; i < 4; i++)
			v_blend[i] = r_newrefdef.blend[i];

		c_brush_polys = 0;
		c_alias_polys = 0;

		// clear out the portion of the screen that the NOWORLDMODEL defines
		if ((r_newrefdef.rdflags & Defines.RDF_NOWORLDMODEL) != 0) {
			gl.glEnable(GL.GL_SCISSOR_TEST);
			gl.glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
			gl.glScissor(
				r_newrefdef.x,
				vid.height - r_newrefdef.height - r_newrefdef.y,
				r_newrefdef.width,
				r_newrefdef.height);
			gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
			gl.glClearColor(1.0f, 0.0f, 0.5f, 0.5f);
			gl.glDisable(GL.GL_SCISSOR_TEST);
		}
	}

	void MYgluPerspective(double fovy, double aspect, double zNear, double zFar) {
		double xmin, xmax, ymin, ymax;

		ymax = zNear * Math.tan(fovy * Math.PI / 360.0);
		ymin = -ymax;

		xmin = ymin * aspect;
		xmax = ymax * aspect;

		xmin += - (2 * gl_state.camera_separation) / zNear;
		xmax += - (2 * gl_state.camera_separation) / zNear;

		gl.glFrustum(xmin, xmax, ymin, ymax, zNear, zFar);
	}

	/*
	=============
	R_SetupGL
	=============
	*/
	void R_SetupGL() {
		float screenaspect;
		int x, x2, y2, y, w, h;

		//
		// set up viewport
		//
		x = (int) Math.floor(r_newrefdef.x * vid.width / vid.width);
		x2 = (int) Math.ceil((r_newrefdef.x + r_newrefdef.width) * vid.width / vid.width);
		y = (int) Math.floor(vid.height - r_newrefdef.y * vid.height / vid.height);
		y2 = (int) Math.ceil(vid.height - (r_newrefdef.y + r_newrefdef.height) * vid.height / vid.height);

		w = x2 - x;
		h = y - y2;

		gl.glViewport(x, y2, w, h);

		//
		// set up projection matrix
		//
		screenaspect = (float) r_newrefdef.width / r_newrefdef.height;
		gl.glMatrixMode(GL.GL_PROJECTION);
		gl.glLoadIdentity();
		MYgluPerspective(r_newrefdef.fov_y, screenaspect, 4, 4096);

		gl.glCullFace(GL.GL_FRONT);

		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glLoadIdentity();

		gl.glRotatef(-90, 1, 0, 0); // put Z going up
		gl.glRotatef(90, 0, 0, 1); // put Z going up
		gl.glRotatef(-r_newrefdef.viewangles[2], 1, 0, 0);
		gl.glRotatef(-r_newrefdef.viewangles[0], 0, 1, 0);
		gl.glRotatef(-r_newrefdef.viewangles[1], 0, 0, 1);
		gl.glTranslatef(-r_newrefdef.vieworg[0], -r_newrefdef.vieworg[1], -r_newrefdef.vieworg[2]);

		gl.glGetFloatv(GL.GL_MODELVIEW_MATRIX, r_world_matrix);

		//
		// set drawing parms
		//
		if (gl_cull.value != 0.0f)
			gl.glEnable(GL.GL_CULL_FACE);
		else
			gl.glDisable(GL.GL_CULL_FACE);

		gl.glDisable(GL.GL_BLEND);
		gl.glDisable(GL.GL_ALPHA_TEST);
		gl.glEnable(GL.GL_DEPTH_TEST);
	}

	/*
	=============
	R_Clear
	=============
	*/
	int trickframe = 0;

	void R_Clear() {
		if (gl_ztrick.value != 0.0f) {

			if (gl_clear.value != 0.0f) {
				gl.glClear(GL.GL_COLOR_BUFFER_BIT);
			}

			trickframe++;
			if ((trickframe & 1) != 0) {
				gldepthmin = 0;
				gldepthmax = 0.49999f;
				gl.glDepthFunc(GL.GL_LEQUAL);
			}
			else {
				gldepthmin = 1;
				gldepthmax = 0.5f;
				gl.glDepthFunc(GL.GL_GEQUAL);
			}
		}
		else {
			if (gl_clear.value != 0.0f)
				gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
			else
				gl.glClear(GL.GL_DEPTH_BUFFER_BIT);

			gldepthmin = 0;
			gldepthmax = 1;
			gl.glDepthFunc(GL.GL_LEQUAL);
		}
		gl.glDepthRange(gldepthmin, gldepthmax);
	}

	void R_Flash() {
		R_PolyBlend();
	}

	/*
	================
	R_RenderView
	
	r_newrefdef must be set before the first call
	================
	*/
	void R_RenderView(refdef_t fd) {

		if (r_norefresh.value != 0.0f)
			return;

		r_newrefdef = fd;

		// included by cwei
		if (r_newrefdef == null) {
			Com.Error(Defines.ERR_DROP, "R_RenderView: refdef_t fd is null");
		}

		if (r_worldmodel == null && (r_newrefdef.rdflags & Defines.RDF_NOWORLDMODEL) == 0)
			Com.Error(Defines.ERR_DROP, "R_RenderView: NULL worldmodel");

		if (r_speeds.value != 0.0f) {
			c_brush_polys = 0;
			c_alias_polys = 0;
		}

		R_PushDlights();

		if (gl_finish.value != 0.0f)
			gl.glFinish();

		R_SetupFrame();

		R_SetFrustum();

		R_SetupGL();

		R_MarkLeaves(); // done here so we know if we're in water

		R_DrawWorld();

		R_DrawEntitiesOnList();

		R_RenderDlights();

		R_DrawParticles();

		R_DrawAlphaSurfaces();

		R_Flash();

		if (r_speeds.value != 0.0f) {
			VID.Printf(
				Defines.PRINT_ALL,
				"%4i wpoly %4i epoly %i tex %i lmaps\n",
				new Vargs(4).add(c_brush_polys).add(c_alias_polys).add(c_visible_textures).add(c_visible_lightmaps));
		}
	}

	void R_SetGL2D() {
		// set 2D virtual screen size
		gl.glViewport(0, 0, vid.width, vid.height);
		gl.glMatrixMode(GL.GL_PROJECTION);
		gl.glLoadIdentity();
		gl.glOrtho(0, vid.width, vid.height, 0, -99999, 99999);
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glLoadIdentity();
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glDisable(GL.GL_CULL_FACE);
		gl.glDisable(GL.GL_BLEND);
		gl.glEnable(GL.GL_ALPHA_TEST);
		gl.glColor4f(1, 1, 1, 1);
	}

	/*
	====================
	R_SetLightLevel
	
	====================
	*/
	void R_SetLightLevel() {
		float[] shadelight = { 0, 0, 0 };

		if ((r_newrefdef.rdflags & Defines.RDF_NOWORLDMODEL) != 0)
			return;

		// save off light value for server to look at (BIG HACK!)

		R_LightPoint(r_newrefdef.vieworg, shadelight);

		// pick the greatest component, which should be the same
		// as the mono value returned by software
		if (shadelight[0] > shadelight[1]) {
			if (shadelight[0] > shadelight[2])
				r_lightlevel.value = 150 * shadelight[0];
			else
				r_lightlevel.value = 150 * shadelight[2];
		}
		else {
			if (shadelight[1] > shadelight[2])
				r_lightlevel.value = 150 * shadelight[1];
			else
				r_lightlevel.value = 150 * shadelight[2];
		}
	}

	/*
	@@@@@@@@@@@@@@@@@@@@@
	R_RenderFrame
	
	@@@@@@@@@@@@@@@@@@@@@
	*/
	protected void R_RenderFrame(refdef_t fd) {
		R_RenderView(fd);
		R_SetLightLevel();
		R_SetGL2D();
	}

	protected void R_Register() {
		r_lefthand = Cvar.Get("hand", "0", Globals.CVAR_USERINFO | Globals.CVAR_ARCHIVE);
		r_norefresh = Cvar.Get("r_norefresh", "0", 0);
		r_fullbright = Cvar.Get("r_fullbright", "0", 0);
		r_drawentities = Cvar.Get("r_drawentities", "1", 0);
		r_drawworld = Cvar.Get("r_drawworld", "1", 0);
		r_novis = Cvar.Get("r_novis", "0", 0);
		r_nocull = Cvar.Get("r_nocull", "0", 0);
		r_lerpmodels = Cvar.Get("r_lerpmodels", "1", 0);
		r_speeds = Cvar.Get("r_speeds", "0", 0);

		r_lightlevel = Cvar.Get("r_lightlevel", "1", 0);

		gl_nosubimage = Cvar.Get("gl_nosubimage", "0", 0);
		gl_allow_software = Cvar.Get("gl_allow_software", "0", 0);

		gl_particle_min_size = Cvar.Get("gl_particle_min_size", "2", Globals.CVAR_ARCHIVE);
		gl_particle_max_size = Cvar.Get("gl_particle_max_size", "40", Globals.CVAR_ARCHIVE);
		gl_particle_size = Cvar.Get("gl_particle_size", "40", Globals.CVAR_ARCHIVE);
		gl_particle_att_a = Cvar.Get("gl_particle_att_a", "0.01", Globals.CVAR_ARCHIVE);
		gl_particle_att_b = Cvar.Get("gl_particle_att_b", "0.0", Globals.CVAR_ARCHIVE);
		gl_particle_att_c = Cvar.Get("gl_particle_att_c", "0.01", Globals.CVAR_ARCHIVE);

		gl_modulate = Cvar.Get("gl_modulate", "1.5", Globals.CVAR_ARCHIVE);
		gl_log = Cvar.Get("gl_log", "0", 0);
		gl_bitdepth = Cvar.Get("gl_bitdepth", "0", 0);
		gl_mode = Cvar.Get("gl_mode", "1", Globals.CVAR_ARCHIVE);
		gl_lightmap = Cvar.Get("gl_lightmap", "0", 0);
		gl_shadows = Cvar.Get("gl_shadows", "0", Globals.CVAR_ARCHIVE);
		gl_dynamic = Cvar.Get("gl_dynamic", "1", 0);
		gl_nobind = Cvar.Get("gl_nobind", "0", 0);
		gl_round_down = Cvar.Get("gl_round_down", "1", 0);
		gl_picmip = Cvar.Get("gl_picmip", "0", 0);
		gl_skymip = Cvar.Get("gl_skymip", "0", 0);
		gl_showtris = Cvar.Get("gl_showtris", "0", 0);
		gl_ztrick = Cvar.Get("gl_ztrick", "0", 0);
		gl_finish = Cvar.Get("gl_finish", "0", Globals.CVAR_ARCHIVE);
		gl_clear = Cvar.Get("gl_clear", "0", 0);
		gl_cull = Cvar.Get("gl_cull", "1", 0);
		gl_polyblend = Cvar.Get("gl_polyblend", "1", 0);
		gl_flashblend = Cvar.Get("gl_flashblend", "0", 0);
		gl_playermip = Cvar.Get("gl_playermip", "0", 0);
		gl_monolightmap = Cvar.Get("gl_monolightmap", "0", 0);
		gl_driver = Cvar.Get("gl_driver", "opengl32", Globals.CVAR_ARCHIVE);
		gl_texturemode = Cvar.Get("gl_texturemode", "GL_LINEAR_MIPMAP_NEAREST", Globals.CVAR_ARCHIVE);
		gl_texturealphamode = Cvar.Get("gl_texturealphamode", "default", Globals.CVAR_ARCHIVE);
		gl_texturesolidmode = Cvar.Get("gl_texturesolidmode", "default", Globals.CVAR_ARCHIVE);
		gl_lockpvs = Cvar.Get("gl_lockpvs", "0", 0);

		gl_vertex_arrays = Cvar.Get("gl_vertex_arrays", "0", Globals.CVAR_ARCHIVE);

		gl_ext_swapinterval = Cvar.Get("gl_ext_swapinterval", "1", Globals.CVAR_ARCHIVE);
		gl_ext_palettedtexture = Cvar.Get("gl_ext_palettedtexture", "0", Globals.CVAR_ARCHIVE);
		gl_ext_multitexture = Cvar.Get("gl_ext_multitexture", "1", Globals.CVAR_ARCHIVE);
		gl_ext_pointparameters = Cvar.Get("gl_ext_pointparameters", "1", Globals.CVAR_ARCHIVE);
		gl_ext_compiled_vertex_array = Cvar.Get("gl_ext_compiled_vertex_array", "1", Globals.CVAR_ARCHIVE);

		gl_drawbuffer = Cvar.Get("gl_drawbuffer", "GL_BACK", 0);
		gl_swapinterval = Cvar.Get("gl_swapinterval", "1", Globals.CVAR_ARCHIVE);

		gl_saturatelighting = Cvar.Get("gl_saturatelighting", "0", 0);

		gl_3dlabs_broken = Cvar.Get("gl_3dlabs_broken", "1", Globals.CVAR_ARCHIVE);

		vid_fullscreen = Cvar.Get("vid_fullscreen", "0", Globals.CVAR_ARCHIVE);
		vid_gamma = Cvar.Get("vid_gamma", "1.0", Globals.CVAR_ARCHIVE);
		vid_ref = Cvar.Get("vid_ref", "jogl", Globals.CVAR_ARCHIVE);

		Cmd.AddCommand("imagelist", new xcommand_t() {
			public void execute() {
				GL_ImageList_f();
			}
		});

		Cmd.AddCommand("screenshot", new xcommand_t() {
			public void execute() {
				GL_ScreenShot_f();
			}
		});
		Cmd.AddCommand("modellist", new xcommand_t() {
			public void execute() {
				Mod_Modellist_f();
			}
		});
		Cmd.AddCommand("gl_strings", new xcommand_t() {
			public void execute() {
				GL_Strings_f();
			}
		});
	}

	/*
	==================
	R_SetMode
	==================
	*/
	protected boolean R_SetMode() {

		int err; //  enum rserr_t
		boolean fullscreen;

//		if (vid_fullscreen.modified && !gl_config.allow_cds) {
//			VID.Printf(Defines.PRINT_ALL, "R_SetMode() - CDS not allowed with this driver\n");
//			Cvar.SetValue("vid_fullscreen", (vid_fullscreen.value > 0.0f) ? 0.0f : 1.0f);
//			vid_fullscreen.modified = false;
//		}

		fullscreen = (vid_fullscreen.value > 0.0f);

		vid_fullscreen.modified = false;
		gl_mode.modified = false;

		Dimension dim = new Dimension(vid.width, vid.height);

		if ((err = GLimp_SetMode(dim, (int) gl_mode.value, fullscreen)) == rserr_ok) {
			gl_state.prev_mode = (int) gl_mode.value;
		}
		else {
			if (err == rserr_invalid_fullscreen) {
				Cvar.SetValue("vid_fullscreen", 0);
				vid_fullscreen.modified = false;
				VID.Printf(Defines.PRINT_ALL, "ref_gl::R_SetMode() - fullscreen unavailable in this mode\n");
				if ((err = GLimp_SetMode(dim, (int) gl_mode.value, false)) == rserr_ok)
					return true;
			}
			else if (err == rserr_invalid_mode) {
				Cvar.SetValue("gl_mode", gl_state.prev_mode);
				gl_mode.modified = false;
				VID.Printf(Defines.PRINT_ALL, "ref_gl::R_SetMode() - invalid mode\n");
			}

			// try setting it back to something safe
			if ((err = GLimp_SetMode(dim, gl_state.prev_mode, false)) != rserr_ok) {
				VID.Printf(Defines.PRINT_ALL, "ref_gl::R_SetMode() - could not revert to safe mode\n");
				return false;
			}
		}
		return true;
	}

	/*
	===============
	R_Init
	===============
	*/
	float[] r_turbsin = new float[256];

	protected boolean R_Init(int vid_xpos, int vid_ypos) {

		assert(Warp.SIN.length == 256) : "warpsin table bug";

		// fill r_turbsin
		for (int j = 0; j < 256; j++) {
			r_turbsin[j] = Warp.SIN[j] * 0.5f;
		}

		VID.Printf(Defines.PRINT_ALL, "ref_gl version: " + REF_VERSION + '\n');

		Draw_GetPalette();

		R_Register();

		// set our "safe" modes
		gl_state.prev_mode = 3;

		// create the window and set up the context
		if (!R_SetMode()) {
			VID.Printf(Defines.PRINT_ALL, "ref_gl::R_Init() - could not R_SetMode()\n");
			return false;
		}
		return true;
	}

	protected boolean R_Init2() {
		VID.MenuInit();

		/*
		** get our various GL strings
		*/
		VID.Printf(Defines.PRINT_ALL, "JOGL_VERSION: " + Version.getVersion() + '\n');
		gl_config.vendor_string = gl.glGetString(GL.GL_VENDOR);
		VID.Printf(Defines.PRINT_ALL, "GL_VENDOR: " + gl_config.vendor_string + '\n');
		gl_config.renderer_string = gl.glGetString(GL.GL_RENDERER);
		VID.Printf(Defines.PRINT_ALL, "GL_RENDERER: " + gl_config.renderer_string + '\n');
		gl_config.version_string = gl.glGetString(GL.GL_VERSION);
		VID.Printf(Defines.PRINT_ALL, "GL_VERSION: " + gl_config.version_string + '\n');
		gl_config.extensions_string = gl.glGetString(GL.GL_EXTENSIONS);
		VID.Printf(Defines.PRINT_ALL, "GL_EXTENSIONS: " + gl_config.extensions_string + '\n');
		
		gl_config.parseOpenGLVersion();

		String renderer_buffer = gl_config.renderer_string.toLowerCase();
		String vendor_buffer = gl_config.vendor_string.toLowerCase();

		if (renderer_buffer.indexOf("voodoo") >= 0) {
			if (renderer_buffer.indexOf("rush") < 0)
				gl_config.renderer = GL_RENDERER_VOODOO;
			else
				gl_config.renderer = GL_RENDERER_VOODOO_RUSH;
		}
		else if (vendor_buffer.indexOf("sgi") >= 0)
			gl_config.renderer = GL_RENDERER_SGI;
		else if (renderer_buffer.indexOf("permedia") >= 0)
			gl_config.renderer = GL_RENDERER_PERMEDIA2;
		else if (renderer_buffer.indexOf("glint") >= 0)
			gl_config.renderer = GL_RENDERER_GLINT_MX;
		else if (renderer_buffer.indexOf("glzicd") >= 0)
			gl_config.renderer = GL_RENDERER_REALIZM;
		else if (renderer_buffer.indexOf("gdi") >= 0)
			gl_config.renderer = GL_RENDERER_MCD;
		else if (renderer_buffer.indexOf("pcx2") >= 0)
			gl_config.renderer = GL_RENDERER_PCX2;
		else if (renderer_buffer.indexOf("verite") >= 0)
			gl_config.renderer = GL_RENDERER_RENDITION;
		else
			gl_config.renderer = GL_RENDERER_OTHER;

		String monolightmap = gl_monolightmap.string.toUpperCase();
		if (monolightmap.length() < 2 || monolightmap.charAt(1) != 'F') {
			if (gl_config.renderer == GL_RENDERER_PERMEDIA2) {
				Cvar.Set("gl_monolightmap", "A");
				VID.Printf(Defines.PRINT_ALL, "...using gl_monolightmap 'a'\n");
			}
			else if ((gl_config.renderer & GL_RENDERER_POWERVR) != 0) {
				Cvar.Set("gl_monolightmap", "0");
			}
			else {
				Cvar.Set("gl_monolightmap", "0");
			}
		}

		// power vr can't have anything stay in the framebuffer, so
		// the screen needs to redraw the tiled background every frame
		if ((gl_config.renderer & GL_RENDERER_POWERVR) != 0) {
			Cvar.Set("scr_drawall", "1");
		}
		else {
			Cvar.Set("scr_drawall", "0");
		}

		// #ifdef __linux__
		Cvar.SetValue("gl_finish", 1);
		// #endif

		// MCD has buffering issues
		if (gl_config.renderer == GL_RENDERER_MCD) {
			Cvar.SetValue("gl_finish", 1);
		}

		if ((gl_config.renderer & GL_RENDERER_3DLABS) != 0) {
			if (gl_3dlabs_broken.value != 0.0f)
				gl_config.allow_cds = false;
			else
				gl_config.allow_cds = true;
		}
		else {
			gl_config.allow_cds = true;
		}

		if (gl_config.allow_cds)
			VID.Printf(Defines.PRINT_ALL, "...allowing CDS\n");
		else
			VID.Printf(Defines.PRINT_ALL, "...disabling CDS\n");

		/*
		** grab extensions
		*/
		if (gl_config.extensions_string.indexOf("GL_EXT_compiled_vertex_array") >= 0
			|| gl_config.extensions_string.indexOf("GL_SGI_compiled_vertex_array") >= 0) {
			VID.Printf(Defines.PRINT_ALL, "...enabling GL_EXT_compiled_vertex_array\n");
			//		 qglLockArraysEXT = ( void * ) qwglGetProcAddress( "glLockArraysEXT" );
			if (gl_ext_compiled_vertex_array.value != 0.0f)
				qglLockArraysEXT = true;
			else
				qglLockArraysEXT = false;
			//		 qglUnlockArraysEXT = ( void * ) qwglGetProcAddress( "glUnlockArraysEXT" );
			//qglUnlockArraysEXT = true;
		}
		else {
			VID.Printf(Defines.PRINT_ALL, "...GL_EXT_compiled_vertex_array not found\n");
		}

		if (gl_config.extensions_string.indexOf("WGL_EXT_swap_control") >= 0) {
			qwglSwapIntervalEXT = true;
			VID.Printf(Defines.PRINT_ALL, "...enabling WGL_EXT_swap_control\n");
		} else {
			qwglSwapIntervalEXT = false;
			VID.Printf(Defines.PRINT_ALL, "...WGL_EXT_swap_control not found\n");
		}

		if (gl_config.extensions_string.indexOf("GL_EXT_point_parameters") >= 0) {
			if (gl_ext_pointparameters.value != 0.0f) {
				//			 qglPointParameterfEXT = ( void (APIENTRY *)( GLenum, GLfloat ) ) qwglGetProcAddress( "glPointParameterfEXT" );
				qglPointParameterfEXT = true;
				//			 qglPointParameterfvEXT = ( void (APIENTRY *)( GLenum, const GLfloat * ) ) qwglGetProcAddress( "glPointParameterfvEXT" );
				VID.Printf(Defines.PRINT_ALL, "...using GL_EXT_point_parameters\n");
			}
			else {
				VID.Printf(Defines.PRINT_ALL, "...ignoring GL_EXT_point_parameters\n");
			}
		}
		else {
			VID.Printf(Defines.PRINT_ALL, "...GL_EXT_point_parameters not found\n");
		}

		// #ifdef __linux__
		//	 if ( strstr( gl_config.extensions_string, "3DFX_set_global_palette" ))
		//	 {
		//		 if ( gl_ext_palettedtexture->value )
		//		 {
		//			 VID.Printf( Defines.PRINT_ALL, "...using 3DFX_set_global_palette\n" );
		//			 qgl3DfxSetPaletteEXT = ( void ( APIENTRY * ) (GLuint *) )qwglGetProcAddress( "gl3DfxSetPaletteEXT" );
		////			 qglColorTableEXT = Fake_glColorTableEXT;
		//		 }
		//		 else
		//		 {
		//			 VID.Printf( Defines.PRINT_ALL, "...ignoring 3DFX_set_global_palette\n" );
		//		 }
		//	 }
		//	 else
		//	 {
		//		 VID.Printf( Defines.PRINT_ALL, "...3DFX_set_global_palette not found\n" );
		//	 }
		// #endif

		if (!qglColorTableEXT
			&& gl_config.extensions_string.indexOf("GL_EXT_paletted_texture") >= 0
			&& gl_config.extensions_string.indexOf("GL_EXT_shared_texture_palette") >= 0) {
			if (gl_ext_palettedtexture.value != 0.0f) {
				VID.Printf(Defines.PRINT_ALL, "...using GL_EXT_shared_texture_palette\n");
				qglColorTableEXT = false; // true; TODO jogl bug
			}
			else {
				VID.Printf(Defines.PRINT_ALL, "...ignoring GL_EXT_shared_texture_palette\n");
				qglColorTableEXT = false;
			}
		}
		else {
			VID.Printf(Defines.PRINT_ALL, "...GL_EXT_shared_texture_palette not found\n");
		}

		if (gl_config.extensions_string.indexOf("GL_ARB_multitexture") >= 0) {
			if (gl_ext_multitexture.value != 0.0f) {
				VID.Printf(Defines.PRINT_ALL, "...using GL_ARB_multitexture\n");
				//			 qglMTexCoord2fSGIS = ( void * ) qwglGetProcAddress( "glMultiTexCoord2fARB" );
				//			 qglActiveTextureARB = ( void * ) qwglGetProcAddress( "glActiveTextureARB" );
				//			 qglClientActiveTextureARB = ( void * ) qwglGetProcAddress( "glClientActiveTextureARB" );
				qglActiveTextureARB = true;
				qglMTexCoord2fSGIS = true;
				GL_TEXTURE0 = GL.GL_TEXTURE0_ARB;
				GL_TEXTURE1 = GL.GL_TEXTURE1_ARB;
				Cvar.SetValue("r_fullbright", 1);
			}
			else {
				VID.Printf(Defines.PRINT_ALL, "...ignoring GL_ARB_multitexture\n");
				Cvar.SetValue("r_fullbright", 0);
			}
		}
		else {
			VID.Printf(Defines.PRINT_ALL, "...GL_ARB_multitexture not found\n");
			Cvar.SetValue("r_fullbright", 0);
		}

		if (gl_config.extensions_string.indexOf("GL_SGIS_multitexture") >= 0) {
			if (qglActiveTextureARB) {
				VID.Printf(Defines.PRINT_ALL, "...GL_SGIS_multitexture deprecated in favor of ARB_multitexture\n");
				Cvar.SetValue("r_fullbright", 1);
			}	else if (gl_ext_multitexture.value != 0.0f) {
				VID.Printf(Defines.PRINT_ALL, "...using GL_SGIS_multitexture\n");
				//			 qglMTexCoord2fSGIS = ( void * ) qwglGetProcAddress( "glMTexCoord2fSGIS" );
				//			 qglSelectTextureSGIS = ( void * ) qwglGetProcAddress( "glSelectTextureSGIS" );
				qglSelectTextureSGIS = true;
				qglMTexCoord2fSGIS = true;
				Cvar.SetValue("r_fullbright", 1);
				//			 //GL_TEXTURE0 = GL.GL_TEXTURE0_SGIS;
				//			 //GL_TEXTURE1 = GL.GL_TEXTURE1_SGIS;
			} else {
				VID.Printf(Defines.PRINT_ALL, "...ignoring GL_SGIS_multitexture\n");
				Cvar.SetValue("r_fullbright", 0);
			}
		}
		else {
			VID.Printf(Defines.PRINT_ALL, "...GL_SGIS_multitexture not found\n");
			if (!qglActiveTextureARB)
				Cvar.SetValue("r_fullbright", 0);
		}

		GL_SetDefaultState();

		GL_InitImages();
		Mod_Init();
		R_InitParticleTexture();
		Draw_InitLocal();

		int err = gl.glGetError();
		if (err != GL.GL_NO_ERROR)
			VID.Printf(
				Defines.PRINT_ALL,
				"glGetError() = 0x%x\n\t%s\n",
				new Vargs(2).add(err).add("" + gl.glGetString(err)));

		return true;
	}

	/*
	===============
	R_Shutdown
	===============
	*/
	protected void R_Shutdown() {
		Cmd.RemoveCommand("modellist");
		Cmd.RemoveCommand("screenshot");
		Cmd.RemoveCommand("imagelist");
		Cmd.RemoveCommand("gl_strings");

		Mod_FreeAll();

		GL_ShutdownImages();

		/*
		 * shut down OS specific OpenGL stuff like contexts, etc.
		 */
		GLimp_Shutdown();
	}

	/*
	@@@@@@@@@@@@@@@@@@@@@
	R_BeginFrame
	@@@@@@@@@@@@@@@@@@@@@
	*/
	protected void R_BeginFrame(float camera_separation) {

		gl_state.camera_separation = camera_separation;

		/*
		** change modes if necessary
		*/
		if (gl_mode.modified || vid_fullscreen.modified) {
			// FIXME: only restart if CDS is required
			cvar_t ref;

			ref = Cvar.Get("vid_ref", "jogl", 0);
			ref.modified = true;
		}

		if (gl_log.modified) {
			GLimp_EnableLogging((gl_log.value != 0.0f));
			gl_log.modified = false;
		}

		if (gl_log.value != 0.0f) {
			GLimp_LogNewFrame();
		}

		/*
		** update 3Dfx gamma -- it is expected that a user will do a vid_restart
		** after tweaking this value
		*/
		if (vid_gamma.modified) {
			vid_gamma.modified = false;

			if ((gl_config.renderer & GL_RENDERER_VOODOO) != 0) {
				// wird erstmal nicht gebraucht

				/* 
				char envbuffer[1024];
				float g;
				
				g = 2.00 * ( 0.8 - ( vid_gamma->value - 0.5 ) ) + 1.0F;
				Com_sprintf( envbuffer, sizeof(envbuffer), "SSTV2_GAMMA=%f", g );
				putenv( envbuffer );
				Com_sprintf( envbuffer, sizeof(envbuffer), "SST_GAMMA=%f", g );
				putenv( envbuffer );
				*/
				VID.Printf(Defines.PRINT_DEVELOPER, "gamma anpassung fuer VOODOO nicht gesetzt");
			}
		}

		GLimp_BeginFrame(camera_separation);

		/*
		** go into 2D mode
		*/
		gl.glViewport(0, 0, vid.width, vid.height);
		gl.glMatrixMode(GL.GL_PROJECTION);
		gl.glLoadIdentity();
		gl.glOrtho(0, vid.width, vid.height, 0, -99999, 99999);
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glLoadIdentity();
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glDisable(GL.GL_CULL_FACE);
		gl.glDisable(GL.GL_BLEND);
		gl.glEnable(GL.GL_ALPHA_TEST);
		gl.glColor4f(1, 1, 1, 1);

		/*
		** draw buffer stuff
		*/
		if (gl_drawbuffer.modified) {
			gl_drawbuffer.modified = false;

			if (gl_state.camera_separation == 0 || !gl_state.stereo_enabled) {
				if (gl_drawbuffer.string.equalsIgnoreCase("GL_FRONT"))
					gl.glDrawBuffer(GL.GL_FRONT);
				else
					gl.glDrawBuffer(GL.GL_BACK);
			}
		}

		/*
		** texturemode stuff
		*/
		if (gl_texturemode.modified) {
			GL_TextureMode(gl_texturemode.string);
			gl_texturemode.modified = false;
		}

		if (gl_texturealphamode.modified) {
			GL_TextureAlphaMode(gl_texturealphamode.string);
			gl_texturealphamode.modified = false;
		}

		if (gl_texturesolidmode.modified) {
			GL_TextureSolidMode(gl_texturesolidmode.string);
			gl_texturesolidmode.modified = false;
		}

		/*
		** swapinterval stuff
		*/
		GL_UpdateSwapInterval();

		//
		// clear screen if desired
		//
		R_Clear();
	}

	int[] r_rawpalette = new int[256];

	/*
	=============
	R_SetPalette
	=============
	*/
	protected void R_SetPalette(byte[] palette) {
		// 256 RGB values (768 bytes)
		// or null
		int i;
		int color = 0;

		if (palette != null) {
			int j =0;
			for (i = 0; i < 256; i++) {
				color = (palette[j++] & 0xFF) << 0;
				color |= (palette[j++] & 0xFF) << 8;
				color |= (palette[j++] & 0xFF) << 16;
				color |= 0xFF000000;
				r_rawpalette[i] = color;
			}
		}
		else {
			for (i = 0; i < 256; i++) {
				r_rawpalette[i] = d_8to24table[i] | 0xff000000;
			}
		}
		GL_SetTexturePalette(r_rawpalette);

		gl.glClearColor(0, 0, 0, 0);
		gl.glClear(GL.GL_COLOR_BUFFER_BIT);
		gl.glClearColor(1f, 0f, 0.5f, 0.5f);
	}

	static final int NUM_BEAM_SEGS = 6;
	float[][] start_points = new float[NUM_BEAM_SEGS][3];
	// array of vec3_t
	float[][] end_points = new float[NUM_BEAM_SEGS][3]; // array of vec3_t

	/*
	** R_DrawBeam
	*/
	void R_DrawBeam(entity_t e) {

		int i;
		float r, g, b;

		float[] perpvec = { 0, 0, 0 }; // vec3_t
		float[] direction = { 0, 0, 0 }; // vec3_t
		float[] normalized_direction = { 0, 0, 0 }; // vec3_t

		float[] oldorigin = { 0, 0, 0 }; // vec3_t
		float[] origin = { 0, 0, 0 }; // vec3_t

		oldorigin[0] = e.oldorigin[0];
		oldorigin[1] = e.oldorigin[1];
		oldorigin[2] = e.oldorigin[2];

		origin[0] = e.origin[0];
		origin[1] = e.origin[1];
		origin[2] = e.origin[2];

		normalized_direction[0] = direction[0] = oldorigin[0] - origin[0];
		normalized_direction[1] = direction[1] = oldorigin[1] - origin[1];
		normalized_direction[2] = direction[2] = oldorigin[2] - origin[2];

		if (Math3D.VectorNormalize(normalized_direction) == 0.0f)
			return;

		Math3D.PerpendicularVector(perpvec, normalized_direction);
		Math3D.VectorScale(perpvec, e.frame / 2, perpvec);

		for (i = 0; i < 6; i++) {
			Math3D.RotatePointAroundVector(
				start_points[i],
				normalized_direction,
				perpvec,
				(360.0f / NUM_BEAM_SEGS) * i);

			Math3D.VectorAdd(start_points[i], origin, start_points[i]);
			Math3D.VectorAdd(start_points[i], direction, end_points[i]);
		}

		gl.glDisable(GL.GL_TEXTURE_2D);
		gl.glEnable(GL.GL_BLEND);
		gl.glDepthMask(false);

		r = (d_8to24table[e.skinnum & 0xFF]) & 0xFF;
		g = (d_8to24table[e.skinnum & 0xFF] >> 8) & 0xFF;
		b = (d_8to24table[e.skinnum & 0xFF] >> 16) & 0xFF;

		r *= 1 / 255.0f;
		g *= 1 / 255.0f;
		b *= 1 / 255.0f;

		gl.glColor4f(r, g, b, e.alpha);

		gl.glBegin(GL.GL_TRIANGLE_STRIP);
		
		float[] v;
		
		for (i = 0; i < NUM_BEAM_SEGS; i++) {
			v = start_points[i];
			gl.glVertex3f(v[0], v[1], v[2]);
			v = end_points[i];
			gl.glVertex3f(v[0], v[1], v[2]);
			v = start_points[(i + 1) % NUM_BEAM_SEGS];
			gl.glVertex3f(v[0], v[1], v[2]);
			v = end_points[(i + 1) % NUM_BEAM_SEGS];
			gl.glVertex3f(v[0], v[1], v[2]);
		}
		gl.glEnd();

		gl.glEnable(GL.GL_TEXTURE_2D);
		gl.glDisable(GL.GL_BLEND);
		gl.glDepthMask(true);
	}

}
