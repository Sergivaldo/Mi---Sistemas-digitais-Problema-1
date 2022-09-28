.equ nano_sleep, 162  @ Número da chamada nano_sleep
.equ level, 52        @ Offset do registrador de nível das gpios

.include "gpio.s"
.include "lcd.s"

.global _start        

@ Macro para fazer a chamada de sistema nano sleep
@
@ Parâmetros
@ time - tempo que o processador irá dormir.
.macro nanoSleep time
        LDR R0,=\time      
        LDR R1,=\time        
        MOV R7, #162  
        SWI 0                
.endm

@ Macro para verificar o nível do pino
@ Recebe o pino que vai ser verificado
.macro reg_lvl_verify pin
	LDR R9,[R8,#level] @ Carrega em R9 o valor de R8 deslocado para o offset do registrador de nível (52)
    	AND R10,R9,\pin    @ Faz uma operação lógica and para pegar apenas o bit do pino que foi passado.
    	CMP R10,#0         @ Compara se o valor de R10 é igual a 0
.endm

@ Macro para definor o valor inicial do temporizador 
.macro set_init_val mil,cen,dez,uni @ Passa cada digito do valor inicial como parametro
        MOV R6,#\uni                    @ Move o hexadecimal da unidade para o R6
        MOV R5,#\dez                    @ Move o hexadecimal da dezena para o R5
        MOV R12,#\cen                   @ Move o hexadecimal da centena para o R12
        MOV R4,#\mil                    @ Move o hexadecimal do milhar para o R4
.endm

@ branch para exibir a mensagem inicial "Aperte o Botao"
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

@ branch para exibir a mensagem de pause "Pausado"
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

@ Macro para exibir a mensagem "Contando:" durante a contagem.
.macro msg_counter
	SUB SP,#4	@ Subtrai 4 do registrador SP para ter espaço na pilha
	STR R6,[SP,#0] @ Armazena na pilha o valor do registrador R6

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
        
@ Branch responsável por fazer a contagem
counter:
        CMP R6,#0x30 
        SUBLT R5,#1          @ Se R6 for menor que #0x30, irá subtrair 1 do R5
        MOVLT R6,#0x39       @ Se R6 for menor que #0x30, Retorna o R6 para #0x39
        
        CMP R5,#0x30     
        SUBLT R12,#1         @ Se R5 for menor que #0x30, irá subtrair 1 do R12
        MOVLT R5,#0x39       @ Se R5 for menor que #0x30, Retorna o R5 para #0x39
        
        CMP R12,#0X30
        SUBLT R4,#1          @ Se R12 for menor que #0x30, irá subtrair 1 do R4
        MOVLT R12,#0X39      @ Se R12 for menor que #0x30, Retorna o R12 para #0x39
        
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
        reg_lvl_verify R11     
        BEQ msg_pause          @
        
        MOV R11,#1             @
        LSL R11,#19            @
        reg_lvl_verify R11     
        BEQ msg_in             @
        
        CMP R6, #0x30          @ Compara a unidade com o hexadecimal 30
        BLEQ dez_is_zero       @ Se for igual devia para a comparação da dezena
        
        SUB R6,#1              @ Subtrai 1 do registrador que esta contando as unidades
        B counter              @ Reinicia o loop do contador

@ Branch inicial que espera uma interação com o botão de inicio/pause ou reinicio
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

@ Branch de pause que espera uma interação com o botão de inicio/pause ou reinicio
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

@ Verificar se a centena é igual a zero
cen_is_zero:
        CMP R12,#0x30
        BEQ mil_is_zero
        
        BX LR

@ Verificar se o milhar é igual a zero
mil_is_zero:
        CMP R4,#0x30
        BEQ msg_in
        
        BX LR

_start:
        memory_map @ Faz o mapeamento da memória virtual
        setOut @ Define os pinos do LCD como saída
		@ Define o modo de operação do display para 4 bits
        fset
        fset
        fset
        fset
		
        display 1, 1, 1 @ Define o cursor para ligado, o display para ligado e o cursor para piscar
        entrymode 0, 0 @ Define que sempre que algo for escrito o cursor será movido para a direita
        
        B msg_in
    
@ Branch para finalizar o programa
_end:
        MOV R7, #1 
        SWI 0 
		
.data

fileName: .asciz "/dev/mem" @ Caminho do arquivo para mapeamento da memória virtual
gpioaddr: .word 0x20200 @ Offset na memória física da área a ser mapeada

time1s:
	.word 1 @ Tempo em segundos
	.word 000000000 @ Tempo em nanossegundos

time500ms:
	.word 0 @ Tempo em segundos
	.word 500000000 @ Tempo em nanossegundos
time1ms:
	.word 0 @ Tempo em segundos
	.word 1500000 @ Tempo em nanossegundos

@ Lcd

rs:
	.word 8 @ offset para selecionar o registrador de função
	.word 15 @ offset do pino no registrador de função
	.word 25 @ offset do pino no registrador de set e clear
e:
	.word 0 @ offset para selecionar o registrador de função
	.word 3 @ offset do pino no registrador de função
	.word 1 @ offset do pino no registrador de set e clear
d4: 
	.word 4 @ offset para selecionar o registrador de função
	.word 6 @ offset do pino no registrador de função
	.word 12 @ offset do pino no registrador de set e clear
d5:
	.word 4 @ offset para selecionar o registrador de função
	.word 18 @ offset do pino no registrador de função
	.word 16 @ offset do pino no registrador de set e clear 
d6:
	.word 8 @ offset para selecionar o registrador de função
	.word 0 @ offset do pino no registrador de função
	.word 20 @ offset do pino no registrador de set e clear
d7:
 	.word 8 @ offset para selecionar o registrador de função
	.word 3 @ offset do pino no registrador de função
	.word 21 @ offset do pino no registrador de set e clear

