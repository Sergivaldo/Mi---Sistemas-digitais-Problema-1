<a id="inicio"></a>
## Mi Sistemas digitais - Problema 1

Este documento mostra os detalhes de implementação de um
temporizador feito em linguagem assembly na arquitetura
ARMv6. 

O projeto consiste timer que é exibido em um display 
LCD 16x2 e possui  funcionalidades de controle a partir
de botões, como:

- Iniciar contagem;
- Pausar contagem;
- Reiniciar contagem para o tempo inicial definido.

## Seções 

&nbsp;&nbsp;&nbsp;[**1.** Softwares utilizados](#secao1)

&nbsp;&nbsp;&nbsp;[**2.** Informações do computador usado para os testes](#secao2)

&nbsp;&nbsp;&nbsp;[**3.** Configuração e instalação do projeto](#secao3)

&nbsp;&nbsp;&nbsp;[**4.** Instruções usadas para a criação dos códigos](#secao4)

&nbsp;&nbsp;&nbsp;[**5.** Testes realizados](#secao5)

&nbsp;&nbsp;&nbsp;[**6.** Limitações da solução desenvolvida](#secao6)

&nbsp;&nbsp;&nbsp;[**7.** Materiais utilizados no desenvolvimento](#secao7)

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

<a id="secao5"></a>

## Testes realizados 

Nos testes realizados pode-se notar que os resultados obtidos
cumprem os requisitos solicitados, mas com algumas ressalvas que 
são melhor detalhadas na sessão de [limitações do projeto](#secao6).

#### Estado inicial

No estado inicial do programa, a mensagem "Aperte o botão" é exibida no display lcd e a aplicação entra em um loop até que seja feito 
uma interação com o botão responsável pelo início da contagem.

##### Contagem do temporizador
Nesse estado o temporizador é decrementado em um a cada 1 segundo, começando do valor que foi declarado como primário, dentro de uma faixa de números de 0 a 9999.
Junto com os dígitos do temporizador é imprimida a mensagem "Contando".

#### Pause

Um segundo após o botão de pausar ser pressionado o programa para a contagem, a mensagem "pausado" é exibida no display e a aplicação entra em um loop até que o botão de início seja pressionado ou o de reinício da contagem.

#### Reinicio da contagem

Independente do sistema estar pausado ou contando, quando pressionado o botão de reinício o programa volta para o estado inicial e o temporizador volta para o tempo de início que foi definido. Pode-se notar que quando pressionado e mantido segurado, esse processo é repetido sempre a cada um segundo, mesmo o sistema já tendo sido reiniciado.

Abaixo algumas imagens e vídeos dos dos estados descritos anteriormente:



<IMAGENS E VÍDEOS AQUI>



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


<VÍDEO AQUI>


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

