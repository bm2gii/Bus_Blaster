----------------------------------------------------------------------------------
--	Copyright	(c)	2013	Fabian	Greif
--	
--	Description:	
--	
--	JTAG	Key	compatible	buffer	description	for	Blaster	v4.

----------------------------------------------------------------------------------

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity bb_v4_jtagkey_14pin_ejtag is 
	port (
	--	JTAG	connector
	dbgack_p		:	in		std_logic;
	dbgrq_p			:	inout	std_logic;
	srst_np			:	inout	std_logic;
	tdo_p			:	in		std_logic;	
	rtck_p			:	in		std_logic;
	tck_p			:	inout	std_logic;
	tms_p			:	inout	std_logic;	
	tdi_p			:	inout	std_logic;
	trst_np			:	out		std_logic;

	--	FT2232	connections
	ft_dbgack_p		:	out		std_logic;
	ft_dbgrq_p		:	in		std_logic;
	ft_srst_oe_np	:	in		std_logic;
	ft_trst_oe_np	:	in		std_logic;
	ft_srst_out_p	:	in		std_logic;
	ft_trst_out_p	:	in		std_logic;
	ft_rtck_p		:	out		std_logic;
	ft_srst_in_p	:	out		std_logic;
	ft_trgt_present	:	out		std_logic;
	ft_jtag_oe_np	:	in		std_logic;
	ft_tms_p		:	in		std_logic;
	ft_tdo_p		:	out		std_logic;
	ft_tdi_p		:	in		std_logic;
	ft_tck_p		:	in		std_logic;

	bd0_p			:	in		std_logic;
	bd1_p			:	in		std_logic;
	bd2_p			:	out		std_logic;
	bd3_p			:	in		std_logic;
	
	-- unused 	connections	
	bd4				:	in		std_logic;
	bd5				:	in		std_logic;
	bd6				:	in		std_logic;
	bd7				:	in		std_logic;
	bc0				:	in		std_logic;
	bc1				:	in		std_logic;
	bc2				:	in		std_logic;
	bc3				:	in		std_logic;
	bc4				:	in		std_logic;
	bc5				:	in		std_logic;
	bc6				:	in		std_logic;
	bc7				:	in		std_logic;
	ac6				:	in		std_logic;
	ac7				:	in		std_logic;	
	--	other
	led_p			:	out		std_logic;
	button_np		:	in		std_logic
	);
end	bb_v4_jtagkey_14pin_ejtag;

architecture behavioral	of bb_v4_jtagkey_14pin_ejtag is
begin
	--	buffer	controlled	by	ft_jtag_oe
	tck_p				<=	ft_tck_p		when	ft_jtag_oe_np	=	'0'	else	'Z';
	tdi_p				<=	ft_tdi_p		when	ft_jtag_oe_np	=	'0'	else	'Z';
	tms_p				<=	ft_tms_p		when	ft_jtag_oe_np	=	'0'	else	'Z';
	dbgrq_p				<=	ft_dbgrq_p		when	ft_jtag_oe_np	=	'0'	else	'Z';

	--	srst
	srst_np				<=	ft_srst_out_p	when	ft_srst_oe_np	=	'0'	else	'Z';
	ft_srst_in_p		<=	srst_np;
	
	--	trst
	trst_np				<=	ft_trst_out_p	when	ft_trst_oe_np	=	'0'	else	'Z';

	--	inputs
	ft_tdo_p			<=	tdo_p;
	ft_rtck_p			<=	rtck_p;
	ft_dbgack_p			<=	dbgack_p;
	ft_trgt_present		<=	'1';
	--	ouputs
	led_p				<=	not button_np;
end	behavioral;

