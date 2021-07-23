*** Settings ***
Library	OperatingSystem
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install client package
	[Documentation]	Client Package Installation
	${pack}=	Packages
	${client}=	Execute Command	apt install ${pack["SFTP_ClientPackage"]}
	Log	${client}

02_SFTP file upload
	[Documentation]	Upload file using SFTP protocol
	Execute Command	mkdir SFTPFileTransfer
	${server}=	Get Environment Variable	SERVER_IP
	Write	sftp sftp@${server}
	Set Client Configuration	prompt=sftp@${server}'s password:
	${output}=	Read Until Prompt
	Should End With	${output}	sftp@${server}'s password:
	Write	sftp
	Set Client Configuration	prompt=sftp>
	${output}=	Read Until Prompt
	Should End With	${output}	sftp>
	Write	cd /private
	Set Client Configuration	prompt=sftp>
	${output}=	Read Until Prompt
	Should End With	${output}	sftp>
	Write	put testing.txt
	Log	SFTP put successful


*** Keywords ***
Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}

Open Connection And Log In
#	${ip}=	Get Environment Variable	CLIENT_IP
#	${name}=	Get Environment Variable	CLIENT_NAME
#	${pwd}=	Get Environment Variable	CLIENT_PWD
	Open Connection	${CLIENT_IP}
	Login	${CLIENT_NAME}	${CLIENT_PWD}
