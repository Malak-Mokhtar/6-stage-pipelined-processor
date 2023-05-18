LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Execute_Stage IS
    PORT (
        --INPUT PORTS    
        clk, general_rst : IN STD_LOGIC; -- WHY Reg_File_rst??
        DE_Carry_en_out,
        DE_ALU_en_out,
        DE_MemWrite_en_out,
        DE_MemRead_en_out,
        EM_MemWrite_en_out,
        EM_MemRead_en_out,
        DE_JZ_en_out,
        DE_SETC_en_out,
        DE_CLRC_en_out,
        DE_JC_en_out,
        MW_RTI_en_out, --Should be passed from outside, !!!FOR MARK!!!!
        EM_RegWrite_en_out,
        MM_RegWrite_en_out,
        MW_FLAGS_en_out,
        MW_RegWrite_en_out,
        DE_SP_en_out,
        DE_SP_inc_en_out : IN STD_LOGIC;
        DE_Read_Data1_out,
        DE_Read_Data2_out, MW_Read_Data_out,
        MM_ALU_OUT, EM_ALU_OUT, Write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DE_Read_Address1,
        DE_Read_Address2, EM_Write_Addr_out, MM_Write_Addr_out, MW_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        DE_OPCODE_out : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        -- OUTPUT PORTS
        en_structural,
        ZF_OUT,
        CF_OUT,
        NF_OUT,

        DE_Carry_en,
        DE_MemWrite_en,
        DE_MemRead_en,
        DE_RTI_en_out : OUT STD_LOGIC;
        ALU_Out,
        DE_Read_Data1_final,
        DE_Read_Data2_final,
        SP_before,
        SP_after : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END Execute_Stage;

ARCHITECTURE arch OF Execute_Stage IS

    --ALU component
    COMPONENT ALU IS
        PORT (
            Read_Data1, Read_Data2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            FUNC : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            ALU_en : IN STD_LOGIC;
            ALU_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            ZF_ALU, CF_ALU, NF_ALU : OUT STD_LOGIC);
    END COMPONENT;

    --flags--

    COMPONENT Flag_Restoring IS
        PORT (
            Read_Data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            ZF_RTI, CF_RTI, NF_RTI : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT Zero_except_RTI IS
        PORT (
            ZF_ALU, JZ_en : IN STD_LOGIC;
            ZF_EXCEPT_RTI : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT Carry_except_RTI IS
        PORT (
            CF_ALU, SETC_en, CLRC_en, JC_en : IN STD_LOGIC;
            CF_EXCEPT_RTI : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT MUX_ZF IS
        PORT (
            ZF_EXCEPT_RTI, ZF_RTI, FLAGS_en : IN STD_LOGIC;
            ZF_selected : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT MUX_CF IS
        PORT (
            CF_EXCEPT_RTI, CF_RTI, FLAGS_en : IN STD_LOGIC;
            CF_selected : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT MUX_NF IS
        PORT (
            NF_ALU, NF_RTI, FLAGS_en : IN STD_LOGIC;
            NF_selected : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT ZF IS
        PORT (
            ZF_Selected, clk, rst, DE_ALU_en_out, MW_FLAGS_en_out, DE_JZ_en_out : IN STD_LOGIC;
            ZF_OUT : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT CF IS
        PORT (
            CF_Selected, clk, rst, DE_Carry_en_out, MW_FLAGS_en_out : IN STD_LOGIC;
            CF_OUT : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT NF IS
        PORT (
            NF_Selected, clk, rst, DE_ALU_en_out, MW_FLAGS_en_out : IN STD_LOGIC;
            NF_OUT : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT Data_forwarding IS
        PORT (
            DE_Read_Address1, DE_Read_Address2, EM_Write_Addr_out, MM_Write_Addr_out, MW_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            EM_RegWrite_en_out, MM_RegWrite_en_out, MW_RegWrite_en_out : IN STD_LOGIC;
            Read_data2_sel, Read_data1_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
    END COMPONENT;

    COMPONENT Structural_HDU IS
        PORT (
            DE_MemRead_en_out, EM_MemRead_en_out, DE_MemWrite_en_out, EM_MemWrite_en_out : IN STD_LOGIC;
            en_structural : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT MUX_ALU_OP1 IS
        PORT (
            DE_Read_Data1_out, MM_ALU_Out_out, EM_ALU_out, Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Read_Data1_final_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            Read_data1_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0));

    END COMPONENT;
    COMPONENT MUX_ALU_OP2 IS
        PORT (
            DE_Read_Data2_out, MM_ALU_Out_out, EM_ALU_out, Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Read_Data2_final_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            Read_data2_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0));

    END COMPONENT;

    COMPONENT Stack_Pointer IS
        PORT (
            clk, rst, en : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT SP_ALU IS
        PORT (
            SP_en, inc_en : IN STD_LOGIC;
            sp_before : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            sp_after : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    -------------------SIGNALS----------------
    SIGNAL ZF_SIG, NF_SIG, CF_SIG, ZF_EXCEPT_RTI_SIG, CF_EXCEPT_RTI_SIG, ZF_RTI_SIG, CF_RTI_SIG, NF_RTI_SIG,
    ZF_selected_SIG, CF_selected_SIG, NF_selected_SIG : STD_LOGIC;

    SIGNAL DE_Read_Data1_final_out_sig, DE_Read_Data2_final_out_sig, SP_before_sig, SP_after_sig : STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL Read_data1_sel_sig, Read_data2_sel_sig : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
    Flag_Restoring_MAP : Flag_Restoring PORT MAP(
        Read_Data => MW_Read_Data_out,
        ZF_RTI => ZF_RTI_SIG,
        CF_RTI => CF_RTI_SIG,
        NF_RTI => NF_RTI_SIG
    );

    Zero_except_RTI_MAP : Zero_except_RTI PORT MAP(
        ZF_ALU => ZF_SIG,
        JZ_en => DE_JZ_en_out,
        ZF_EXCEPT_RTI => ZF_EXCEPT_RTI_SIG
    );

    Carry_except_RTI_MAP : Carry_except_RTI PORT MAP(
        CF_ALU => CF_SIG,
        SETC_en => DE_SETC_en_out,
        CLRC_en => DE_CLRC_en_out,
        JC_en => DE_JC_en_out,
        CF_EXCEPT_RTI => CF_EXCEPT_RTI_SIG
    );
    MUX_ZF_MAP : MUX_ZF PORT MAP(
        ZF_EXCEPT_RTI => ZF_EXCEPT_RTI_SIG,
        ZF_RTI => ZF_RTI_SIG,
        FLAGS_en => MW_FLAGS_en_out,
        ZF_selected => ZF_selected_SIG
    );

    MUX_CF_MAP : MUX_CF PORT MAP(
        CF_EXCEPT_RTI => CF_EXCEPT_RTI_SIG,
        CF_RTI => CF_RTI_SIG,
        FLAGS_en => MW_FLAGS_en_out,
        CF_selected => CF_selected_SIG
    );

    MUX_NF_MAP : MUX_NF PORT MAP(
        NF_ALU => NF_SIG,
        NF_RTI => NF_RTI_SIG,
        FLAGS_en => MW_FLAGS_en_out,
        NF_selected => NF_selected_SIG
    );

    ZF_MAP : ZF PORT MAP(
        ZF_Selected => ZF_selected_SIG,
        DE_JZ_en_out => DE_JZ_en_out,
        MW_FLAGS_en_out => MW_FLAGS_en_out,
        DE_ALU_en_out => DE_ALU_en_out,
        ZF_OUT => ZF_OUT,
        clk => clk,
        rst => general_rst
    );

    NF_MAP : NF PORT MAP(
        NF_Selected => NF_selected_SIG,
        DE_ALU_en_out => DE_ALU_en_out,
        MW_FLAGS_en_out => MW_FLAGS_en_out,
        NF_OUT => NF_OUT,
        clk => clk,
        rst => general_rst
    );

    CF_MAP : CF PORT MAP(
        CF_Selected => CF_selected_SIG,
        DE_Carry_en_out => DE_Carry_en_out,
        MW_FLAGS_en_out => MW_FLAGS_en_out,
        clk => clk,
        rst => general_rst,
        CF_out => CF_out
    );
    MUX_ALU_OP1_MAP : MUX_ALU_OP1 PORT MAP(
        DE_Read_Data1_out => DE_Read_Data1_out,
        MM_ALU_Out_out => MM_ALU_Out,
        EM_ALU_out => EM_ALU_out,
        Write_data => Write_data,
        DE_Read_Data1_final_out => DE_Read_Data1_final_out_sig,
        Read_data1_sel => Read_data1_sel_sig
    );

    MUX_ALU_OP2_MAP : MUX_ALU_OP2 PORT MAP(
        DE_Read_Data2_out => DE_Read_Data2_out,
        MM_ALU_Out_out => MM_ALU_Out,
        EM_ALU_out => EM_ALU_out,
        Write_data => Write_data,
        DE_Read_Data2_final_out => DE_Read_Data2_final_out_sig,
        Read_data2_sel => Read_data2_sel_sig
    );

    Data_forwarding_MAP : Data_forwarding PORT MAP(
        DE_Read_Address1 => DE_Read_Address1,
        DE_Read_Address2 => DE_Read_Address2,
        EM_Write_Addr_out => EM_Write_Addr_out,
        MM_Write_Addr_out => MM_Write_Addr_out,
        MW_Write_Addr_out => MW_Write_Addr_out,
        EM_RegWrite_en_out => EM_RegWrite_en_out,
        MM_RegWrite_en_out => MM_RegWrite_en_out,
        MW_RegWrite_en_out => MW_RegWrite_en_out,
        Read_data1_sel => Read_data1_sel_sig,
        Read_data2_sel => Read_data2_sel_sig
    );

    Structural_HDU_MAP : Structural_HDU PORT MAP(
        DE_MemRead_en_out => DE_MemRead_en_out,
        EM_MemRead_en_out => EM_MemRead_en_out,
        DE_MemWrite_en_out => DE_MemWrite_en_out,
        EM_MemWrite_en_out => EM_MemWrite_en_out,
        en_structural => en_structural
    );

    ALU_MAP : ALU PORT MAP(
        Read_data1 => DE_Read_Data1_final_out_sig,
        Read_data2 => DE_Read_Data2_final_out_sig,
        FUNC => DE_OPCODE_out (2 DOWNTO 0),
        ALU_en => DE_ALU_en_out,
        ALU_out => ALU_out,
        ZF_ALU => ZF_SIG,
        CF_ALU => CF_SIG,
        NF_ALU => NF_SIG
    );

    Stack_Pointer_MAP : Stack_Pointer PORT MAP(
        clk => clk,
        rst => general_rst,
        en => DE_SP_en_out,
        data => SP_after_sig,
        out_data => SP_before_sig
    );

    SP_ALU_MAP : SP_ALU PORT MAP(
        SP_en => DE_SP_en_out,
        inc_en => DE_SP_inc_en_out,
        SP_after => SP_after_sig,
        SP_before => SP_before_sig
    );
    
    --Remaining Output Signals
    DE_Read_Data1_final <= DE_Read_Data1_final_out_sig;
    DE_Read_Data2_final <= DE_Read_Data2_final_out_sig;
    DE_Carry_en <= DE_Carry_en_out;
    DE_MemWrite_en <= DE_MemWrite_en_out;
    DE_MemRead_en <= DE_MemRead_en_out;
    SP_after <= SP_after_sig;
    SP_before <= SP_before_sig;
    DE_RTI_en_out <= MW_RTI_en_out;
END ARCHITECTURE;