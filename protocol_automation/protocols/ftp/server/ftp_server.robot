*** Settings ***
Library	OperatingSystem
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install ftp-server Packages
	[Documentation]	Install ftp server PackagesI
	${pack}=	Packages
	${server}=	Execute Command	apt install -y ${pack["ftp_server_pack"]}
	Log	${server}

02_Edit Config file and restarting ftp server
	[Documentation]	Editing Configuration file and restarting ftp server
	Put File	ftp_content.txt	/etc/vsftpd.conf
	Execute Command	service vsftpd restart

03_Create Shares
	[Documentation]	Creating Shares 
	Run	robot ${CURDIR}/../../common/shares.robot
	${test}=	Execute Command	ls -l
	Write	cd /private
	Write	touch priv.txt
	Write	cd ../common/public/
	Write	touch pub.txt
	Log	"Shares created successfully..."

04_Create User and provide permission
	[Documentation]	User permission to private & RO share
	${share}=	Packages
	Execute Command	chmod 544 ${share["ro"]}
	Execute Command	useradd -m ftpuser 
	Execute Command	echo "ftpuser:ftpuser"|chpasswd
	Execute Command	chown ftpuser ${share["private"]}	
	Execute Command	chown ftpuser ${share["ro"]}	
	
05_Call ftp Client
	[Documentation]	Run ftp Client
	Run	robot ${CURDIR}/../client/ftp_client.robot

06_Deleting a file
	[Documentation]	file deletion
	Write	cd /private
	Write	rm -rf priv.txt
	Write	cd ../common/public
	Write	rm pub.txt
	
*** Keywords ***

Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}
	

Open Connection And Log In
#	${ip}=	Get Environment Variable	SERVER_IP
#	${name}=	Get Environment Variable	SERVER_NAME
#	${pwd}=	Get Environment Variable	SERVER_PWD
	Open Connection	${SERVER_IP}
	Login	${SERVER_NAME}	${SERVER_PWD}
		
