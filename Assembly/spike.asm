    li      x25,    768        /* Load IO base address */

    /* Load Routine*/
    li 	    x18,    12  /* af1 tau*/
    li 	    x19, 	10  /* af2 (tau-dt)*/
    li      x20,    60  /* Load threshold V*/
    li	    x21, 	0	/* Starting V0  */
    li	    x22,	1	/* Spike data  */

    /* Spike Reset Routine */
    sw		x0,		4(x25)		/* reset spike IO */
    addi    x21,    x0,     0   /* reset v0 */

    /* IO Read Routine */
    lw		x5, 	0(x25)		/* read spike IO */
    add     x23,    x5,     x0  /* accumulate spike io*/

    lw		x5, 	1(x25)		/* read spike IO */
    add     x23,    x5,     x23 /* accumulate spike io*/

    lw		x5, 	2(x25)		/* read spike IO */
    add     x23,    x5,     x23 /* accumulate spike io*/

    lw		x5, 	3(x25)		/* read spike IO */
    add     x23,    x5,     x23 /* accumulate spike io*/

    /* Calculation Routine */
    mul		x5,  	x21,	x19 /* Calculation V0step1 = V0 * (tau-dt)*/

    div		x5,  	x18,	x5 /* Calculation V0step2 = V0step1 / tau */
    
    add		x21, 	x5,		x23 /* Calculation V0new = V0step2 + PSC*/
    
    blt		x21,	x20,	-44	/* Loop until spike If V0 > Vth continue*/
    nop /**/
    sw		x22,	4(x25)		/* store spike IO */	
    j		-68					/* Reset loop */

    /* Refactory Routine */