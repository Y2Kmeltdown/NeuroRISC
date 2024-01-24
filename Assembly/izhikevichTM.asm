    /* memory address load routine | 2 Instructions */
    li      x8     256        /* Load data memory base address */
    li      x9,    1280        /* Load IO base address */

    /* Izhikevich parameter Load Routine | 7 Instructions* */
    li      x18,    171798690   /* izhikevich 1 0.04*/
    li      x19,    5           /* izhikevich 2 5*/
    li      x20,    140         /* izhekevish 3 140*/
    li      x21,    30          /* Voltage Threshold vth*/
    li      x22,    85899344    /* CPU clock period */
    li      x23,    4           /* Current Injection */
    li      x24,    10          /* Time Value */

    /* Memory Pointer initialization routine | 3 Instructions*/
    addi      x2,   x8,    0       /* Load initial memory pointer location */
    addi      x3,   x8,    0       /* Load initial memory pointer location */
    addi      x4,   x8,    0       /* Load initial synapse pointer location */
    
    /* Spiking neuron load routine | 9 instructions  modify this to load synapse variables  at execution time of synapse calculations*/
    lw      x10,    0(x2)   /* load V */
    lw      x11,    1(x2)   /* load U */
    lw      x12,    2(x2)   /* load I */
    lw      x13,    3(x2)   /* load t */
    
    lw      x14,    4(x2)   /* load a*/
    lw      x15,    5(x2)   /* load b*/
    lh      x16,    6(x2)   /* load c */
    lw      x17,    6(x2)   /* load d & c */
    srai    x17,    x17,    16  /* right shift d & c to remove c and complete d load */

    
    


    /* IO Read Routine | 12 Instructions */
    li      x5,     321          /*Load a neuron index that is allowed to read inputs*/ 
    bge     x2,     x5,     40    /*Skip input reading if condition isn't met*/
    nop

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
    mulh    x7,     x7,     x14 /* a(bv -u) */

    add     x10,    x10,    x6  /* v(n+1) = v(n)+dv */
    add     x11,    x11,    x7  /* u(n+1) = u(n)+du */
    /*blt     x0,     x11,    12  /* Branch past command if U is greater than 0 */
    /*nop
    /*addi    x11,    x0,     0   /* If U becomes negative reset back to 0 */
 
    /* Spike Detection Routine | 5 Instructions */
    blt     x10,    x21,    208 /* if V is less than threshold goto neuron store routine */
    nop
    li      x25,     2147483648  /* Load a bit into the end of output spike*/
    add     x5,     x5,     x2  /* add memory location */
    srai    x5,     x5,     4   /* Shift address by 16 because pointer increments by 16 */

    addi    x5,     x5,     -16 /* Subtract 16 from address */
    slli    x26,    x13,    13 /* Shift left so we only have 18:0 of time*/
    srli    x26,    x26,    27 /* Shift right so we only have 18:14 of time*/
    slli    x26,    x26,    4 /* Shift left so 18:14 of time is in the 8:4 of the output */
    add     x5,     x5,     x26
    add     x5,     x5,     x25

    sw      x5,     4(x9)       /* Store neuron memory location if neuron spiked */
    sw      x0,     4(x9)        /*clear spike output*/

    

    /* Reset Neuron Routine | 2 Instructions */
    add     x10,    x16,    x0 /* reset V to c */
    add     x11,    x11,    x17 /* increment U by d */

    /* Spike Emission Routine | 35 Instructions  Load neuron synapse variables here and overwrite a b c and d*/
    li      x28,    0    /* Initialise register counter */

    li      x5,     1     /* Initialise 1(spike) into temporary register*/
    li      x6,     0      /*Initialise counter*/
    li      x7,     32    /*Initialise end of counter*/
    
    lw      x14,    7(x4)   /* Load Excitatory synapse data */
    lw      x15,    9(x4)   /* Load Inhibitory synapse data */

        /*Register Change subroutine*/
    blt     x6,     x7,     36    /* If counter hasn't reached 32 branch past register incrementer*/
    nop
    addi    x4,     x4,     1 /* add 1 to synapse pointer */
    addi    x28,    x28,    1 /* add 1 to register counter */

    addi    x29,    x0,     2 /* set a check register to compare against register counter */
    beq     x28,    x29,    100 /* branch if check register counter is equal to 2. This indicates all connections of the neuron have been updated branch to store neuron routine */
    nop
    j       -48               /* Jump back to reinitialise counter */
    nop
    
        /*Check if there is a synapse connection */
    and     x30,    x14,    x5 /* and operation between excitatory reg 1 and spike to check first digit*/
    and     x31,    x15,    x5 /* and operation between inhibitory reg 1 and spike to check first digit*/
    srli    x14,    x14,    1  /* Shift spike output reg N right by 1*/
    srli    x15,    x15,    1  /* Shift spike output reg N right by 1*/
    
    or      x5,     x31,    x30 /* Check if either are 1 */
    beq     x5,    x0,      44  /* jump to end of spike emmission if and operation results in 0*/
    nop

    lw      x31,    2(x3)       /* Load current data from emission pointer */
    bne     x30,    x0,     20  /* Branch if connection is excitatory to skip subtraction step*/
    nop
    sub     x31,    x31,     x23 /* Subtract current from neuron if inhibitory*/
    j       8                  /* skip addition step */
    nop
    add     x31,    x31,     x23 /* add current to neuron if excitatory */
    sw      x31,    2(x3) /* store current injection value */

    add     x13,    x13,    x24 /* add time injection into current time */
    sw      x13,    7(x3) /* store time value */

    addi    x6,     x6,     1  /* Add 1 to counter */
    addi    x3,     x3,     16  /* Add 1 to counter */
    j       -116 /*return to start of routine */
    nop
    
    /* Neuron Store Routine | 9 Instructions */
    sw      x10,    0(x2)   /* store V */
    sw      x11,    1(x2)   /* store U */
    sw      x0,    2(x2)   /* store I NOTE is likely overwriting spikes that are recursively sent to itself*/
    sw      x13,    3(x2)   /* store t NOTE is likely overwriting spikes that are recursively sent to itself*/

    /* Change Neuron routine | 7 Instructions */
    addi    x2,     x2,     16 /* increment spike memory pointer by 16 */
    addi    x4,     x4,     14 /* increment Synapse pointer by 14 to set it to next neuron */
    blt     x2,     x9,     16 /* branch past neuron pointer reset if not at end of memory */
    nop
    addi    x2,     x8,     0    /* Reset neuron pointer location */
    addi    x4,     x8,     0    /* Reset Synapse pointer location */
    addi    x3,     x8,     0    /* reset spike emmission pointer location */
    j       -388 /* return to neuron load routine*/
    