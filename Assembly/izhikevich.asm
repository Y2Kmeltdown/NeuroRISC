    li      x26,    768        /* Load IO base address */
    li      x27     256

    /* Load Routine*/
    li      x18,    85899344    /* a 0.02*/
    li      x19,    858993458   /* b 0.2*/
    li      x20,    -55         /* c */
    li      x21,    4           /* d */

    li      x22,    171798690   /* izhikevich 1 */
    li      x23,    5           /* izhikevich 2 */
    li      x24,    140         /* izhekevish 3 */

    li      x25,    30          /* Voltage Threshold */

    li	    x10,    -55	        /* V */
    li	    x11,	0	        /* U */
    li      x12,    0           /* I */

    /* IO Read Routine */
    sw      x10     1(x27)
    sw      x11     2(x27)
    lw		x5, 	0(x26)		/* read spike IO */
    add     x12,    x5,     x0  /* accumulate spike io*/

    lw		x5, 	1(x26)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    lw		x5, 	2(x26)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    lw		x5, 	3(x26)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    /* Calculation Routine */
    mul     x5,     x10,    x10 /* v^2 */
    mulh    x5,     x22,    x5  /* 0.04*v^2 */
    mul     x6,     x23,    x10 /* 5*v */
    add     x7,     x5,     x6  /* 0.04v^2 + 5v */
    add     x7,     x7,     x24 /* 0.04v^2 + 5v + 140 */
    sub     x7,     x7,     x11 /* 0.04v^2 + 5v + 140 - u */
    add     x7,     x7,     x12 /* 0.04v^2 + 5v + 140 - u + I*/

    mulh    x5,     x19,    x10 /* b*v */
    sub     x5,     x5,     x11 /* bv -u */
    mulh    x5,     x18,    x5  /* a(bv -u) */

    add     x10,    x10,    x7  /* v(n+1) = v(n)+v' */
    add     x11,    x11,    x5  /* u(n+1) = u(n)+v' */
    
    blt		x10,	x25,	-88	/* Loop until spike If V0 > Vth continue*/
    nop /**/
    sw		x10,	4(x26)		/* store spike IO */	

    /* Spike Reset Routine */
    sw      x10     1(x27)
    sw      x11     2(x27)
    sw		x0,		4(x26)		/* reset spike IO */
    addi    x10,    x20,    0   /* reset v */
    add     x11,    x11,    x21 /* reset u */

    j		-124			    /* Reset loop */