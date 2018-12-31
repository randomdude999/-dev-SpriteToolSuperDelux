;only works for SA-1 version 1.10+

!CustomBit		= $08

macro debugmsg(msg)
	!__debug ?= 0					; set debug flag to 0 if not set already
	if !__debug = 1				; if set...
		print "$",pc," <msg>"	; print the pc address.
	endif
endmacro

;branch extra bit set
macro BES(label)
	LDA !extra_bits,x
	AND #$04
	BNE <label>
endmacro

;branch extra bit clear
macro BEC(label)
	LDA !extra_bits,x
	AND #$04
	BEQ <label>
endmacro

;Check if A is inbetween x and -x
macro Between(x, label)
	CLC : ADC <x>
	CMP <x>*2
	BCS <label>
endmacro

!EXLEVEL = 0
if (((read1($0FF0B4)-'0')*100)+((read1($0FF0B4+2)-'0')*10)+(read1($0FF0B4+3)-'0')) > 253
	!EXLEVEL = 1
endif

if read1($00FFD5) == $23		; check if the rom is sa-1
	sa1rom
	!SA1 = 1
	!SA_1 = 1
	!Base1 = $3000
	!Base2 = $6000
	
	!BankA = $400000
	!BankB = $000000
	
	!SprSize = $16
else
	lorom
	!SA1 = 0
	!SA_1 = 0
	!Base1 = $0000
	!Base2 = $0000
	
	!BankA = $7E0000
	!BankB = $800000
	
	!SprSize = $0C
endif

!OwSprSize = $18         ;  Lunar Magic gives support for up to 0x18 (24) slots per submap


macro define_sprite_table(name, addr, addr_sa1)
	if !SA1 == 0
		!<name> = <addr>
	else
		!<name> = <addr_sa1>
	endif
endmacro

macro define_base2_address(name, addr)
	if !SA1 == 0
		!<name> = <addr>
	else
		!<name> = <addr>|!Base2
	endif
endmacro


!ClusterOffset  = $09
!ExtendedOffset = $13

;$9E,x =  ($B4)


;sprite tool / pixi defines
%define_sprite_table("7FAB10",$7FAB10,$400040)
%define_sprite_table("7FAB1C",$7FAB1C,$400056)
%define_sprite_table("7FAB28",$7FAB28,$400057)
%define_sprite_table("7FAB34",$7FAB34,$40006D)
%define_sprite_table("7FAB9E",$7FAB9E,$400083)
%define_sprite_table("7FAB40",$7FAB40,$400099)
%define_sprite_table("7FAB4C",$7FAB4C,$4000AF)
%define_sprite_table("7FAB58",$7FAB58,$4000C5)
%define_sprite_table("7FAB64",$7FAB64,$4000DB)

%define_sprite_table("extra_bits",$7FAB10,$400040)
%define_sprite_table("new_code_flag",$7FAB1C,$400056)
%define_sprite_table("extra_prop_1",$7FAB28,$400057)
%define_sprite_table("extra_prop_2",$7FAB34,$40006D)
%define_sprite_table("new_sprite_num",$7FAB9E,$400083)
%define_sprite_table("extra_byte_1",$7FAB40,$400099)
%define_sprite_table("extra_byte_2",$7FAB4C,$4000AF)
%define_sprite_table("extra_byte_3",$7FAB58,$4000C5)
%define_sprite_table("extra_byte_4",$7FAB64,$4000DB)

;%define_sprite_table(shoot_misc,$7FAB64,$4000DB)

;shooter defines
%define_base2_address(shoot_num,$1783)		; shooter number -#$BC, also has the extra bit in #$40
%define_base2_address(shoot_y_low,$178B)
%define_base2_address(shoot_y_low,$178B)
%define_base2_address(shoot_y_high,$1793)
%define_base2_address(shoot_x_low,$179B)
%define_base2_address(shoot_x_high,$17A3)
%define_base2_address(shoot_timer,$17AB)


;cluster defines
%define_base2_address(cluster_num,$1892)
%define_base2_address(cluster_y_low,$1E02)
%define_base2_address(cluster_y_high,$1E2A)
%define_base2_address(cluster_x_low,$1E16)
%define_base2_address(cluster_x_high,$1E3E)

;extended defines
%define_base2_address(extended_num,$170B)
%define_base2_address(extended_y_low,$1715)
%define_base2_address(extended_y_high,$1729)
%define_base2_address(extended_x_low,$171F)
%define_base2_address(extended_x_high,$1733)
%define_base2_address(extended_x_speed,$1747)
%define_base2_address(extended_y_speed,$173D)
%define_base2_address(extended_table,$1765)
%define_base2_address(extended_timer,$176F)
%define_base2_address(extended_behind,$1779)


;overworld defines
%define_base2_address(ow_sprite_num, $14C8)
%define_base2_address(ow_sprite_speed_x, $14F8)
%define_base2_address(ow_sprite_speed_y, $1528)
%define_base2_address(ow_sprite_speed_z, $1558)
%define_base2_address(ow_sprite_x_pos, $1588)
%define_base2_address(ow_sprite_y_pos, $15B8)
%define_base2_address(ow_sprite_z_pos, $15E8)
%define_base2_address(ow_sprite_timer_1, $1618)
%define_base2_address(ow_sprite_timer_2, $1648)
%define_base2_address(ow_sprite_timer_3, $1678)
%define_base2_address(ow_sprite_misc_1, $16A8)
%define_base2_address(ow_sprite_misc_2, $16D8)
%define_base2_address(ow_sprite_misc_3, $1708)
%define_base2_address(ow_sprite_misc_4, $1738)
%define_base2_address(ow_sprite_misc_5, $1768)
%define_base2_address(ow_sprite_extra_bits, $1798)
%define_base2_address(ow_sprite_speed_x_acc, $17C8)
%define_base2_address(ow_sprite_speed_y_acc, $17F8)
%define_base2_address(ow_sprite_speed_z_acc, $1828)
;   Flags
%define_base2_address(ow_sprite_index, $1858)
%define_base2_address(ow_sprite_oam, $185A)



;normal sprite defines
%define_sprite_table(sprite_num, $9E, $3200)
%define_sprite_table(sprite_speed_y, $AA, $9E)
%define_sprite_table(sprite_speed_x, $B6, $B6)
%define_sprite_table(sprite_misc_c2, $C2, $D8)
%define_sprite_table(sprite_y_low, $D8, $3216)
%define_sprite_table(sprite_x_low, $E4, $322C)
%define_sprite_table(sprite_status, $14C8, $3242)
%define_sprite_table(sprite_y_high, $14D4, $3258)
%define_sprite_table(sprite_x_high, $14E0, $326E)
%define_sprite_table(sprite_speed_y_frac, $14EC, $74C8)
%define_sprite_table(sprite_speed_x_frac, $14F8, $74DE)
%define_sprite_table(sprite_misc_1504, $1504, $74F4)
%define_sprite_table(sprite_misc_1510, $1510, $750A)
%define_sprite_table(sprite_misc_151c, $151C, $3284)
%define_sprite_table(sprite_misc_1528, $1528, $329A)
%define_sprite_table(sprite_misc_1534, $1534, $32B0)
%define_sprite_table(sprite_misc_1540, $1540, $32C6)
%define_sprite_table(sprite_misc_154c, $154C, $32DC)
%define_sprite_table(sprite_misc_1558, $1558, $32F2)
%define_sprite_table(sprite_misc_1564, $1564, $3308)
%define_sprite_table(sprite_misc_1570, $1570, $331E)
%define_sprite_table(sprite_misc_157c, $157C, $3334)
%define_sprite_table(sprite_blocked_status, $1588, $334A)
%define_sprite_table(sprite_misc_1594, $1594, $3360)
%define_sprite_table(sprite_off_screen_horz, $15A0, $3376)
%define_sprite_table(sprite_misc_15ac, $15AC, $338C)
%define_sprite_table(sprite_slope, $15B8, $7520)
%define_sprite_table(sprite_off_screen, $15C4, $7536)
%define_sprite_table(sprite_being_eaten, $15D0, $754C)
%define_sprite_table(sprite_obj_interact, $15DC, $7562)
%define_sprite_table(sprite_oam_index, $15EA, $33A2)
%define_sprite_table(sprite_oam_properties, $15F6, $33B8)
%define_sprite_table(sprite_misc_1602, $1602, $33CE)
%define_sprite_table(sprite_misc_160e, $160E, $33E4)
%define_sprite_table(sprite_index_in_level, $161A, $7578)
%define_sprite_table(sprite_misc_1626, $1626, $758E)
%define_sprite_table(sprite_behind_scenery, $1632, $75A4)
%define_sprite_table(sprite_misc_163e, $163E, $33FA)
%define_sprite_table(sprite_in_water, $164A, $75BA)
%define_sprite_table(sprite_tweaker_1656, $1656, $75D0)
%define_sprite_table(sprite_tweaker_1662, $1662, $75EA)
%define_sprite_table(sprite_tweaker_166e, $166E, $7600)
%define_sprite_table(sprite_tweaker_167a, $167A, $7616)
%define_sprite_table(sprite_tweaker_1686, $1686, $762C)
%define_sprite_table(sprite_off_screen_vert, $186C, $7642)
%define_sprite_table(sprite_misc_187b, $187B, $3410)
%define_sprite_table(sprite_load_table, $1938, $418A00)
%define_sprite_table(sprite_tweaker_190f, $190F, $7658)
%define_sprite_table(sprite_misc_1fd6, $1FD6, $766E)
%define_sprite_table(sprite_cape_disable_time, $1FE2, $7FD6)

%define_sprite_table("9E", $9E, $3200)
%define_sprite_table("AA", $AA, $9E)
%define_sprite_table("B6", $B6, $B6)
%define_sprite_table("C2", $C2, $D8)
%define_sprite_table("D8", $D8, $3216)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("14C8", $14C8, $3242)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("14E0", $14E0, $326E)
%define_sprite_table("14EC", $14EC, $74C8)
%define_sprite_table("14F8", $14F8, $74DE)
%define_sprite_table("1504", $1504, $74F4)
%define_sprite_table("1510", $1510, $750A)
%define_sprite_table("151C", $151C, $3284)
%define_sprite_table("1528", $1528, $329A)
%define_sprite_table("1534", $1534, $32B0)
%define_sprite_table("1540", $1540, $32C6)
%define_sprite_table("154C", $154C, $32DC)
%define_sprite_table("1558", $1558, $32F2)
%define_sprite_table("1564", $1564, $3308)
%define_sprite_table("1570", $1570, $331E)
%define_sprite_table("157C", $157C, $3334)
%define_sprite_table("1588", $1588, $334A)
%define_sprite_table("1594", $1594, $3360)
%define_sprite_table("15A0", $15A0, $3376)
%define_sprite_table("15AC", $15AC, $338C)
%define_sprite_table("15B8", $15B8, $7520)
%define_sprite_table("15C4", $15C4, $7536)
%define_sprite_table("15D0", $15D0, $754C)
%define_sprite_table("15DC", $15DC, $7562)
%define_sprite_table("15EA", $15EA, $33A2)
%define_sprite_table("15F6", $15F6, $33B8)
%define_sprite_table("1602", $1602, $33CE)
%define_sprite_table("160E", $160E, $33E4)
%define_sprite_table("161A", $161A, $7578)
%define_sprite_table("1626", $1626, $758E)
%define_sprite_table("1632", $1632, $75A4)
%define_sprite_table("163E", $163E, $33FA)
%define_sprite_table("164A", $164A, $75BA)
%define_sprite_table("1656", $1656, $75D0)
%define_sprite_table("1662", $1662, $75EA)
%define_sprite_table("166E", $166E, $7600)
%define_sprite_table("167A", $167A, $7616)
%define_sprite_table("1686", $1686, $762C)
%define_sprite_table("186C", $186C, $7642)
%define_sprite_table("187B", $187B, $3410)
%define_sprite_table("190F", $190F, $7658)
%define_sprite_table("1938", $1938, $418A00)
%define_sprite_table("1FD6", $1FD6, $766E)
%define_sprite_table("1FE2", $1FE2, $7FD6)