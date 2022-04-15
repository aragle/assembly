.MODEL SMALL
.STACK 100H
.DATA    

;Instruction messages
NL EQU 0DH,0AH 
MSG_SELECT_OPERATION DB "Select an operation",NL,"(Enter",NL," '+' for add,",NL," '-' for sub,",NL," '*' for mul,",NL," '/' for div): $"
MSG_INVALID_INPUT DB NL,NL,"Invalid Input$"
MSG_FIRST_NUM DB NL,NL,"Enter the first two digit number: $"
MSG_SECOND_NUM DB NL,"Enter the second two digit number: $"  
MSG_SUM DB NL,NL,"The value of Sum: $"    
MSG_SUB DB NL,NL,"The value of Sub: $"
MSG_MUL DB NL,NL,"The value of Mul: $"
MSG_NUM1 DB NL,NL,"Enter first number: $"
MSG_NUM2 DB NL,NL,"Enter second number: $"
MSG_MUL_NOTE DB " (Mul of two digits from 1st number)$"
MSG_DIV DB NL,NL,"The value of Div: $"
MSG_DIV_QUO DB "Quotient=$"
MSG_DIV_REM DB " Remainder=$"

;Variable declaration 
DIGIT1 DB ?
DIGIT2 DB ?
NUM1 DB ?
NUM2 DB ?
RESULT_SUM DB ?  
RESULT_SUB DB ? 
RESULT_MUL DB ?

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX 
    
    ;Select operation
    LEA DX,MSG_SELECT_OPERATION
    MOV AH,9
    INT 21H
    MOV AH,1
    INT 21H
    MOV CL,AL   
    CMP CL,"+"
    JE OP_ADDITION 
    CMP CL,"-"
    JE OP_SUBTRACTION
    CMP CL,"*"
    JE OP_MULTIPLICATION
    CMP CL,"/"
    JE OP_DIVISION
    JMP INVALID
     
    ;Addition 
OP_ADDITION:
    ;Get two digits numbers for addition
    LEA DX,MSG_FIRST_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM1,AL
    LEA DX,MSG_SECOND_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM2,AL
    LEA DX,MSG_SUM
    MOV AH,9
    INT 21H
    CALL ADDITION
    MOV AL,RESULT_SUM 
    CALL DISPLAY_RESULT
    JMP EXIT
    
    ;Subtraction
OP_SUBTRACTION:
    ;Get two digits numbers for subtraction
    LEA DX,MSG_FIRST_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM1,AL
    LEA DX,MSG_SECOND_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM2,AL 
    LEA DX,MSG_SUB
    MOV AH,9
    INT 21H
    CALL SUBTRACTION 
    MOV AL,RESULT_SUB 
    CALL DISPLAY_RESULT
    JMP EXIT
     
    ;Multipliation
OP_MULTIPLICATION:
    ;Get two digits numbers for multilication
    
    LEA DX,MSG_NUM1
    MOV AH,9
    INT 21H
        
    MOV AH,1
    INT 21H
    MOV DIGIT1,AL
    SUB DIGIT1,30H

    LEA DX,MSG_NUM2
    MOV AH,9
    INT 21H
     
    MOV AH,1
    INT 21H
    MOV DIGIT2,AL
    SUB DIGIT2,30H
    MOV AL,10
    MUL DIGIT1
    ADD AL,DIGIT2
    MOV NUM1,AL

    LEA DX,MSG_MUL
    MOV AH,9
    INT 21H
    
    CALL MULTIPLICATION 
    JMP EXIT
    
    ;Division
OP_DIVISION:  
    ;Get two digits numbers for division
    LEA DX,MSG_FIRST_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM1,AL
    LEA DX,MSG_SECOND_NUM
    MOV AH,9
    INT 21H
    CALL GET_TWO_DIGIT
    MOV NUM2,AL
    LEA DX,MSG_DIV
    MOV AH,9
    INT 21H
    CALL DIVISION
    JMP EXIT

    ;Terminate program fot invalid input
INVALID:
    LEA DX,MSG_INVALID_INPUT
    MOV AH,9
    INT 21H
    JMP EXIT
    
EXIT:    
    MOV AH,4CH
    INT 21H
         
MAIN ENDP 

GET_TWO_DIGIT PROC
    MOV AH,1
    INT 21H
    MOV DIGIT1,AL
    SUB DIGIT1,30H
    INT 21H
    MOV DIGIT2,AL
    SUB DIGIT2,30H
    MOV AL,10
    MUL DIGIT1
    ADD AL,DIGIT2
    RET 
GET_TWO_DIGIT ENDP

ADDITION PROC
    MOV BL,NUM1
    ADD BL,NUM2
    MOV RESULT_SUM,BL
    RET   
ADDITION ENDP 

SUBTRACTION PROC
    MOV BL,NUM1
    SUB BL,NUM2
    MOV RESULT_SUB,BL
    RET   
SUBTRACTION ENDP 

MULTIPLICATION PROC
    MOV AL,NUM1
    CBW
    MOV BL,10       
    DIV BL 
    MOV DIGIT1,AL
    MOV DIGIT2,AH  
    MOV AL,DIGIT1
    MUL DIGIT2
    ADD AL,30H
    MOV AH,2
    MOV DL,AL
    INT 21H 
    RET 
MULTIPLICATION ENDP 

DIVISION PROC 
    MOV AL,NUM1
    CBW     
    DIV NUM2 
    MOV DIGIT1,AL
    MOV DIGIT2,AH  
    ADD DIGIT1,30H
    ADD DIGIT2,30H
    LEA DX,MSG_DIV_QUO
    MOV AH,9
    INT 21H 
    MOV AH,2
    MOV DL,DIGIT1
    INT 21H 
    LEA DX,MSG_DIV_REM
    MOV AH,9
    INT 21H   
    MOV AH,2
    MOV DL,DIGIT2
    INT 21H
    RET 
DIVISION ENDP 
 
DISPLAY_RESULT PROC
    CBW
    MOV BL,10       
    DIV BL 
    MOV DIGIT1,AL
    MOV DIGIT2,AH  
    ADD DIGIT1,30H
    ADD DIGIT2,30H
    MOV AH,2
    MOV DL,DIGIT1
    INT 21H
    MOV AH,2
    MOV DL,DIGIT2
    INT 21H
    RET   
DISPLAY_RESULT ENDP
    END MAIN