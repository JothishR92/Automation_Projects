*** Settings ***
Library	OperatingSystem
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml
Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install ftp client package
	[Documentation]	ftp Client Package Installation
	${pack}=	Packages
	${client}=	Execute Command	apt install ${pack["ftp_client_pack"]}
	Log	${client}

02_Creating a file
	[Documentation]	file creation
	Execute Command	touch client.txt

03_ftp file transfer with private share
	[Documentation]	file transfer with private share
	#${server_ip}=	Get Environment Variable	SERVER_IP
	Write   ftp ${server_ip}
	Set Client Configuration	prompt=Name (${SERVER_IP}:root):
	${output}=	Read Until Prompt
	Should End With	${output}	Name (${SERVER_IP}:root):
	Write	ftpuser
	Set Client Configuration	prompt=Password:
	${output}=	Read Until Prompt
	Should End With	${output}	Password:
	Write	ftpuser
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With	${output}	ftp>
	Write	cd /private
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With	${output}	ftp>
	Write	put client.txt
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With	${output}	ftp>
	Write	get priv.txt
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With	${output}	ftp>
	Write	exit

04_ftp file transfer with public share as anonymous user
	[Documentation]	file transfer with public share as anonymous user
	#${server_ip}=	Get Environment Variable	SERVER_IP
	Write	ftp ${SERVER_IP}
	Set Client Configuration	prompt=Name (${SERVER_IP}:root):
	${output}=	Read Until Prompt
	Should End With ${output}	Name (${SERVER_IP}:root):
	Write	anonymous
	Set Client Configuration	prompt=Password:
	${output}=	Read Until Prompt
	Should End With ${output}	Password:
	Write	anonymous
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With ${output}	ftp>
	Write	cd /common/public
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With	${output}	ftp>
	Write	put client.txt
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With ${output}	ftp>
	Write	get pub.txt
	Set Client Configuration	prompt=ftp>
	${output}=	Read Until Prompt
	Should End With ${output}	ftp>
	Write   exit


05_Deleting the above created file
	[Documentation]	file deletion
	Execute Command	rm client.txt

		

*** Keywords ***

Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}

Open Connection And Log In
	#${ip}=	Get Environment Variable	CLIENT_IP
	#${name}=	Get Environment Variable	CLIENT_NAME
	#${pwd}=	Get Environment Variable	CLIENT_PWD
	Open Connection	${CLIENT_IP}
	Login	${CLIENT_NAME}	${CLIENT_PWD}
