*** Settings ***
Library	OperatingSystem
Library	Collections
Library	String
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install Packages
	[Documentation]	Install samba Packages
	${pack}=	Packages
	${package}=	Execute Command	apt install -y ${pack["SFTP_ServerPackage"]}	sudo=true	sudo_password=root
	Log	${package}

02_SFTP user create
	[Documentation]	Create an user for SFTP
	Execute Command	useradd -m sftp
	Execute Command	echo "sftp:sftp"|chpasswd

03_Run robot file
	[Documentation]	Run Shares program
	Run	robot ${CURDIR}/../../common/shares.robot
	Log	"Shares created successfully..."

04_Give SFTP user Permission to a Share
	[Documentation]	User permission to private share
	${share_private}=	Json_file
	Execute Command	chown sftp ${share_private["private"]}	sudo=true	sudo_password=root

05_Call Client
	[Documentation]	Run cifs Protocol Client
	Run	robot ${CURDIR}/../client/protocol_clients.robot
	
*** Keywords ***

Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}

Json_file
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj} 
	

Open Connection And Log In
#	${ip}=	Get Environment Variable	SERVER_IP
#	${name}=	Get Environment Variable	SERVER_NAME
#	${pwd}=	Get Environment Variable	SERVER_PWD
	Open Connection	${SERVER_IP}
	Login	${SERVER_NAME}	${SERVER_PWD}
		
