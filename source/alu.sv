`include "alu_if.vh"

module alu (
    alu_if.alu aluif
);
    import cpu_types_pkg::*;
    
    always_comb begin: ALUOP_Logic
        // Defaults
        aluif.oport = '0;
        aluif.overflow = 0;

        // Execute ALUOP
        case(aluif.ALUOP)
            // Shift Left Logical
            ALU_SLL: aluif.oport = aluif.portb << aluif.porta[4:0];
            // Shift Right Logical
            ALU_SRL: aluif.oport = aluif.portb >> aluif.porta[4:0];
            // ADD Signed
            ALU_ADD: begin
                aluif.oport = $signed(aluif.porta) + $signed(aluif.portb);
                aluif.overflow = 
                    // adding two negative numbers and obtaining a positive result
                    (aluif.oport[31] & ~aluif.porta[31] & ~aluif.portb[31]) | 
                    // adding two positive numbers and obtaining a negative result
                    (~aluif.oport[31] & aluif.porta[31] & aluif.portb[31]);
            end
            // SUB Signed
            ALU_SUB: begin
                aluif.oport = $signed(aluif.porta) - $signed(aluif.portb);
                aluif.overflow = 
                    // subtracting a negative number from a positive number and obtaining a negative result
                    (~aluif.oport[31] & aluif.porta[31] & ~aluif.portb[31]) |
                    // subtracting a positive number from a negative number and obtaining a positive result
                    (aluif.oport[31] & ~aluif.porta[31] & aluif.portb[31]);
            end
            // AND
            ALU_AND: aluif.oport = aluif.porta & aluif.portb;
            // OR
            ALU_OR: aluif.oport = aluif.porta | aluif.portb;
            // XOR
            ALU_XOR: aluif.oport = aluif.porta ^ aluif.portb;
            // NOR
            ALU_NOR: aluif.oport = ~(aluif.porta | aluif.portb);
            // Set Less Than Signed
            ALU_SLT: aluif.oport = $signed(aluif.porta) < $signed(aluif.portb);
            // Set Less Than Unsinged
            ALU_SLTU: aluif.oport = aluif.porta < aluif.portb;
        endcase

        // Assign Flags
        aluif.negative = aluif.oport[31];
        aluif.zero = (aluif.oport == '0);
    end

endmodule