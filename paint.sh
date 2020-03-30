#!/bin/bash


#---------------Variáveis
path="$HOME/paint"
cor='\e[107m'	#Cor atual / Usada para pintar
n='0' #Valor inserido no nome caso seja salvo mais de 1 vez
#------------------------

#------------Verificações
#Verifica dependências
[ ! -n "$(which curl)" ] &&	echo "Curl não instalado - Função de upload não funcionará"
[ ! -n "$(which scrot)" ] && echo "Scrot não instalado - Não será possível salvar desenho" 
[ ! -n "$(which xterm)" ] && echo "Xterm não instalado - Possível que o programa não funcione"

#Verifica diretório paint existe
if [ ! -d $HOME/paint ] ; then
	echo -e "Não foi encontrado o diretório do programa \nCriando em ${HOME}/paint \n\n"
    mkdir $HOME/paint 2> /dev/null || { echo -e "Não foi possível criar o diretório" ; exit;}
fi

#Verifica existencia de arquivo de configuração
if [ ! -e $HOME/paint/config.txt ] ; then
	echo -e "Criando arquivo de configurações em ${HOME}/paint/config.txt"
	cat > $HOME/paint/config.txt << END
	# Movimentação
cima='w'
baixo='s'
esquerda='a'
direita='d'

	# Ações
pintar='p'
salvar='g'

	# Pincel
pincel='  '	# tamanho que será pintado pelo pincel

	# Cores
cor0='\e[49m'	# borracha
cor1='\e[40m' 	# preto
cor2='\e[107m'	# branco
cor3='\e[41m'	# vermelho
cor4='\e[42m'	# verde
cor5='\e[43m'	# amarelo
cor6='\e[44m'	# azul
cor7='\e[45m'	# magenta
cor8='\e[46m'	# ciano

	# Nome das Cores (para apresentar o que cada tecla representa)
cname0='borracha'
cname1='preto'
cname2='branco'
cname3='vermelho' 
cname4='verde'
cname5='amarelo'
cname6='azul'
cname7='magenta'
cname8='ciano'

	# API key imagebin
# Função para upload
key=
END
	[ "$?" -eq '0' ] && { source ${path}/config.txt 
	echo -e "\nArquivo de configuração criado, edite-o para adicionar API Key do imagebin para ter a função de upload"
	read -p "Pressione ENTER para prosseguir" null ;}
fi
#------------------------

#------Processos Iniciais

printf '\e[2J\e[H' #Limpa tela
source ${path}/config.txt #importando configurações

#------------------------

#-----------------Funções
_TITULO(){
printf '\e[2J\e[H' #Limpa tela
echo -e "
$cor1┌─┐$cor2┌─┐$cor3┬$cor4┌┐┌$cor5┌┬┐$cor0	$cor6┌─┐$cor7┬ ┬
$cor1├─┘$cor2├─┤$cor3│$cor4│││$cor5 │ $cor0	$cor6└─┐$cor7├─┤
$cor1┴  $cor2┴ ┴$cor3┴$cor4┘└┘$cor5 ┴ $cor0	$cor6└─┘$cor7┴ ┴$cor0
"
}

_CABECALHO(){


cat << END

	Opções

  1 - Novo Desenho
  2 - Editar Configurações
  3 - Ver Informações

  0 - Sair

END
}

_CONTROLES(){
	cat > ${path}/controles.txt << END

	Movimentação
Cima     - $cima
Baixo    - $baixo
Direita  - $direita
Esquerda - $esquerda

	Ação
Pintar 	 - $pintar
Salvar 	 - $salvar

	Cores
$cname0 - 0
$cname1	 - 1
$cname2	 - 2
$cname3 - 3
$cname4	 - 4
$cname5  - 5
$cname6     - 6
$cname7  - 7
$cname8    - 8

	Comandos
:u       - Fazer upload desenho 
:q       - Sai do paint

Exemplo: :uq

END
xterm -e less controles.txt & # Abre os controles em outra tela
}

_SAVE(){
	if [ -e "$path/${name}.png" ]; then
		n="$(($n + 1))"
		name="${name}${n}"
	fi
	scrot -u "${name}.png" -e 'mv $f ~/paint/'
}

_UPLOAD() {
	if [ ! -n "$key" ]; then
		echo "Upload desabilitado"
	else
		curl -s -F key="${key}" -F file="@${path}/${name}.png" https://imagebin.ca/upload.php | grep "url" | cut -d: -f 2,3
	fi	
} 

#------------------------

#------------------Início
while : ; do
	_TITULO
	_CABECALHO
	read -p "Escolha uma opção: " o

	case $o in

		1) # Novo Desenho
			while : ; do #Inserção de nome válido e não existente
				read -p "Digite o nome do desenho: " name
				if [ -e "$path/${name}.png" ] ; then
					echo -e "\nNome existente, digite outro.\n" 
				else
					break
				fi
			done

			printf '\e[2J\e[H' #Limpa tela
			_CONTROLES
			while : ; do
				read -sn 1 d
				case $d in
					"$cima") printf '\e[A' ;;		#Move cursor para cima

					"$baixo") printf '\e[B' ;;		#Move cursor para baixo

					"$esquerda") printf '\e[D' ;;	#Move cursor para esquerda

					"$direita")	printf '\e[C' ;;	#Move cursor para direita

					"$pintar")
						printf '\e7'				#Salva posição cursor
						echo -e "${cor}${pincel}" 	#Realiza a pintura
						echo -e "${default}"
						printf '\e8'				#Carrega posição cursor
					;;
					
					"$salvar")
						_SAVE && {
						printf '\e7'	#Salva posição cursor
						printf '\e[10000B' #Move cursor para o fim da tela
						printf '\e[10000D' #Move cursor para o canto esquerdo
						printf "Arquivo salvo em: $path/${name}.png"
						printf '\e8'	#Carrega posição cursor	
						}
					;;

					#Define a cor a ser usada
					0) cor="${cor0}" 		;;
					1) cor="${cor1}" 		;;
					2) cor="${cor2}" 		;;
					3) cor="${cor3}" 		;;
					4) cor="${cor4}" 		;;
					5) cor="${cor5}" 		;;
					6) cor="${cor6}" 		;;
					7) cor="${cor7}" 		;;
					8) cor="${cor8}" 		;;

					:) 	#Seção de comandos de gerenciamento do desenho
						printf '\e[10000B' #Move cursor para o fim da tela
						printf '\e[10000D' #Move cursor para o canto esquerdo
						read -r -p ':' comando
						echo "$comando" | grep -Eio "[^uq]"
						if [ "$?" -eq '0' ]; then #Verifica se foi inserido comando errado
							echo "Erro"
							printf '\e8'
						else
							for i in $(echo $comando | awk '$1=$1' FS= OFS=" "); do #Realiza o processamento dos comandos
								[[ "${i,,}" == 'u' ]] && _UPLOAD
								[[ "${i,,}" == 'q' ]] && exit
							done
						fi
					;;

					*) #Evitar pressionar tecla inexistente 
						printf '\e7'	#Salva posição cursor
						printf '\e8'	#Carrega posição cursor
					;;

				esac
			done
		;;

		2) nano ${path}/config.txt ;; # Editar Configurações

  		3) less ${path}/info.txt ;;   # Ver Informações

  		0) exit ;; #Sair
		
		*) echo -e "Valor inválido. \n" ;;
	
	esac
done