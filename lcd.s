.macro enable
        GPIOTurn e, #0
        nanoSleep time1ms

        GPIOTurn e,#1
        nanoSleep time1ms

        GPIOTurn e, #0
        nanoSleep time1ms
        .ltorg
.endm

.macro setOut
        GPIODirectionOut e
        GPIODirectionOut rs
        GPIODirectionOut d7
        GPIODirectionOut d6
        GPIODirectionOut d5
        GPIODirectionOut d4
.endm

@ Macro para setar o modo de operação do display para 4 bits.
@
@ Descrição do código:
@
@ MOV R1,#valor_do_pino - Move para R0 o valor para limpar ou ativar o pino
@ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
@ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

.macro fset
        @ MOV R1,#valor_do_pino - Move para R0 o valor para limpar ou ativar o pino
        @ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
        @ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

        GPIOTurn rs,#0

        GPIOTurn d7,#0

        GPIOTurn d6,#0

        GPIOTurn d5, #1

        GPIOTurn d4, #0

        enable
        .ltorg
.endm

.macro display d,c,b
        @ MOV R1,#valor_do_pino - Move para R0 o valor para limpar ou ativar o pino
        @ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
        @ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

        GPIOTurn rs,#0

        GPIOTurn d7,#0

        GPIOTurn d6, #0

        GPIOTurn d5,#0

        GPIOTurn d4, #0

        enable

        GPIOTurn rs, #0

        GPIOTurn d7,#1

        GPIOTurn d6,#\d

        GPIOTurn d5,#\c

        GPIOTurn d4,#\b

        enable

        .ltorg
.endm

.macro entrymode i_d, s
        @ MOV R1,#valor_do_pino - Move para R0 o valor para limpar ou ativar o pino
        @ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
        @ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

        GPIOTurn rs, #0

        GPIOTurn d7,#0

        GPIOTurn d6,#0

        GPIOTurn d5,#0

        GPIOTurn d4,#0

        enable

        GPIOTurn rs,#0

        GPIOTurn d7,#0

        GPIOTurn d6,#1

        GPIOTurn d5,#\i_d

        GPIOTurn d4,#\s

        enable

        .ltorg
.endm


@ Macro para limpar o display LCD.
@
@ Descrição do código:
@
@ MOV R1,#valor_do_pino - Move para R0 o valor para limpar ou ativar o pino
@ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
@ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

.macro clearLcd

        GPIOTurn rs,#0

        GPIOTurn d7,#0

        GPIOTurn d6,#0

        GPIOTurn d5,#0

        GPIOTurn d4,#0

        enable

        GPIOTurn rs,#0

        GPIOTurn d7,#0

        GPIOTurn d6,#0

        GPIOTurn d5,#0

        GPIOTurn d4,#1

        enable
        .ltorg
.endm


@ Macro para escrever um caractere no display
@
@ Parâmetros:
@ R3 - Mapeamento do pino
@
@ Descrição do código:
@
@ MOV R0,#posicao_bit - Move para R0 a posição do bit
@ BL get_bit - Desvia  para branch get_bit e pega o bit da posição passada.
@ LDR R3,=mapeamento_pino - Carrega em R3 o mapeamento do pino
@ BL GPIOTurn - Desvia para a branch GPIOTurn para ativar ou limpar o pino.

.macro write hex
        MOV R6, \hex

        GPIOTurn rs, #1

        MOV R0,#7
        BL get_bit
        GPIOTurn d7, R1

        MOV R0,#6
        BL get_bit
        GPIOTurn d6, R1

        MOV R0,#5
        BL get_bit
        GPIOTurn d5, R1

        MOV R0,#4
        BL get_bit
        GPIOTurn d4, R1

        enable

        GPIOTurn rs, #1

        MOV R0,#3
        BL get_bit
        GPIOTurn d7, R1


        MOV R0,#2
        BL get_bit
        GPIOTurn d6, R1


        MOV R0,#1
        BL get_bit
        GPIOTurn d5, R1


        MOV R0,#0
        BL get_bit
        GPIOTurn d4, R1

        enable
        .ltorg
.endm

get_bit:
        MOV R2,#1 @ Move 1 para o registrador R0
        LSL R2,R0 @ Desloca para esquerda o valor em R2 para a posição do bit passado em R0
        AND R1, R6,R2 @ Realiza a operação lógica and para que seja pego apenas o bit desejado
        LSR R1,R0 @ Desloca para o bit menos significativo o bit da posição desejada

        BX LR