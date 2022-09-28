<a id="inicio"></a>
## Mi Sistemas digitais - Problema 1

Este documento mostra os detalhes de implementação de um
temporizador feito em linguagem assembly na arquitetura
ARMv6. 

O projeto consiste em um timer que é exibido em um display 
LCD 16x2 e possui  funcionalidades de controle a partir
de botões, como:

- Iniciar contagem;
- Pausar contagem;
- Reiniciar contagem para o tempo inicial definido.
### Membros do grupo
  **Jacob Santana**<br>
  **Sergivaldo Junior**
## Seções 

&nbsp;&nbsp;&nbsp;[**1.** Softwares utilizados](#secao1)

&nbsp;&nbsp;&nbsp;[**2.** Informações do computador usado para os testes](#secao2)

&nbsp;&nbsp;&nbsp;[**3.** Configuração e instalação do projeto](#secao3)

&nbsp;&nbsp;&nbsp;[**4.** Instruções usadas para a criação dos códigos](#secao4)

&nbsp;&nbsp;&nbsp;[**5.** Testes realizados](#secao5)

&nbsp;&nbsp;&nbsp;[**6.** Limitações da solução desenvolvida](#secao6)

&nbsp;&nbsp;&nbsp;[**7.** Materiais utilizados no desenvolvimento](#secao7)

<a id="secao1"></a>
## Ferramentas utilizadas

Para o processo de desenvolvimento do sistema foram utilizadas as seguintes ferramentas:

**GNU Makefile**: O makefile determina automaticamente quais partes de um programa grande precisam ser recompiladas e emite comandos para compilar novamente. Inicialmente deve ser escrito um arquivo chamado makefile que descreve os relacionamentos entre os arquivos do programa e fornece comandos para atualizar cada arquivo. Em um programa, normalmente, o arquivo executável é atualizado a partir de arquivos de objeto, que por sua vez são feitos pela compilação de arquivos de origem
Uma vez que existe um makefile adequado, cada vez que alguns arquivos de origem são alterados, apenas o comando “make” é suficiente para realizar todas as recompilações necessárias.

**GNU Binutils**: O ***Binutils*** é uma coleção de ferramentas binárias. Neste software se encontra o GNU assembler (as) que foi utilizado para montar os códigos assembly, além do  GNU linker(ld) que combina vários arquivos objetos, realoca seus dados e vincula referências de símbolos, fazendo por último a criação do executável do programa.

**GDB**: É o depurador de nível de fonte GNU que é padrão em sistemas linux (e muitos outros unix). O propósito de um depurador como o GDB é permitir ver o que está acontecendo “dentro” de outro programa enquanto ele é executado, ou o que outro programa estava fazendo no momento em que travou. Ele pode ser usado tanto para programas escritos em linguagens de alto nível como C e C++ quanto para programas de código assembly.

**QEMU** e **CPUlator**: O ***QEMU*** implementa um emulador de processador, permitindo uma virtualização completa de um sistema PC dentro de outro. O ***CPUlator*** também é um emulador online de processador que conta ainda com a simulação de alguns periféricos como leds, botões e dip switches. Os dois foram utilizados para simular a arquitetura ARM. No primeiro foi utilizado uma simulação do ARMv6, a mesma arquitetura da máquina utilizada, o que ajudou bastante em pequenos códigos que não necessitavam da utilização das GPIOs. O segundo emula o ARMv7, apesar de ser uma arquitetura diferente da utilizada nos testes, foi bem útil para práticar o uso da linguagem.


<a id="secao2"></a>
## Informações do computador usado para os testes

O computador utilizado para os testes foi a Raspberry PI Zero W. Esse dispositivo conta com arquitetura arm que foi utilizada para a 
construção do código assembly.

Características da Raspberry PI Zero W utilizada:

- Chip Broadcom BCM2835, com processador ARM1176JZF-S 1GHz single core;
- O processador conta com arquitetura ARMv6.
- 512MB de memória LPDDR2 SDRAM;


Além da Raspberry PI Zero W, alguns periféricos foram utilizados para o desenvolvimento do sistema, são eles:
- Display LCD: HD44780U (LCD-II);
- Botão tipo push-button.

<a id="secao3"></a>
## Configuração e instalação do projeto

#### Passo 1: Clonando o Projeto
Primeiramente, clone o repositório utilizando o
comando abaixo:

&nbsp;&nbsp;&nbsp; `git clone <repository-url>`

#### Passo 2: Gerando executável com o make
Abra o diretório em que o projeto foi salvo em seu computador, entre no terminal e execute o seguinte comando:

&nbsp;&nbsp;&nbsp;`make`

O código acima irá executar makefile responsável
por gerar os arquivos objetos e um binário executável para
que a aplicação possa ser iniciada.

#### Passo 3: Iniciando Temporizador
Para iniciar o programa, use a seguinte instrução no terminal:

&nbsp;&nbsp;&nbsp;`sudo ./main`

<a id="secao4"></a>
## Instruções utilizadas
Para o desenvolvimento da aplicação foram utilizadas de diversas instruções assembly, desde instruções aritméticas, lógicas, movimentação de dados, entre outras que serão mostradas. As instruções seguem um formato, por exemplo, as instruções de operação são escritas da assim: `op{cond}{S} Rd, Rn, Operand2`, algumas se diferenciam em relação a quantidade de operandos ou por não guardar resultados em um registrador entre outras coisas. De forma mais detalhada, as instruções podem conter os seguintes elementos:
- `op`- Mnemonico da operação a ser feita.
- `{cond}` - Condição opcional para execução da instrução.
- `{S}` - Sufixo opcional para atualizar as flags de condição de acordo com o resultado da operação.
- `Rd` - Registrador destino onde o resultado de uma operação é salvo.
- `Rn` - Registrador que contém o primeiro operando.
- `Rm` - É um registrador ARM contendo o endereço de para onde fazer o desvio.
- `Operand2` - É o segundo operando, sendo esse flexível. Logo, pode ser utilizado neste operando um valor imediato ou um registrador.
- `label` - É um rótulo referente a um trecho de código.

Abaixo segue a tabela com as instruções que foram utilizadas no código assembly do programa:

|      Instrução     	|                                                                             Descrição                                                                             	|
|:------------------:	|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------:	|
|        `MOV`       	|                              Move o valor do operando para o registrador destino. Podendo ser um valor imediato ou de um registrador.                             	|
|        `ADD`       	|                                             Soma o valor dos operandos e armazena o resultado  no registrador destino.                                            	|
|        `SUB`       	|                                 Subtrai do primeiro operando o valor do operando 2 e  armazena o resultado no registrador destino.                                	|
|        `AND`       	|                                    Faz uma operação and bit a bit nos operandos e  armazena o resultado no registrador destino.                                   	|
|        `ORR`       	|                                    Faz uma operação or bit a bit nos operandos e  armazena o resultado no registrador destino.                                    	|
|        `CMP`       	|                                                Compara o valor no registrador do primeiro operando  com Operando2.                                                	|
|        `LDR`       	|                                                            Carrega dados da memória em um registrador.                                                            	|
|        `STR`       	|                                                           Armazena o dado de um registrador na memória.                                                           	|
|        `SWI`       	|                                    Faz uma interrupção de software. Foi utilizado  para fazer chamadas ao sistema operacional.                                    	|
|        `LSL`       	| Faz um deslocamento lógico à esquerda. O LSL fornece o valor de um registrador multiplicado por uma potência de dois,  inserindo zeros nas posições de bit vagas. 	|
|        `BIC`       	|       A instrução BIC (BIT Clear) realiza uma operação  AND nos bits em Rn(Operando 1) com os complementos dos bits correspondentes no valor de Operando 2.       	|
|         `B`        	|                                                      A instrução B causa um desvio para uma parte do código.                                                      	|
|        `BL`        	|                             A instrução BL copia o endereço da próxima instrução em r14 (LR) e faz o desvio para uma parte do código.                             	|
|        `BX`        	|                                                   A instrução BX causa um desvio para o endereço mantido em Rm.                                                   	|
|     `.include`     	|                                                                Inclui arquivos externos ao código.                                                                	|
|       `.equ`       	|                                                                     Define um valor constante.                                                                    	|
| `.macro` e `.endm` 	|                                     Cria uma rotina com um trecho de código que pode ser chamada em qualquer parte do programa                                    	|
|        `LSR`       	|    Faz um deslocamento lógico à direita. O LSL fornece o valor de um registrador dividido por uma potência de dois,  inserindo zeros nas posições de bit vagas.   	|
|       `.data`      	|                                                              Define uma seção de dados para o código.                                                             	|
|       `.word`      	|                                                              Define uma palavra de dados de 4 bytes.                                                              	|
|      `.asciz`      	|                                                              Define uma string seguida por 1 byte 0.                                                              	|
|      `.ltorg`      	|                                                              Usado em rotinas muito grandes para fazer com que o offset de instruções como LDR fique dentro do seu intervalo (+/- 4095).|

Em algumas das instruções acima(ADD,B,BL,SUB e MOV) foram utilizadas condições de execução. Segue abaixo a lista das que foram usadas:
- `EQ` - Compara se é igual.
- `LT` - Compara se é menor que.

<a id="secao5"></a>

## Testes realizados 

Nos testes realizados pode-se notar que os resultados obtidos
cumprem os requisitos solicitados, mas com algumas ressalvas que 
são melhor detalhadas na sessão de [limitações do projeto](#secao6).

#### Estado inicial

No estado inicial do programa, a mensagem "Aperte o botão" é exibida no display lcd e a aplicação entra em um loop até que seja feito 
uma interação com o botão responsável pelo início da contagem.

#### Contagem do temporizador
Nesse estado o temporizador é decrementado em um a cada 1 segundo, começando do valor que foi declarado como primário, dentro de uma faixa de números de 0 a 9999.
Junto com os dígitos do temporizador é imprimida a mensagem "Contando".

#### Pause

Um segundo após o botão de pausar ser pressionado o programa para a contagem, a mensagem "pausado" é exibida no display e a aplicação entra em um loop até que o botão de início seja pressionado ou o de reinício da contagem.

#### Reinicio da contagem

Independente do sistema estar pausado ou contando, quando pressionado o botão de reinício o programa volta para o estado inicial e o temporizador volta para o tempo de início que foi definido. Pode-se notar que quando pressionado e mantido segurado, esse processo é repetido sempre a cada um segundo, mesmo o sistema já tendo sido reiniciado.

Abaixo algumas imagens e vídeos dos dos estados descritos anteriormente:

##### Contando de 0 a 9 e reiniciando ao zerar.

[contando 0 a 9](https://user-images.githubusercontent.com/72475500/192684509-d474fa05-2ce9-4fc3-8ba8-44cf737c61dc.mp4)

##### Contando e pausando.

[pausando](https://user-images.githubusercontent.com/72475500/192685506-5911db25-e587-4db3-bbed-676197df7a25.mp4)

##### Contando e reiniciando.
[reiniciando](https://user-images.githubusercontent.com/72475500/192685818-d47a0078-0a06-4966-996b-5034e624ba93.mp4)

<a id="secao6"></a>
## Limitações da solução desenvolvida

#### Número máximo de 4 dígitos

A solução utilizada é interessante por um lado, pois não salva o número em si no registrador e sim os seus dígitos, cada um em um registrador.
Isso faz com que se houver registradores disponíveis, pode-se utilizar de números com mais dígitos. Visto que a base utilizado é a decimal, um dígito nunca 
passará de nove como número máximo, fazendo com que nunca seja ultrapassado o valor suportado pelo registrador (um número de 8 bits, se tratando de valores imediatos).

Por depender de registradores disponíveis para acrescentar mais dígitos a um número, essa solução acaba ficando limitada, já que a quantidade de registradores disponíveis é finita. Além disso, a complexidade e tamanho do código vai aumentando a cada dígito adicionado já que é necessário o uso de branchs para verificar se todos os dígitos chegaram a zero para parar o temporizador. 

Uma possível solução ao problema do limite de registradores seria a utilização da pilha de memória para salvar o valor de cada dígito, mas ainda assim, o problema de complexidade e tamanho do código irá persistir.

#### Ação dos botões só funciona após 1 segundo

Para que o temporizador decremente seu valor a cada 1 segundo foi utilizada chamada de sistema NanoSleep para fazer com que o processador durma, causando um delay de 1 segundo após a subtração do valor e atualização da informação no display. A solução funciona bem se tratando da exibição a cada segundo do novo valor no display, no entanto o uso do NanoSleep compromete o funcionamento dos botões, pois naquele segundo em que o processador está dormindo esses periféricos ficam inutilizaveis.

Com o uso de interrupções esse problema pode ser resolvido, fazendo com que o chamada de sistema seja interrompida e a função do sistema seja executada.

#### Se mantidos pressionados, os botões ficam sempre mudando o estado do programa

A verificação do sinal dos botões é feita com o registrador de nível dos pinos GPIO, então se o valor do bit responsável pelo botão no registrador é 0 (o botão manda nivel baixo ao ser pressionado) e então o programa é mudado para outro estado (contando, pausado ou inicio). O problema acontece quando o botão é mantido pressionado, como o nível do botão atende a condição de verificação a mudança de estado ocorre sem parar. Por exemplo, se o temporizador está contando e o botão de pause é pressionado e mantido esses dois estados ficarão sempre alternando. O vídeo abaixo mostra essa situação acontecendo:


[bug pause](https://user-images.githubusercontent.com/72475500/192684619-63dab28a-c984-401f-997c-864f2cd98c06.mp4)

Uma possível solução para isso seria em vez de verificar o nível do pino, verificar se ocorreu uma transição de borda de subida ou descida, dessa forma o estado do programa só irá mudar em um determminada situação e não sempre.

<a id="secao7"></a>
## Materiais utilizados no desenvolvimento

&nbsp;&nbsp;&nbsp;[BCM2835 ARM Peripherals](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf)

&nbsp;&nbsp;&nbsp;[ARM1176JZF-S Technical Reference Manual](https://developer.arm.com/documentation/ddi0301/h?lang=en)

&nbsp;&nbsp;&nbsp;[Linux system Calls - ARM 32bit EABI](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#arm-32_bit_EABI)

&nbsp;&nbsp;&nbsp;[HD44780U (LCD-16x2)](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)

&nbsp;&nbsp;&nbsp;[Stephen Smith - Raspberry Pi Assembly Language
&nbsp;&nbsp;&nbsp;Programming
](https://link.springer.com/book/10.1007/978-1-4842-5287-1)

&nbsp;&nbsp;&nbsp;[GNU Assembler Directives](https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html)

<hr/>

#### ⬆️ [Voltar ao topo](#inicio)

