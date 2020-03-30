# Paint CLI
  Esse programa é um paint feito em sh, que permite seja feito desenhos pixealizados no próprio terminal.
  Caso o programa não apresente as cores corretamente quando é pintado, pode ser pelo fato de que você
tenha customizado as cores do terminal, verifique o arquivo .Xresources caso isso ocorra.


### Exemplo
  Desenho feito utilizando o programa.
  
<img src="https://i.imgur.com/9GP27uz.png" align="center" height="500px">


### Instalação
  Basta baixar os arquivos, criar um diretório '$HOME/paint' e mover todos os arquivos, em seguida dar
permissão de execução `chmod +x paint.sh` e rodar o programa.


### Custominização
  Caso queira trocar as cores basta trocar o valor do fundono arquivo config.txt e renomear a cor em 
'cnmae<valor>'.
  Sobre o pincel, é basicamente a quantidade de 'pixels' que serão pintados a cada vez que utilizar a 
ação pintar.


### Funcionamento
  Basicamente é utilizado o cursor do terminal para apontar qual será o "pixel" que seraá pintado, 
dessa forma é trocada a cor de fundo da posição selecionada, pintando assim o terminal.
  As imagens são salvas em formato .png, que serão sempre armazenadas no diretório ~/paint. É possível 
salvar um desenho mais de uma vez, pois será adicionar um valor no final, sem que o desenho fique 
sobrescrito.
  O upload é feito utilizando a API do imagebin, ou seja, é necessário inserir a sua key dentro do 
arquivo config.txt para que seja possível postar a sua imagem e receber um link.


### Dica
  Caso queira pintar todo o fundo antes de começar, coloque o cursor no final do terminal e fique 
pressionando o botão de pintar.


### Dúvidas & Sugestões
  Entre em contato com o seguinte e-mail: felipefernandesgsc@gmail.com
  Ou pelo Discord: Mewbi#5028
