*** Settings ***
Library	SSHLibrary
Library	OperatingSystem
Library	Collections
Variables	${CURDIR}/../../db.yaml

Suite Setup	open_connection_and_login
Suite Teardown	Close All Connections

*** Test Cases ***
01_Create Directory
	[Documentation]	Create Directory for Mounting
	${mount_path}=	Path
	Execute Command	mkdir -p ${mount_path["dir"]}
	Log	"Directory was Created successfully..."


02_cifs_public_share_mount
	[Documentation]	Mounting and copying a file in public share
	${dest}=	Path
	#${IP}=	Get Environment Variable	SERVER_IP

	#${protocol_Name}=	Get Environment Variable	PROTOCOL_NAME
	Run Keyword if	'${PROTOCOL_NAME}'=='cifs'	Execute Command	mount -t cifs //${SERVER_IP}/public ${dest["dir"]} -o username=samba,password=root	ELSE IF	'${PROTOCOL_NAME}'=='nfs'	Execute Command	mount -t nfs ${SERVER_IP}:/common/public ${dest["dir"]} 	
	Sleep	2s
	Execute Command	touch ${dest["dir"]}/pub.txt	
	sleep	5s	
	Execute Command	umount ${dest["dir"]}
	sleep	4s
	

03_cifs_private_share_mount
	[Documentation]	Mounting and copying a file private share
	${dest_pri}=	Path
	#${IP}=	Get Environment Variable	SERVER_IP
	#${Protocol_Name}=	Get Environment Variable	PROTOCOL_NAME
	sleep	4s
	Run Keyword If	'${PROTOCOL_NAME}'=='cifs'	Execute Command	mount -t cifs //${SERVER_IP}/private ${dest_pri["dir"]} -o username=samba,password=root	ELSE IF	'${PROTOCOL_NAME}'=='nfs'	Execute Command	mount -t nfs ${SERVER_IP}:/common/private ${dest_pri["dir"]}
	sleep	5s	
 	Execute Command	touch ${dest_pri["dir"]}/pri.txt 
	sleep	4s	
	Execute Command	umount ${dest_pri["dir"]}
	sleep	3s

04_cifs_readonly_share_mount
	[Documentation]	Mounting and copying a file
	[TAGS]	mounting and copying a file to privat share 
	${dest_ro}=	Path
	#${IP}=	Get Environment Variable	SERVER_IP
	#${Protocol_NAME}=	Get Environment Variable	PROTOCOL_NAME
	Run Keyword If	'${PROTOCOL_NAME}'=='cifs'	Execute Command	mount -t cifs //${SERVER_IP}/Readonly ${dest_ro["dir"]} -o username=samba,password=root	ELSE IF	'${PROTOCOL_NAME}'=='nfs'	Execute Command	mount -t nfs ${SERVER_IP}:/common/Readonly ${dest_ro["dir"]}	
	${create}=	Run Keyword And Return Status	Create File	${dest_ro["dir"]}/readonly.txt	Helloworld this is fortestin1g
	sleep	2s
	Log	${create}	
	Execute Command	umount ${dest_ro["dir"]}
	sleep	3s

*** Keywords ***

Path
	${json}=	OperatingSystem.Get File	${CURDIR}/../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}
				

Open Connection And Log In
	#${ip}=	Get Environment Variable	CLIENT_IP
	#${name}=	Get Environment Variable	CLIENT_NAME
	#${pwd}=	Get Environment Variable	CLIENT_PWD
	Open Connection	${CLIENT_IP}
	Login	${CLIENT_NAME}	${CLIENT_PWD}
