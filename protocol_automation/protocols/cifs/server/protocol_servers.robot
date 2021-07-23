*** Settings ***
Library	OperatingSystem
Library	Collections
Library	String
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install Pcakages
	[Documentation]	Install samba PackagesI
	${pack}=	Packages
	${package}=	Execute Command	apt install -y ${pack}	sudo=true	sudo_password=root
	Log	${package}

02_Edit Config File
	[Documentation]	Edit Config File
	${file}=	Json_file
	${create_dir}=	Execute Command	mkdir ${file["dir_path"]}	return_stdout=FALSE	return_rc=True	sudo=true	sudo_password=root
	Log	"Directory was created successfully..."
	${copy_file}=	Execute Command	cp -rvf ${file["config_file"]} ${file["dir_path"]}	sudo=true	sudo_password=root
	Log	"File copied successfully..."	
	${content}=	OperatingSystem.Get File	${CURDIR}/../smb_content.txt
	@{lines}=	Split to Lines	${content}
	:FOR	${line}	IN	@{lines}
	\	Execute Command	echo ${line} >> ${file["config_file"]} 

03_Restart Service
	[Documentation]	Restart service
	Execute Command	systemctl restart smbd
	Log	"Service restart successfully..." 

04_Run robot file
	[Documentation]	Run Shares program
	Run	robot --timestampoutputs --log shares.html --report NONE ${CURDIR}/../../common/shares.robot
	Log	"Shares created successfully..."

05_Give Permission to Share
	[Documentation]	User permission to private share
	${share}=	Json_file
	Execute Command	addgroup smbgrp	
	Execute Command	useradd samba -G smbgrp	
	Execute Command	echo -e "root\nroot"|smbpasswd -a samba
	Execute Command	chmod 0770 ${share["private"]}
	Execute Command	chown root:smbgrp ${share["private"]}
	
	
06_Call Client
	[Documentation]	Run cifs Protocol Client
	OperatingSystem.Run	robot --timestampoutputs --log client.html --report NONE ${CURDIR}/../client/protocol_clients.robot
	
*** Keywords ***

Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	${list}=	Create List	${obj["package_1"]}	${obj["package_2"]}	${obj["package_3"]}	${obj["package_4"]}
	${pack}=	Convert To String	${list}
	${smb_Pack}=	Remove String	${pack}	u	'	,	[	]
	[return]	${smb_pack}

Json_file
	${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj} 
	

Open Connection And Log In
#	${ip}=	Get Environment Variable	SERVER_IP
#	${name}=	Get Environment Variable	SERVER_NAME
#	${pwd}=	Get Environment Variable	SERVER_PWD
	Open Connection	${SERVER_IP}
	Login	${SERVER_NAME}	${SERVER_PASSWORD}
		
