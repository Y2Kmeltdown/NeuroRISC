    /* memory address load routine | 2 Instructions */
    li      x8     256        /* Load data memory base address */
    li      x9,    1280        /* Load IO base address */

    /* Izhikevich parameter Load Routine | 7 Instructions* */
    li      x18,    171798690   /* izhikevich 1 0.04*/
    li      x19,    5           /* izhikevich 2 5*/
    li      x20,    140         /* izhekevish 3 140*/
    li      x21,    30          /* Voltage Threshold vth*/
    li      x22,    85899344    /* CPU clock period */
    li      x23,    10          /* Current Injection */
    li      x24,    10          /* Time Value */

    /* Memory Pointer initialization routine | 2 Instructions*/
    addi      x2,   x8,    0       /* Load initial memory pointer location */
    addi      x3,   x8,    0       /* Load initial memory pointer location */
    addi      x4,   x8,    0       /* Load initial synapse pointer location */
    
    /* Spiking neuron load routine | 11 instructions  modify this to load synapse variables  at execution time of synapse calculations*/
    lw      x10,    0(x2)   /* load V */
    lw      x11,    1(x2)   /* load U */
    lw      x12,    2(x2)   /* load I */
    lw      x13,    3(x2)   /* load t */
    
    lw      x14,    4(x2)   /* load a*/
    lw      x15,    5(x2)   /* load b*/
    lh      x16,    6(x2)   /* load c */
    lw      x17,    6(x2)   /* load d & c */
    srai    x17,    x17,    16  /* right shift d & c to remove c and complete d load */

    /*lw      x25,    7(x2)   /* load synapse A */
    /*lw      x26,    8(x2)   /* load synapse B */
    


    /* IO Read Routine | 9 Instructions */
    lw		x5, 	0(x9)		/* read spike IO */
    add     x12,    x5,     x0  /* accumulate spike io*/

    lw		x5, 	1(x9)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    lw		x5, 	2(x9)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    lw		x5, 	3(x9)		/* read spike IO */
    add     x12,    x5,     x12 /* accumulate spike io*/

    lw      x31,     5(x9)      /* read counter value  COULD Be a problem made counter 31 bits to account for sign problem*/


    /* Calculation Routine | 12 Instructions */
    mul     x6,     x10,    x10 /* v^2 */
    mulh    x6,     x6,     x18  /* 0.04*v^2 */
    mul     x7,     x19,    x10 /* 5*v */
    add     x6,     x6,     x7  /* 0.04v^2 + 5v */
    add     x6,     x6,     x20 /* 0.04v^2 + 5v + 140 */
    sub     x6,     x6,     x11 /* 0.04v^2 + 5v + 140 - u */
    add     x6,     x6,     x12 /* 0.04v^2 + 5v + 140 - u + I*/

    mulh    x7,     x15,    x10 /* b*v */
    sub     x7,     x7,     x11 /* bv -u */
    mulh    x7,     x7,     x14  /* a(bv -u) */

    /* at this point we have x31 = current time, x13 = previous time, x6 = v', x7 = u', x10 = v, x11 = u*/
    /* sub     x5,     x31,    x13 /* dt = t(n)-t(n-1) */

    /* at this point we have x5 = dt, x6 = v', x7 = u', x10 = v, x11 = u*/
    /* mul     x28,    x5,     x22 
    /* mulh    x29,    x5,     x22 /* dt in no. of clocks past * clock period in uS = dt in uS */
    /* mul     x6,     x6,     x5  /* dv = v'*dt */
    /* mul     x7,     x7,     x5  /* du = v'*du */

    /*  */
    add     x10,    x10,    x6  /* v(n+1) = v(n)+dv */
    add     x11,    x11,    x7  /* u(n+1) = u(n)+du */

    /* Addition overflow check */
    /* add     t0,     t1,     t2 */
    /* slti    t3,     t2,     0 */
    /* slt     t4,     t0,     t1 */
    /* bne     t3,     t4,     overflow */
    
    /* Spike detection routine | 2 Instructions */
    blt     x10,    x21,    40 /* if V is less than threshold skip instructions */
    nop

    /* Reset Neuron Routine | 2 Instructions */
    add     x10,    x16,    x0 /* reset V to c */
    add     x11,    x11,    x17 /* increment U by d */



    /* spike emission routine | 39 Instructions  Load neuron synapse variables here and overwrite a b c and d*/
    /* Count up neurons TODO sort out jump lengths*/
    /* TODO automate synapse register changing */
    addi x5, x0, 1     /* Initialise 1(spike) into temporary register*/
    addi x6, x0, 0      /*Initialise counter*/
    addi x7, x0, 32    /*Initialise end of counter*/
    addi x28, x0, 0    /* Initialise register counter */
    

    lw   x14,   7(x4)   /* Load synapse data */
    bge  x6, x7, 16    /* Go to register counter incrementer TODO change jump range to bottom of routine*/
    nop
    j   12
    nop
    addi x4, x4, 1 /* add 1 to register counter */
    addi x28, x28, 1 /* add 1 to synapse pointer */
    
    and x30, x14, x5 /* and operation of the spike output reg 1 to check if the first digit is 1*/
    srli x14, x14, 1  /* Shift output reg 1 right by 1*/
    addi x6, x6, 1  /* Add 1 to counter */
    beq x30, x0, 24  /* skip spike storage if and operation results in 0*/
    nop

    addi x29, x0, 2 /* set a check register to compare against register counter */
    blt x28, x29, 12/*branch if counter less than 2 set excitatory or inhibitory*/
    nop
    addi x15, x0, 0 /* set excitatory synapse */
    j       4
    nop
    addi x15, x0, 1 /* set inhibitory synapse */

    addi x29, x0, 5 /* set a check register to compare against register counter */
    bge  x28, x29, 4 /* branch if counter is greater than or equal to 5 this will show all register values have been cycled through */
    nop
    
    beq     x15,    x0,     20
    nop
    sub     x31,    x0,     x23
    j       12
    nop
    add     x31,    x0,     x23
    sw      x31,    2(x3) /* store current injection value */

    add     x13,    x13,    x24 /* add time injection into current time */
    sw      x13,    7(x3) /* store time value */
    addi    x3,     x3,     8 /* increment spike memory pointer by 8 */
    bne     x3,     x9,     -132 /* branch back to start of spike emission routine if memory pointer does not equal end of memory */
    nop
    addi    x3,     x8,     0       /* reset initial memory pointer location */

    
    
    
    /* Spike Store Routine | 12 Instructions */
    beq     x13,    x0,     12 /* check if x13 is zero */
    nop
    addi    x13,    x13,    -1 /* subtract 1 from x13 */

    sw      x10,    0(x2)   /* store V */
    sw      x11,    1(x2)   /* store U */
    sw      x12,    2(x2)   /* store I NOTE is likely overwriting spikes that are recursively sent to itself*/
    sw      x13,    3(x2)   /* store t NOTE is likely overwriting spikes that are recursively sent to itself*/
    
    sw      x14,    4(x2)   /* store a*/
    sw      x15,    5(x2)   /* store b*/
    slli    x17,    x17,    16 /* left shift d 16 bits */
    add     x17,    x17,    x16 /* add c & d into single register where d is top 16 bits and c is bottom 16 bits */
    sw      x17,    6(x2)   /* store c & d */

    /* Change neuron routine | 4 Instructions */
    addi    x2,     x2,     16 /* increment spike memory pointer by 8 */
    bne     x3,     x9,     -216 /* branch back to start of spike emission routine if memory pointer does not equal end of memory */
    nop
    addi    x3,     x8,     0       /* reset initial memory pointer location */
    j       -224
    