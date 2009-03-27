/*
 * Copyright (C) 1997-2001 Id Software, Inc.
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.
 * 
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place - Suite 330, Boston, MA 02111-1307, USA.
 *  
 */

// Created on 13.11.2003 by RST.
// $Id: M_Parasite.java,v 1.4 2005/11/20 22:18:33 salomo Exp $
package jake2.game.monsters;

import jake2.Defines;
import jake2.Globals;
import jake2.game.*;
import jake2.game.EntDieAdapter;
import jake2.game.EntInteractAdapter;
import jake2.game.EntPainAdapter;
import jake2.game.EntThinkAdapter;
import jake2.game.GameAI;
import jake2.game.GameBase;
import jake2.game.GameUtil;
import jake2.game.edict_t;
import jake2.game.mframe_t;
import jake2.game.mmove_t;
import jake2.game.trace_t;
import jake2.util.Lib;
import jake2.util.Math3D;

public class M_Parasite {

    // This file generated by ModelGen - Do NOT Modify

    public final static int FRAME_break01 = 0;

    public final static int FRAME_break02 = 1;

    public final static int FRAME_break03 = 2;

    public final static int FRAME_break04 = 3;

    public final static int FRAME_break05 = 4;

    public final static int FRAME_break06 = 5;

    public final static int FRAME_break07 = 6;

    public final static int FRAME_break08 = 7;

    public final static int FRAME_break09 = 8;

    public final static int FRAME_break10 = 9;

    public final static int FRAME_break11 = 10;

    public final static int FRAME_break12 = 11;

    public final static int FRAME_break13 = 12;

    public final static int FRAME_break14 = 13;

    public final static int FRAME_break15 = 14;

    public final static int FRAME_break16 = 15;

    public final static int FRAME_break17 = 16;

    public final static int FRAME_break18 = 17;

    public final static int FRAME_break19 = 18;

    public final static int FRAME_break20 = 19;

    public final static int FRAME_break21 = 20;

    public final static int FRAME_break22 = 21;

    public final static int FRAME_break23 = 22;

    public final static int FRAME_break24 = 23;

    public final static int FRAME_break25 = 24;

    public final static int FRAME_break26 = 25;

    public final static int FRAME_break27 = 26;

    public final static int FRAME_break28 = 27;

    public final static int FRAME_break29 = 28;

    public final static int FRAME_break30 = 29;

    public final static int FRAME_break31 = 30;

    public final static int FRAME_break32 = 31;

    public final static int FRAME_death101 = 32;

    public final static int FRAME_death102 = 33;

    public final static int FRAME_death103 = 34;

    public final static int FRAME_death104 = 35;

    public final static int FRAME_death105 = 36;

    public final static int FRAME_death106 = 37;

    public final static int FRAME_death107 = 38;

    public final static int FRAME_drain01 = 39;

    public final static int FRAME_drain02 = 40;

    public final static int FRAME_drain03 = 41;

    public final static int FRAME_drain04 = 42;

    public final static int FRAME_drain05 = 43;

    public final static int FRAME_drain06 = 44;

    public final static int FRAME_drain07 = 45;

    public final static int FRAME_drain08 = 46;

    public final static int FRAME_drain09 = 47;

    public final static int FRAME_drain10 = 48;

    public final static int FRAME_drain11 = 49;

    public final static int FRAME_drain12 = 50;

    public final static int FRAME_drain13 = 51;

    public final static int FRAME_drain14 = 52;

    public final static int FRAME_drain15 = 53;

    public final static int FRAME_drain16 = 54;

    public final static int FRAME_drain17 = 55;

    public final static int FRAME_drain18 = 56;

    public final static int FRAME_pain101 = 57;

    public final static int FRAME_pain102 = 58;

    public final static int FRAME_pain103 = 59;

    public final static int FRAME_pain104 = 60;

    public final static int FRAME_pain105 = 61;

    public final static int FRAME_pain106 = 62;

    public final static int FRAME_pain107 = 63;

    public final static int FRAME_pain108 = 64;

    public final static int FRAME_pain109 = 65;

    public final static int FRAME_pain110 = 66;

    public final static int FRAME_pain111 = 67;

    public final static int FRAME_run01 = 68;

    public final static int FRAME_run02 = 69;

    public final static int FRAME_run03 = 70;

    public final static int FRAME_run04 = 71;

    public final static int FRAME_run05 = 72;

    public final static int FRAME_run06 = 73;

    public final static int FRAME_run07 = 74;

    public final static int FRAME_run08 = 75;

    public final static int FRAME_run09 = 76;

    public final static int FRAME_run10 = 77;

    public final static int FRAME_run11 = 78;

    public final static int FRAME_run12 = 79;

    public final static int FRAME_run13 = 80;

    public final static int FRAME_run14 = 81;

    public final static int FRAME_run15 = 82;

    public final static int FRAME_stand01 = 83;

    public final static int FRAME_stand02 = 84;

    public final static int FRAME_stand03 = 85;

    public final static int FRAME_stand04 = 86;

    public final static int FRAME_stand05 = 87;

    public final static int FRAME_stand06 = 88;

    public final static int FRAME_stand07 = 89;

    public final static int FRAME_stand08 = 90;

    public final static int FRAME_stand09 = 91;

    public final static int FRAME_stand10 = 92;

    public final static int FRAME_stand11 = 93;

    public final static int FRAME_stand12 = 94;

    public final static int FRAME_stand13 = 95;

    public final static int FRAME_stand14 = 96;

    public final static int FRAME_stand15 = 97;

    public final static int FRAME_stand16 = 98;

    public final static int FRAME_stand17 = 99;

    public final static int FRAME_stand18 = 100;

    public final static int FRAME_stand19 = 101;

    public final static int FRAME_stand20 = 102;

    public final static int FRAME_stand21 = 103;

    public final static int FRAME_stand22 = 104;

    public final static int FRAME_stand23 = 105;

    public final static int FRAME_stand24 = 106;

    public final static int FRAME_stand25 = 107;

    public final static int FRAME_stand26 = 108;

    public final static int FRAME_stand27 = 109;

    public final static int FRAME_stand28 = 110;

    public final static int FRAME_stand29 = 111;

    public final static int FRAME_stand30 = 112;

    public final static int FRAME_stand31 = 113;

    public final static int FRAME_stand32 = 114;

    public final static int FRAME_stand33 = 115;

    public final static int FRAME_stand34 = 116;

    public final static int FRAME_stand35 = 117;

    public final static float MODEL_SCALE = 1.000000f;

    static int sound_pain1;

    static int sound_pain2;

    static int sound_die;

    static int sound_launch;

    static int sound_impact;

    static int sound_suck;

    static int sound_reelin;

    static int sound_sight;

    static int sound_tap;

    static int sound_scratch;

    static int sound_search;

    static EntThinkAdapter parasite_launch = new EntThinkAdapter() {
    	public String getID(){ return "parasite_launch"; }
        public boolean think(edict_t self) {

            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_launch, 1,
                    Defines.ATTN_NORM, 0);
            return true;
        }
    };

    static EntThinkAdapter parasite_reel_in = new EntThinkAdapter() {
    	public String getID(){ return "parasite_reel_in"; }
        public boolean think(edict_t self) {
            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_reelin, 1,
                    Defines.ATTN_NORM, 0);
            return true;
        }
    };

    static EntInteractAdapter parasite_sight = new EntInteractAdapter() {
    	public String getID(){ return "parasite_sight"; }
        public boolean interact(edict_t self, edict_t other) {
            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_sight, 1,
                    Defines.ATTN_NORM, 0);
            return true;
        }
    };

    static EntThinkAdapter parasite_tap = new EntThinkAdapter() {
    	public String getID(){ return "parasite_tap"; }
        public boolean think(edict_t self) {
            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_tap, 1,
                    Defines.ATTN_IDLE, 0);
            return true;
        }
    };

    static EntThinkAdapter parasite_scratch = new EntThinkAdapter() {
    	public String getID(){ return "parasite_scratch"; }
        public boolean think(edict_t self) {
            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_scratch, 1,
                    Defines.ATTN_IDLE, 0);
            return true;
        }
    };

    static EntThinkAdapter parasite_search = new EntThinkAdapter() {
    	public String getID(){ return "parasite_search"; }
        public boolean think(edict_t self) {
            GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_search, 1,
                    Defines.ATTN_IDLE, 0);
            return true;
        }
    };

    static EntThinkAdapter parasite_start_walk = new EntThinkAdapter() {
    	public String getID(){ return "parasite_start_walk"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_start_walk;
            return true;
        }
    };

    static EntThinkAdapter parasite_walk = new EntThinkAdapter() {
    	public String getID(){ return "parasite_walk"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_walk;
            return true;
        }
    };

    static EntThinkAdapter parasite_stand = new EntThinkAdapter() {
    	public String getID(){ return "parasite_stand"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_stand;
            return true;
        }
    };

    static EntThinkAdapter parasite_end_fidget = new EntThinkAdapter() {
    	public String getID(){ return "parasite_end_fidget"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_end_fidget;
            return true;
        }
    };

    static EntThinkAdapter parasite_do_fidget = new EntThinkAdapter() {
    	public String getID(){ return "parasite_do_fidget"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_fidget;
            return true;
        }
    };

    static EntThinkAdapter parasite_refidget = new EntThinkAdapter() {
    	public String getID(){ return "parasite_refidget"; }
        public boolean think(edict_t self) {
            if (Lib.random() <= 0.8)
                self.monsterinfo.currentmove = parasite_move_fidget;
            else
                self.monsterinfo.currentmove = parasite_move_end_fidget;
            return true;
        }
    };

    static EntThinkAdapter parasite_idle = new EntThinkAdapter() {
    	public String getID(){ return "parasite_idle"; }
        public boolean think(edict_t self) {
            self.monsterinfo.currentmove = parasite_move_start_fidget;
            return true;
        }
    };

    static EntThinkAdapter parasite_start_run = new EntThinkAdapter() {
    	public String getID(){ return "parasite_start_run"; }
        public boolean think(edict_t self) {
            if ((self.monsterinfo.aiflags & Defines.AI_STAND_GROUND) != 0)
                self.monsterinfo.currentmove = parasite_move_stand;
            else
                self.monsterinfo.currentmove = parasite_move_start_run;
            return true;
        }
    };

    static EntThinkAdapter parasite_run = new EntThinkAdapter() {
    	public String getID(){ return "parasite_run"; }
        public boolean think(edict_t self) {
            if ((self.monsterinfo.aiflags & Defines.AI_STAND_GROUND) != 0)
                self.monsterinfo.currentmove = parasite_move_stand;
            else
                self.monsterinfo.currentmove = parasite_move_run;
            return true;
        }
    };

    static mframe_t parasite_frames_start_fidget[] = new mframe_t[] {
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null) };

    static mmove_t parasite_move_start_fidget = new mmove_t(FRAME_stand18,
            FRAME_stand21, parasite_frames_start_fidget, parasite_do_fidget);

    static mframe_t parasite_frames_fidget[] = new mframe_t[] {
            new mframe_t(GameAI.ai_stand, 0, parasite_scratch),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_scratch),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null) };

    static mmove_t parasite_move_fidget = new mmove_t(FRAME_stand22,
            FRAME_stand27, parasite_frames_fidget, parasite_refidget);

    static mframe_t parasite_frames_end_fidget[] = new mframe_t[] {
            new mframe_t(GameAI.ai_stand, 0, parasite_scratch),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null) };

    static mmove_t parasite_move_end_fidget = new mmove_t(FRAME_stand28,
            FRAME_stand35, parasite_frames_end_fidget, parasite_stand);

    static mframe_t parasite_frames_stand[] = new mframe_t[] {
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap),
            new mframe_t(GameAI.ai_stand, 0, null),
            new mframe_t(GameAI.ai_stand, 0, parasite_tap) };

    static mmove_t parasite_move_stand = new mmove_t(FRAME_stand01,
            FRAME_stand17, parasite_frames_stand, parasite_stand);

    static mframe_t parasite_frames_run[] = new mframe_t[] {
            new mframe_t(GameAI.ai_run, 30, null),
            new mframe_t(GameAI.ai_run, 30, null),
            new mframe_t(GameAI.ai_run, 22, null),
            new mframe_t(GameAI.ai_run, 19, null),
            new mframe_t(GameAI.ai_run, 24, null),
            new mframe_t(GameAI.ai_run, 28, null),
            new mframe_t(GameAI.ai_run, 25, null) };

    static mmove_t parasite_move_run = new mmove_t(FRAME_run03, FRAME_run09,
            parasite_frames_run, null);

    static mframe_t parasite_frames_start_run[] = new mframe_t[] {
            new mframe_t(GameAI.ai_run, 0, null),
            new mframe_t(GameAI.ai_run, 30, null), };

    static mmove_t parasite_move_start_run = new mmove_t(FRAME_run01,
            FRAME_run02, parasite_frames_start_run, parasite_run);

    static mframe_t parasite_frames_stop_run[] = new mframe_t[] {
            new mframe_t(GameAI.ai_run, 20, null),
            new mframe_t(GameAI.ai_run, 20, null),
            new mframe_t(GameAI.ai_run, 12, null),
            new mframe_t(GameAI.ai_run, 10, null),
            new mframe_t(GameAI.ai_run, 0, null),
            new mframe_t(GameAI.ai_run, 0, null) };

    static mmove_t parasite_move_stop_run = new mmove_t(FRAME_run10,
            FRAME_run15, parasite_frames_stop_run, null);

    static mframe_t parasite_frames_walk[] = new mframe_t[] {
            new mframe_t(GameAI.ai_walk, 30, null),
            new mframe_t(GameAI.ai_walk, 30, null),
            new mframe_t(GameAI.ai_walk, 22, null),
            new mframe_t(GameAI.ai_walk, 19, null),
            new mframe_t(GameAI.ai_walk, 24, null),
            new mframe_t(GameAI.ai_walk, 28, null),
            new mframe_t(GameAI.ai_walk, 25, null) };

    static mmove_t parasite_move_walk = new mmove_t(FRAME_run03, FRAME_run09,
            parasite_frames_walk, parasite_walk);

    static mframe_t parasite_frames_start_walk[] = new mframe_t[] {
            new mframe_t(GameAI.ai_walk, 0, null),
            new mframe_t(GameAI.ai_walk, 30, parasite_walk) };

    static mmove_t parasite_move_start_walk = new mmove_t(FRAME_run01,
            FRAME_run02, parasite_frames_start_walk, null);

    static mframe_t parasite_frames_stop_walk[] = new mframe_t[] {
            new mframe_t(GameAI.ai_walk, 20, null),
            new mframe_t(GameAI.ai_walk, 20, null),
            new mframe_t(GameAI.ai_walk, 12, null),
            new mframe_t(GameAI.ai_walk, 10, null),
            new mframe_t(GameAI.ai_walk, 0, null),
            new mframe_t(GameAI.ai_walk, 0, null) };

    static mmove_t parasite_move_stop_walk = new mmove_t(FRAME_run10,
            FRAME_run15, parasite_frames_stop_walk, null);

    static mframe_t parasite_frames_pain1[] = new mframe_t[] {
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 6, null),
            new mframe_t(GameAI.ai_move, 16, null),
            new mframe_t(GameAI.ai_move, -6, null),
            new mframe_t(GameAI.ai_move, -7, null),
            new mframe_t(GameAI.ai_move, 0, null) };

    static mmove_t parasite_move_pain1 = new mmove_t(FRAME_pain101,
            FRAME_pain111, parasite_frames_pain1, parasite_start_run);

    static EntPainAdapter parasite_pain = new EntPainAdapter() {
    	public String getID(){ return "parasite_pain"; }
        public void pain(edict_t self, edict_t other, float kick, int damage) {
            if (self.health < (self.max_health / 2))
                self.s.skinnum = 1;

            if (GameBase.level.time < self.pain_debounce_time)
                return;

            self.pain_debounce_time = GameBase.level.time + 3;

            if (GameBase.skill.value == 3)
                return; // no pain anims in nightmare

            if (Lib.random() < 0.5)
                GameBase.gi.sound(self, Defines.CHAN_VOICE, sound_pain1, 1,
                        Defines.ATTN_NORM, 0);
            else
                GameBase.gi.sound(self, Defines.CHAN_VOICE, sound_pain2, 1,
                        Defines.ATTN_NORM, 0);

            self.monsterinfo.currentmove = parasite_move_pain1;
        }
    };

    static EntThinkAdapter parasite_drain_attack = new EntThinkAdapter() {
    	public String getID(){ return "parasite_drain_attack"; }
        public boolean think(edict_t self) {
            float[] offset = { 0, 0, 0 }, start = { 0, 0, 0 }, f = { 0, 0, 0 }, r = {
                    0, 0, 0 }, end = { 0, 0, 0 }, dir = { 0, 0, 0 };
            trace_t tr;
            int damage;

            Math3D.AngleVectors(self.s.angles, f, r, null);
            Math3D.VectorSet(offset, 24, 0, 6);
            Math3D.G_ProjectSource(self.s.origin, offset, f, r, start);

            Math3D.VectorCopy(self.enemy.s.origin, end);
            if (!parasite_drain_attack_ok(start, end)) {
                end[2] = self.enemy.s.origin[2] + self.enemy.maxs[2] - 8;
                if (!parasite_drain_attack_ok(start, end)) {
                    end[2] = self.enemy.s.origin[2] + self.enemy.mins[2] + 8;
                    if (!parasite_drain_attack_ok(start, end))
                        return true;
                }
            }
            Math3D.VectorCopy(self.enemy.s.origin, end);

            tr = GameBase.gi.trace(start, null, null, end, self,
                    Defines.MASK_SHOT);
            if (tr.ent != self.enemy)
                return true;

            if (self.s.frame == FRAME_drain03) {
                damage = 5;
                GameBase.gi.sound(self.enemy, Defines.CHAN_AUTO, sound_impact,
                        1, Defines.ATTN_NORM, 0);
            } else {
                if (self.s.frame == FRAME_drain04)
                    GameBase.gi.sound(self, Defines.CHAN_WEAPON, sound_suck, 1,
                            Defines.ATTN_NORM, 0);
                damage = 2;
            }

            GameBase.gi.WriteByte(Defines.svc_temp_entity);
            GameBase.gi.WriteByte(Defines.TE_PARASITE_ATTACK);
            //gi.WriteShort(self - g_edicts);
            GameBase.gi.WriteShort(self.index);
            GameBase.gi.WritePosition(start);
            GameBase.gi.WritePosition(end);
            GameBase.gi.multicast(self.s.origin, Defines.MULTICAST_PVS);

            Math3D.VectorSubtract(start, end, dir);
            GameCombat.T_Damage(self.enemy, self, self, dir, self.enemy.s.origin,
                    Globals.vec3_origin, damage, 0,
                    Defines.DAMAGE_NO_KNOCKBACK, Defines.MOD_UNKNOWN);
            return true;
        }
    };

    static mframe_t parasite_frames_drain[] = new mframe_t[] {
            new mframe_t(GameAI.ai_charge, 0, parasite_launch),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, 15, parasite_drain_attack),
            // Target hits)
            new mframe_t(GameAI.ai_charge, 0, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, 0, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, 0, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, 0, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, -2, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, -2, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, -3, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, -2, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, 0, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, -1, parasite_drain_attack), // drain)
            new mframe_t(GameAI.ai_charge, 0, parasite_reel_in), // let go)
            new mframe_t(GameAI.ai_charge, -2, null),
            new mframe_t(GameAI.ai_charge, -2, null),
            new mframe_t(GameAI.ai_charge, -3, null),
            new mframe_t(GameAI.ai_charge, 0, null) };

    static mmove_t parasite_move_drain = new mmove_t(FRAME_drain01,
            FRAME_drain18, parasite_frames_drain, parasite_start_run);

    static mframe_t parasite_frames_break[] = new mframe_t[] {
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, -3, null),
            new mframe_t(GameAI.ai_charge, 1, null),
            new mframe_t(GameAI.ai_charge, 2, null),
            new mframe_t(GameAI.ai_charge, -3, null),
            new mframe_t(GameAI.ai_charge, 1, null),
            new mframe_t(GameAI.ai_charge, 1, null),
            new mframe_t(GameAI.ai_charge, 3, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, -18, null),
            new mframe_t(GameAI.ai_charge, 3, null),
            new mframe_t(GameAI.ai_charge, 9, null),
            new mframe_t(GameAI.ai_charge, 6, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, -18, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, 8, null),
            new mframe_t(GameAI.ai_charge, 9, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, -18, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            new mframe_t(GameAI.ai_charge, 0, null),
            /* airborne */
            new mframe_t(GameAI.ai_charge, 0, null), /* slides */
            new mframe_t(GameAI.ai_charge, 0, null), /* slides */
            new mframe_t(GameAI.ai_charge, 0, null), /* slides */
            new mframe_t(GameAI.ai_charge, 0, null), /* slides */
            new mframe_t(GameAI.ai_charge, 4, null),
            new mframe_t(GameAI.ai_charge, 11, null),
            new mframe_t(GameAI.ai_charge, -2, null),
            new mframe_t(GameAI.ai_charge, -5, null),
            new mframe_t(GameAI.ai_charge, 1, null) };

    static mmove_t parasite_move_break = new mmove_t(FRAME_break01,
            FRAME_break32, parasite_frames_break, parasite_start_run);

    /*
     * === Break Stuff Ends ===
     */

    static EntThinkAdapter parasite_attack = new EntThinkAdapter() {
    	public String getID(){ return "parasite_attack"; }
        public boolean think(edict_t self) {
            //	if (random() <= 0.2)
            //		self.monsterinfo.currentmove = &parasite_move_break;
            //	else
            self.monsterinfo.currentmove = parasite_move_drain;
            return true;
        }
    };

    /*
     * === Death Stuff Starts ===
     */

    static EntThinkAdapter parasite_dead = new EntThinkAdapter() {
    	public String getID(){ return "parasite_dead"; }
        public boolean think(edict_t self) {
            Math3D.VectorSet(self.mins, -16, -16, -24);
            Math3D.VectorSet(self.maxs, 16, 16, -8);
            self.movetype = Defines.MOVETYPE_TOSS;
            self.svflags |= Defines.SVF_DEADMONSTER;
            self.nextthink = 0;
            GameBase.gi.linkentity(self);
            return true;
        }
    };

    static mframe_t parasite_frames_death[] = new mframe_t[] {
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null),
            new mframe_t(GameAI.ai_move, 0, null) };

    static mmove_t parasite_move_death = new mmove_t(FRAME_death101,
            FRAME_death107, parasite_frames_death, parasite_dead);

    static EntDieAdapter parasite_die = new EntDieAdapter() {
    	public String getID(){ return "parasite_die"; }
        public void die(edict_t self, edict_t inflictor, edict_t attacker,
                int damage, float[] point) {
            int n;

            // check for gib
            if (self.health <= self.gib_health) {
                GameBase.gi
                        .sound(self, Defines.CHAN_VOICE, GameBase.gi
                                .soundindex("misc/udeath.wav"), 1,
                                Defines.ATTN_NORM, 0);
                for (n = 0; n < 2; n++)
                    GameMisc.ThrowGib(self, "models/objects/gibs/bone/tris.md2",
                            damage, Defines.GIB_ORGANIC);
                for (n = 0; n < 4; n++)
                    GameMisc.ThrowGib(self,
                            "models/objects/gibs/sm_meat/tris.md2", damage,
                            Defines.GIB_ORGANIC);
                GameMisc.ThrowHead(self, "models/objects/gibs/head2/tris.md2",
                        damage, Defines.GIB_ORGANIC);
                self.deadflag = Defines.DEAD_DEAD;
                return;
            }

            if (self.deadflag == Defines.DEAD_DEAD)
                return;

            // regular death
            GameBase.gi.sound(self, Defines.CHAN_VOICE, sound_die, 1,
                    Defines.ATTN_NORM, 0);
            self.deadflag = Defines.DEAD_DEAD;
            self.takedamage = Defines.DAMAGE_YES;
            self.monsterinfo.currentmove = parasite_move_death;
        }
    };

    /*
     * === End Death Stuff ===
     */

    /*
     * QUAKED monster_parasite (1 .5 0) (-16 -16 -24) (16 16 32) Ambush
     * Trigger_Spawn Sight
     */

    public static EntThinkAdapter SP_monster_parasite = new EntThinkAdapter() {
    	public String getID(){ return "SP_monster_parasite"; }
        public boolean think(edict_t self) {
            if (GameBase.deathmatch.value != 0) {
                GameUtil.G_FreeEdict(self);
                return true;
            }

            sound_pain1 = GameBase.gi.soundindex("parasite/parpain1.wav");
            sound_pain2 = GameBase.gi.soundindex("parasite/parpain2.wav");
            sound_die = GameBase.gi.soundindex("parasite/pardeth1.wav");
            sound_launch = GameBase.gi.soundindex("parasite/paratck1.wav");
            sound_impact = GameBase.gi.soundindex("parasite/paratck2.wav");
            sound_suck = GameBase.gi.soundindex("parasite/paratck3.wav");
            sound_reelin = GameBase.gi.soundindex("parasite/paratck4.wav");
            sound_sight = GameBase.gi.soundindex("parasite/parsght1.wav");
            sound_tap = GameBase.gi.soundindex("parasite/paridle1.wav");
            sound_scratch = GameBase.gi.soundindex("parasite/paridle2.wav");
            sound_search = GameBase.gi.soundindex("parasite/parsrch1.wav");

            self.s.modelindex = GameBase.gi
                    .modelindex("models/monsters/parasite/tris.md2");
            Math3D.VectorSet(self.mins, -16, -16, -24);
            Math3D.VectorSet(self.maxs, 16, 16, 24);
            self.movetype = Defines.MOVETYPE_STEP;
            self.solid = Defines.SOLID_BBOX;

            self.health = 175;
            self.gib_health = -50;
            self.mass = 250;

            self.pain = parasite_pain;
            self.die = parasite_die;

            self.monsterinfo.stand = parasite_stand;
            self.monsterinfo.walk = parasite_start_walk;
            self.monsterinfo.run = parasite_start_run;
            self.monsterinfo.attack = parasite_attack;
            self.monsterinfo.sight = parasite_sight;
            self.monsterinfo.idle = parasite_idle;

            GameBase.gi.linkentity(self);

            self.monsterinfo.currentmove = parasite_move_stand;
            self.monsterinfo.scale = MODEL_SCALE;

            GameAI.walkmonster_start.think(self);

            return true;
        }
    };

    static boolean parasite_drain_attack_ok(float[] start, float[] end) {
        float[] dir = { 0, 0, 0 }, angles = { 0, 0, 0 };

        // check for max distance
        Math3D.VectorSubtract(start, end, dir);
        if (Math3D.VectorLength(dir) > 256)
            return false;

        // check for min/max pitch
        Math3D.vectoangles(dir, angles);
        if (angles[0] < -180)
            angles[0] += 360;
        if (Math.abs(angles[0]) > 30)
            return false;

        return true;
    }
}