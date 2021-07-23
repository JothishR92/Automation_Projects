*** Settings ***
Library	OperatingSystem
Library	Collections
Library	String
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install NFS Package
	[Documentation]	Install NFS Package's
	${pack}=	Json_file
	${ins}=	Execute Command	apt install -y ${pack["nfs_serv_package"]}	sudo=true	sudo_password=root
	Log	${ins}

02_Directory Creation
	[Documentation]	Create Directory
	Run	robot --timestampoutputs --log shares.html --report NONE ${CURDIR}/../../common/shares.robot

03_Write_Configuration
	[Documentation]	Write configuration to exports file
	${dir}=	Json_file
	#${client_ip}=	Get Environment Variable	CLIENT_IP
	Execute Command	echo "${dir["public"]} *(rw,sync,no_subtree_check)" >> ${dir["nfs_conf"]}	sudo=true	sudo_password=root	
	Execute Command	echo "${dir["private"]} ${client_ip}(rw,sync,no_root_squash,no_subtree_check)" >> ${dir["nfs_conf"]}	sudo=true	sudo_password=root
	Execute Command	echo "${dir["ro"]} ${client_ip}(ro,sync,no_root_squash,no_subtree_check)" >> ${dir["nfs_conf"]}	sudo=true	sudo_password=root
	${out}=	Execute Command	cat ${dir["nfs_conf"]}
	Log To Console	${out}

04_Restart Service
	[Documentation]	Restart NFS service
	${restart}=	Execute Command	service nfs-kernel-server restart
	Log to Console	${restart}

05_Call client
	[Documentation]	call NFS client
	Run	robot --timestampoutputs --log nfs_client.html --report NONE ${CURDIR}/../client/nfs_client.robot

	


*** Keywords ***

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

