
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

Um segundo após o botão de pausar ser pressionado o programa para a contagem, a mensagem "pausado" é exibida no display e a aplicação entra em um loop até que o botão de início seja pressionado ou o de reinício da contagem. Se o botão for 

#### Reinicio da contagem

Independente do sistema estar pausado ou contando, quando pressionado o botão de reinício o programa volta para o estado inicial e o temporizador volta para o tempo de início que foi definido. Pode-se notar que quando pressionado e mantido segurado, esse processo é repetido sempre a cada um segundo, mesmo o sistema já tendo sido reiniciado.

Abaixo algumas imagens e vídeos dos dos estados descritos anteriormente:

## Materiais utilizados no desenvolvimento

&nbsp;&nbsp;&nbsp;[BCM2835 ARM Peripherals](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf)

&nbsp;&nbsp;&nbsp;[ARM1176JZF-S Technical Reference Manual](https://developer.arm.com/documentation/ddi0301/h?lang=en)

&nbsp;&nbsp;&nbsp;[Linux system Calls - ARM 32bit EABI](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#arm-32_bit_EABI)

&nbsp;&nbsp;&nbsp;[HD44780U (LCD-16x2)](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)

&nbsp;&nbsp;&nbsp;[Stephen Smith - Raspberry Pi Assembly Language
&nbsp;&nbsp;&nbsp;Programming
](https://link.springer.com/book/10.1007/978-1-4842-5287-1)

&nbsp;&nbsp;&nbsp;[GNU Assembler Directives](https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html)
