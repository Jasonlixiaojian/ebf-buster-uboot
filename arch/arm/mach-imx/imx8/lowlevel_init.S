/*
 * Copyright 2017 NXP
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>

.align 8
.global rom_pointer
rom_pointer:
	.space 32

/*
 * Routine: save_boot_params (called after reset from start.S)
 */

.global save_boot_params
save_boot_params:
	/* The firmware provided ATAG/FDT address can be found in r2/x0 */
	adr	x0, rom_pointer
	stp	x1, x2, [x0], #16
	stp	x3, x4, [x0], #16

	/* Returns */
	/*
	 * We use absolute address not PC relative address for return.
	 * When running SPL on iMX8, the A core starts at address 0, a alias to OCRAM 0x100000,
	 * our linker address for SPL is from 0x100000. So using absolute address can jump to
	 * the OCRAM address from the alias.
	 * The alias only map first 96KB of OCRAM, so this require the SPL size can't beyond 96KB.
	 * But when using SPL DM, the size increase significantly and always beyonds 96KB.
	 * That's why we have to jump to OCRAM.
	 * Normal u-boot also runs into this codes, but there is no impact.
	 */
	ldr	x1, =save_boot_params_ret
	br	x1

.global restore_boot_params
restore_boot_params:
	adr	x0, rom_pointer
	ldp	x1, x2, [x0], #16
	ldp	x3, x4, [x0], #16
	ret
