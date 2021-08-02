----------------------------------------------------------------------------------
--	Copyright	(c)	2013	Fabian	Greif
--	
--	Description:	
--	
--	KT-Link	compatible	buffer	description	for	Blaster	v4.

----------------------------------------------------------------------------------

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity bb_v4_ktlink_14pin_ejtag is 
	port (
	--	JTAG	connector
	dbgack_p		:	in		std_logic;
	dbgrq_p			:	in		std_logic;
	srst_np			:	inout	std_logic;
	tdo_p			:	in		std_logic;	-- SWO
	rtck_p			:	in		std_logic;
	tck_p			:	inout	std_logic;	-- SWCLK
	tms_p			:	inout	std_logic;	-- SWDIO
	tdi_p			:	inout	std_logic;
	trst_np			:	out		std_logic;

	--	FT2232	connections
	ft_rx_p			:	out		std_logic;	-- bd1_p
	ft_tdi_oe_np	:	in		std_logic;
	ft_led_np		:	in		std_logic;
	ft_tck_oe_np	:	in		std_logic;
	ft_tms_oe_np	:	in		std_logic;
	ft_srst_oe_np	:	in		std_logic;
	ft_trst_oe_np	:	in		std_logic;
	ft_srst_out_p	:	in		std_logic;
	ft_trst_out_p	:	in		std_logic;
	ft_rtck_p		:	out		std_logic;
	ft_srst_in_p	:	out		std_logic;
	ft_swd_en_np	:	in		std_logic;

	ft_tms_p		:	in		std_logic;
	ft_tdo_p		:	out		std_logic;
	ft_tdi_p		:	in		std_logic;
	ft_tck_p		:	in		std_logic;

	bd0_p			:	in		std_logic;

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
	ad4				:	in		std_logic;
	--	other
	led_p			:	out		std_logic;
	button_np		:	in		std_logic
	);
end	bb_v4_ktlink_14pin_ejtag;

architecture behavioral	of bb_v4_ktlink_14pin_ejtag is
begin
	--	buffer	controlled	by	ft_jtag_oe
	tck_p				<=	ft_tck_p		when	ft_tck_oe_np	=	'0'	else	'Z';
	tdi_p				<=	ft_tdi_p		when	ft_tdi_oe_np	=	'0'	else	'Z';

	process (ft_tms_oe_np, ft_tdi_p, ft_tms_p, ft_swd_en_np, tdo_p, tms_p)
	begin
		if ft_swd_en_np = '0' then
			-- use SWD
			if ft_tms_oe_np = '0' then
				tms_p <= ft_tdi_p;
			else
				tms_p <= 'Z';
			end if;
			ft_tdo_p <= tms_p;
			ft_rx_p  <= tdo_p;
		else
			-- use JTAG
			if ft_tms_oe_np = '0' then
				tms_p <= ft_tms_p;
			else
				tms_p <= 'Z';
			end if;
			ft_tdo_p <= tdo_p;
			ft_rx_p  <= '1';
		end if;
	end process;
	
	trst_np			<= ft_trst_out_p	when	ft_trst_oe_np = '0' else 'Z';
	srst_np			<= ft_srst_out_p	when	ft_srst_oe_np = '0' else 'Z';
	ft_srst_in_p	<= srst_np;

	ft_rtck_p		<= rtck_p;

	led_p			<= not ft_led_np;
end	behavioral;

