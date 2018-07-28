#!/bin/bash
#
# Script de migracao de um firewall antigo para um novo servidor independente da versao do linux.
# DATA - 07/10/13
#  

function MAIN()
{
	i=0
	while [ $i -ne 1 ]
	do
		MENU_PRINCIPAL
		clear
		e1=0
		e2=0
		case $M1 in
			1)
				i=1
				while [ $e1 -ne 1 ]
				do
					clear
					MENU_SEC1
					clear	
					case $M21 in
					1)
						e1=1
						echo "Executando o script de forma automatizada"
						CRIA_DIRETORIOS
						COPIA_ARQUIVOS
						;;
					2)
						e1=1
						echo "Criando os diretorios de backup"
						CRIA_DIRETORIOS
						;;
					3)
						e1=1
						echo "Copiando os arquivos para diretoriso de backup"
						COPIA_ARQUIVOS
						;;
					4)
						e1=1
						i=0
						echo "Voltando ao menu principal..."
						;;
					5)
						echo "Saindo do script..."
						exit;
						;;
					*)
						echo "Entre com uma opcao valida!"
						read -p "Precione uma tecla para voltar..."
						;;
					esac
				done
				;;
			2)
				i=1;
				while [ $e2 -ne 1 ]
				do
					clear
					MENU_SEC2
					clear
					case $M22 in
					1)
						e2=1
						echo "Executando o script de forma automatizada"
						INSTALA_PACOTES
						COPIA_BKP
						EXECUTA_RESTORE
						VERIFICA_TERMINAL
						INSTALA_TSM
						;;
					2)
						e2=1
						echo "Instalando pacotes necessarios"
						INSTALA_PACOTES
						;;
					3)
						e2=1
						echo "Copiando arquivos do servidor base"
						COPIA_BKP
						;;
					4)
						e2=1	
						echo "Fazendo restore do backup"
						EXECUTA_RESTORE
						;;
					5)
						e2=1
						VERIFICA_TERMINAL
						;;
					6)
						e2=1
						echo "Instalando TSM client"
						INSTALA_TSM
						;;
					7)
						e2=1
						i=0
						echo "Voltando ao menu principal..."
						;;
					8)
						echo "Saindo do script..."
						exit;
						;;
					*)
						echo "Entre com uma opcao valida!"
						read -p "Precione uma tecla para voltar..."
						;;
					esac
				done
				;;
			3)
				echo "Saindo do script..."
				exit
				;;
			*)
				echo "Entre com uma opcao valida!"
				read -p "Precione uma tecla para voltar..."
				;;
			esac
		done
}

function MENU_PRINCIPAL ()
{
	clear
	echo "#----------- Script de criacao de firewall --------------#"
	echo "#--------------------------------------------------------#"
	echo "#------------------ MENU PRINCIPAL ----------------------#"
	echo "#--------------------------------------------------------#"
	echo "# Em qual servidor que esta sendo executado esse script?  "
	echo "# 1 - No que sera feito o backup                          "
	echo "# 2 - No que sera feito o restore 	                "
	echo "# 3 - Sair                                                "
	read -p "# Digite a opcao desejada: " M1
}

function MENU_SEC1()
{
	echo "#-------------- Selecionado o modo BACKUP ---------------#"
	echo "# 1 - Executar de forma automatica                        "
	echo "# 2 - Criar os diretorios de backup                       "
	echo "# 3 - Copiar os arquivos de backup                        "
	echo "# 4 - Voltar ao menu principal	                        "
	echo "# 5 - Sair                                                "
	read -p "# Digite a opcao desejada: " M21 
}

function MENU_SEC2()
{
	echo "#-------------- Selecionado o modo RESTORE --------------#"
	echo "# 1 - Executar de forma automatica                        "
	echo "# 2 - Instalar pacotes necessarios                        "
	echo "# 3 - Copiar arquivos do servidor base                    "
	echo "# 4 - Fazer restore do backup                             "
	echo "# 5 - Instalar VMTOOLS                                    "
	echo "# 6 - Instalar TSM client 		                "				
	echo "# 7 - Voltar ao menu principal	                        "
	echo "# 8 - Sair			                        "
	read -p "# Digite a opcao desejada: " M22
}

function CRIA_DIRETORIOS()
{
	clear
	DIR[1]="/pacotes/"
	DIR[2]="/pacotes/bkp" 
	DIR[3]="/pacotes/bkp/bin"
	DIR[4]="/pacotes/bkp/etc"
	DIR[5]="/pacotes/bkp/etc/bandwidthd"
	DIR[6]="/pacotes/bkp/etc/dhcp"
	DIR[7]="/pacotes/bkp/etc/dhcp3"
	DIR[8]="/pacotes/bkp/etc/init.d/" 
	DIR[9]="/pacotes/bkp/etc/ipsec.d"
	DIR[10]="/pacotes/bkp/etc/network"
	DIR[11]="/pacotes/bkp/etc/ntop"
	DIR[12]="/pacotes/bkp/etc/snmp"
	DIR[13]="/pacotes/bkp/etc/ssh"
	DIR[14]="/pacotes/bkp/home" 
	DIR[15]="/pacotes/bkp/home/ipaudit"
	DIR[16]="/pacotes/bkp/home/ipaudit/bin/"
	DIR[17]="/pacotes/bkp/root"
	DIR[18]="/pacotes/bkp/sbin"
	DIR[19]="/pacotes/bkp/usr"
	DIR[20]="/pacotes/bkp/usr/local"
	DIR[21]="/pacotes/bkp/usr/local/bin"
	
	for((f=1; f<=${#DIR[@]}; f++));
	do
		echo "Criando o diretorio: ${DIR[$f]}"
		mkdir ${DIR[$f]}
	done	 
}

function COPIA_ARQUIVOS()
{
	echo ""
	echo "Copiando arquivos do /etc" 
	cp /etc/bandwidthd/bandwidthd.conf /pacotes/bkp/etc/bandwidthd/ 
	cp /etc/chamascritps /pacotes/bkp/etc/ 
	cp /etc/crontab /pacotes/bkp/etc/ 
	cp /etc/dhcp/dhcpd.conf /pacotes/bkp/etc/dhcp/ 
	cp /etc/dhcp3/dhcpd.conf /pacotes/bkp/etc/dhcp3/ 
	cp /etc/hostname /pacotes/bkp/etc/ 
	cp /etc/init.d/dhcpd /pacotes/bkp/etc/init.d/ 
	cp /etc/init.d/functions /pacotes/bkp/etc/init.d/ 
	cp /etc/init.d/iptables /pacotes/bkp/etc/init.d/ 
	cp /etc/ipsec.conf /pacotes/bkp/etc/ipsec.conf 
	cp /etc/ipsec.secrets /pacotes/bkp/etc/ipsec.secrets 
	cp /etc/network/interfaces /pacotes/bkp/etc/network/ 
	cp /etc/ntop/* /pacotes/bkp/etc/ntop/ 
	cp /etc/rc.local /pacotes/bkp/etc/ 
	cp /etc/rma.ini /pacotes/bkp/etc/ 
	cp /etc/snmp/snmpd.conf /pacotes/bkp/etc/snmp/ 
	cp /etc/ssh/ssh_config /pacotes/bkp/etc/ssh/ 
	cp /etc/ssh/sshd_config /pacotes/bkp/etc/ssh/ 

	echo ""
	echo "Copiando arquivos do /bin"
	cp /bin/fwdenyrules /pacotes/bkp/bin/ 
	cp /bin/*google* /pacotes/bkp/bin 
	cp /bin/FW* /pacotes/bkp/bin 
	cp /bin/vpn* /pacotes/bkp/bin 

	echo ""
	echo "Copiando arquivos especificos" 
	cp /home/ipaudit/bin/traffic_type /pacotes/bkp/home/ipaudit/bin 
	cp /home/ipaudit/ipaudit-web.conf /pacotes/bkp/home/ipaudit/ 
	cp /root/.bashrc /pacotes/bkp/root 
	cp /sbin/cbq /pacotes/bkp/sbin 
	cp /usr/local/bin/ios* /pacotes/bkp/usr/local/bin 

	echo ""
	echo "Copiando e compactado diretorios" 
	tar -zcf /pacotes/bkp/ipsec.d.tgz /etc/ipsec.d/* 
	tar -zcf /pacotes/bkp/ppp.tgz /etc/ppp/* 
	tar -zcf /pacotes/bkp/squid.tgz /etc/squid/* 
	tar -zcf /pacotes/bkp/vpnautomatica.tgz /etc/vpnautomatica/* 
	tar -zcf /pacotes/bkp/cbq.tgz /etc/cbq/* 
}

function INSTALA_PACOTES()
{
	PAC[1]="apache2"
	PAC[2]="gnuplot"
	PAC[3]="libtime-modules-perl"
	PAC[4]="libpcap-dev"
	PAC[5]="lynx"
	PAC[6]="rdate"
	PAC[7]="ntpdate"
	PAC[8]="bandwidthd" 
	PAC[9]="tcpdump"
	PAC[10]="iptraf"
	PAC[11]="openswan"
	PAC[12]="isc-dhcp-server"
	PAC[13]="make" 
	PAC[14]="gcc"
	PAC[15]="squid"
	PAC[16]="sysstat"
	PAC[17]="ntop" 
	PAC[18]="mc"
	PAC[19]="vim"
	PAC[20]="snmpd"
	PAC[21]="bash-completion"
	PAC[22]="linux-headers-$(uname -r)"
	PAC[23]="vlan" 
	PAC[24]="pppoeconf"
	PAC[25]="ldap-utils"

	apt-get update

	for((f=1; f<=${#PAC[@]}; f++));
	do
		clear
		echo "Baixando e instalando o pacote ${PAC[$f]}"
		echo ""
		apt-get install ${PAC[$f]} -yy
	done

	echo ""
	echo "Criando diretorio cache do Squid: /var/cache/squid"
	mkdir -p /var/cache/squid
	chown proxy:proxy /var/cache/squid
	echo ""

}
function COPIA_BKP()
{
	VALIDA_IP
	scp -P 2222 -r $IP:/pacotes/ /pacotes
}

function VALIDA_IP()
{
	ip1=0
	while [ $ip1 -ne 1 ]
	do
		clear
		read -p "Digite o IP do servidor que contem o backup dos arquivos: " IP
		VALIDA=`echo ${IP} | sed "s/[0-9\.]//g"`;
		if [ "${VALIDA}" != "" ];then
		echo ""
			echo "Voce nao digitou um corretamente o IP"
			read -p "Precione uma tecla pra voltar... "
			ip1=0
		else
			ip1=1				
		fi
		
	done
}
function EXECUTA_RESTORE()
{
	echo "Copiando arquivos do restore para o /etc"
	cp /pacotes/bkp/etc/bandwidthd/bandwidthd.conf /etc/bandwidthd/ 
	cp /pacotes/bkp/etc/chamascritps /etc/ 
	cp /pacotes/bkp/etc/crontab /etc/ 
	cp /pacotes/bkp/etc/dhcp/dhcpd.conf /etc/dhcp/ 
	cp /pacotes/bkp/etc/dhcp3/dhcpd.conf /etc/dhcp3/ 
	cp /pacotes/bkp/etc/hostname /etc/ 
	cp /pacotes/bkp/etc/init.d/dhcpd /etc/init.d/ 
	cp /pacotes/bkp/etc/init.d/functions /etc/init.d/ 
	cp /pacotes/bkp/etc/init.d/iptables /etc/init.d/ 
	cp /pacotes/bkp/etc/ipsec.conf /etc/ipsec.conf 
	cp /pacotes/bkp/etc/ipsec.secrets /etc/ipsec.secrets 
	cp /pacotes/bkp/etc/network/interfaces /etc/network/ 
	cp /pacotes/bkp/etc/ntop/* /etc/ntop/ 
	cp /pacotes/bkp/etc/rc.local /etc/ 
	cp /pacotes/bkp/etc/rma.ini /etc/ 
	cp /pacotes/bkp/etc/snmp/snmpd.conf /etc/snmp/ 
	cp /etc/ssh/ssh_config /etc/ssh/ 
	cp /pacotes/bkp/etc/ssh/sshd_config /etc/ssh/ 

	echo "Copiando arquivos do restore para o /bin"
	cp /pacotes/bkp/bin/fwdenyrules /bin/ 
	cp /pacotes/bkp/bin/*google* /bin/ 
	cp /pacotes/bkp/bin/FW* /bin/ 
	cp /pacotes/bkp/binvpn* /bin/ 

	echo "Copiando arquivos especificos para seus diretorios"
	cp /pacotes/bkp/home/ipaudit/bin/traffic_type /home/ipaudit/bin/ 
	cp /pacotes/bkp/home/ipaudit/ipaudit-web.conf /home/ipaudit/ 
	cp /pacotes/bkp/root/.bashrc /root/ 
	cp /pacotes/bkp/sbin/cbq /sbin/cbq 
	cp /pacotes/bkp/usr/local/bin/ios* /usr/local/bin/ 

	echo "Copiando e descompactando arquivos diretorios" 
	tar -zxf /pacotes/bkp/ipsec.d.tgz -C / 
	tar -zxf /pacotes/bkp/ppp.tgz -C / 
	tar -zxf /pacotes/bkp/squid.tgz -C / 
	tar -zxf /pacotes/bkp/vpnautomatica.tgz -C / 
	tar -zxf /pacotes/bkp/cbq.tgz -C / 
}

function VERIFICA_TERMINAL()
{
	TERMINAL=`tty | cut -c6-8`
	case $TERMINAL in
		"tty")	
			echo "voce esta no console"
			echo "Instalando VMTOOLS"
			INSTALA_VMTOOLS
			;;
		"pts")
			e2=1
			i=0
			AVISO_VMTOOLS
			read -p "# Precione uma tecla para voltar para o menu principal "
			;;
		*)
			t1=0
			while [ $t1 -ne 1 ]
			do
				echo "# Nao foi possivel identificar por onde voce esta logado"
				echo "# variavel terminal = $TERMINAL                         "
				echo "# Por favor identifiquei onde voce esta logado          "
				echo "# 1 - Console                                           "
				echo "# 2 - Terminal                                          "
				read -p "# Digite a opcao desejada: " TERMINAL                
				case $TERMINAL in
					1)	
						t1=1
						INSTALA_VMTOOLS
						;;
					2)
						t1=1
						e2=1
						i=0
						AVISO_VMTOOLS
						read -p "Precione uma tecla para voltar..."		
						;;
					*)
						t1=0
						echo "Digite uma opcao valida!"
						read -p "Precione uma tecla para voltar..."		
						;;
				esac
			done	
		esac
}

function AVISO_VMTOOLS()
{
	clear
	echo "#--------------------------------------------------------#"
        echo "#------------------------ AVISO -------------------------#"
        echo "#--------------------------------------------------------#"
        echo "#                                                        #"
        echo "# O VMTOOLS nao pode ser instalado via SSH               #"
        echo "# Para poder instalar execute o script via console       #"
        echo "#                                                        #"
        echo "#--------------------------------------------------------#"
        echo "" 
}

function INSTALA_VMTOOLS()
{
	echo "#--------------------------------------------------------#"
        echo "#------------------------ AVISO -------------------------#"
        echo "#--------------------------------------------------------#"
	echo "#							       #"	
	echo "# E necessario estar carregado o ISO do VMTOOLS 	       #"
	echo "# 						       #"
	echo "#--------------------------------------------------------#"
	read -p "Precione um tecla para continuar"		
	echo ""
	apt-get update 
	echo ""
	apt-get installlinux-headers-$(uname -r) 
	echo ""
	mount /dev/cdrom /media/cdrom0 
	echo ""
	cd /media/cdrom0 
	echo ""
	tar -C /tmp -zxvf VMwareTools-*.tar.gz 
	echo ""
	cd /tmp/vmware-tools-distrib 
	echo ""
	./vmware-install.pl 
	echo ""
	rm -rf vmware-tools.distrib 
}

function INSTALA_TSM()
{
	echo "Instalando TSM client"
}

MAIN
exit;
