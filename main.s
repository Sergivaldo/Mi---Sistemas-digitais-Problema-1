.equ nano_sleep, 162  @ Número da chamada nano_sleep
.equ level, 52        @ Offset do registrador de nível das gpios

.include "gpio.s"
.include "lcd.s"

.global _start        @

.macro nanoSleep time
        LDR R0,=\time      
        LDR R1,=\time        
        MOV R7, #162  
        SWI 0                
.endm

@ Macro para verificar o nível do pino
@ Recebe o pino que vai ser verificado
.macro reg_lvl_verify pin
	LDR R9,[R8,#level] @ Carrega em R9 o valor de R8 deslocado para o offset do registrador de nível
    	AND R10,R9,\pin @ Faz uma operação lógica and para pegar apenas o bit do pino que foi passado.
    	CMP R10,#0 @ Compara se o valor de R10 é igual a 0
.endm

@ Macro para definor o valor inicial do temporizador 
.macro set_init_val mil,cen,dez,uni @ Passa cada digito do valor inicial como parametro
        MOV R6,#\uni                    @ Move o hexadecimal da unidade para o R6
        MOV R5,#\dez                    @ Move o hexadecimal da dezena para o R5
        MOV R12,#\cen                   @ Move o hexadecimal da centena para o R12
        MOV R4,#\mil                    @ Move o hexadecimal do milhar para o R4
.endm

@ Exibir a mensagem inicial "Aperte o Botao"
msg_in:
        clearLcd      @ Limpa o LCD

        write #0x41   @ A
        write #0xF0   @ p
        write #0x65   @ e
        write #0x72   @ r
        write #0x74   @ t
        write #0x65   @ e
        write #0xFE   @ 
        write #0x6F   @ o
        write #0xFE   @
        write #0x42   @ B
        write #0x6F   @ o
        write #0x74   @ t
        write #0x61   @ a
        write #0x6F   @ o
        
        set_init_val 0x31,0x30,0x30,0x33 @ define cada digito do valor inicial da contagem
        B init

@ Exibir a mensagem de pause "Pausado"
msg_pause:
        SUB SP,#4
        STR R6,[SP,#0]
        clearLcd
        
        write #0x50 @ P
        write #0x61 @ a
        write #0x75 @ u
        write #0x73 @ s
        write #0x61 @ a
        write #0x64 @ d
        write #0x6f @ o
        
        LDR R6,[SP,#0]
        B pause


.macro msg_counter
	SUB SP,#4     
        STR R6,[SP,#0]

    	write #0x43 @ C
        write #0x6F @ o
        write #0x6E @ n
        write #0x74 @ t
        write #0x61 @ a
        write #0x6E @ n
        write #0x64 @ d
        write #0x6F @ o
        write #0x3A @ :
        write #0xFE @    
.endm	
        

counter:
		
        CMP R6,#0x30 
        SUBLT R5,#1
        MOVLT R6,#0x39
        
        CMP R5,#0x30
        SUBLT R12,#1
        MOVLT R5,#0x39
        
        CMP R12,#0X30
        SUBLT R4,#1
        MOVLT R12,#0X39
        
        clearLcd
        
        msg_counter

        write R4
        write R12
        write R5
        LDR R6,[SP,#0]
        write R6
        
        nanoSleep time1s
        
        MOV R11,#1             @
        LSL R11,#5             @
        reg_lvl_verify R11     @
        BEQ msg_pause          @
        
        MOV R11,#1             @
        LSL R11,#19            @
        reg_lvl_verify R11     @
        BEQ msg_in             @
        
        CMP R6, #0x30          @ Compara a unidade com o hexadecimal 30
        BLEQ dez_is_zero       @ Se for igual devia para a comparação da dezena
        
        SUB R6,#1              @ Subtrai 1 do registrador que esta contando as unidades
        B counter              @ Reinicia o loop do contador


init:
        nanoSleep time500ms
        MOV R11,#1
        LSL R11,#5  
        reg_lvl_verify R11
        BEQ counter
        
        MOV R11,#1
        LSL R11,#19
        reg_lvl_verify R11
        BEQ msg_in
        
        B init


pause:
        nanoSleep time500ms
        MOV R11,#1
        LSL R11,#5  
        reg_lvl_verify R11
        BEQ counter
        
        MOV R11,#1
        LSL R11,#19
        reg_lvl_verify R11
        BEQ msg_in
        
        B pause
    
@ Verificar se a dezena é igual a zero
dez_is_zero:
        CMP R5,#0x30    @ Compara o valor do registrador com hexadecimal 30
        BEQ cen_is_zero @ Se for igual, desvia para verificar a centena
        
        BX LR           @ Volta para 

cen_is_zero:
        CMP R12,#0x30
        BEQ mil_is_zero
        
        BX LR
	
mil_is_zero:
        CMP R4,#0x30
        BEQ msg_in
        
        BX LR

_start:
        memory_map
        setOut
        fset
        fset
        fset
        display 1, 1, 1
        entrymode 0, 0
        
        B msg_in
    
@ Branch para finalizar o programa
_end:
        MOV R7, #1 
        SWI 0 
		
.data

led:
	.word 0
	.word 18
	.word 6

fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200
        
time1s:
	.word 1
	.word 000000000

time500ms:
	.word 0
	.word 500000000
time1ms:
	.word 0
	.word 1500000

@ Lcd

rs:
	.word 8
	.word 15
	.word 25
e:
	.word 0
	.word 3
	.word 1
d4: 
	.word 4
	.word 6
	.word 12
d5:
	.word 4
	.word 18
	.word 16 
d6:
	.word 8
	.word 0
	.word 20
d7:
 	.word 8
	.word 3
	.word 21

