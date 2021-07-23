*** Settings ***
Library	SSHLibrary
Library	OperatingSystem
Variables	${CURDIR}/../../db.yaml

Suite Setup	open_connection_and_login
Suite Teardown	Close All Connections

*** Test Cases ***


cifs_share_private
	[Documentation]	Creating Private Share
	${share_private}=	Packages
	${rc}=	Execute Command	mkdir -p ${share_private["private"]}	return_stdout=FALSE	return_rc=True
	${rc1}=	Execute Command	chmod 770 ${share_private["private"]}

cifs_share_public
	[Documentation]	Creating Public Share
	${share_public}=	Packages
	${rc}=	Execute Command	mkdir -p ${share_public["public"]}	return_stdout=FALSE	return_rc=True
	${rc1}=	Execute Command	chmod 777 ${share_public["public"]}
	Execute Command	chown nobody:nogroup ${share_public["public"]}

cifs_share_readonly
	[Documentation]	Creating Ro Share
	${share_ro}=	Packages
	${rc}=	Execute Command	mkdir -p ${share_ro["ro"]}	return_stdout=FALSE	return_rc=True
	${rc1}=	Execute Command	chmod 444 ${share_ro["ro"]}



	

	
*** Keywords ***
Packages
	${json}=	OperatingSystem.Get File	${CURDIR}/../config/config.json
	${obj}=	Evaluate	json.loads('''${json}''')	json
	[return]	${obj}

Open Connection And Log In
	#${ip}=	Get Environment Variable	SERVER_IP
        #${name}=	Get Environment Variable	SERVER_NAME
        #${pwd}=	Get Environment Variable	SERVER_PWD
        Open Connection	${SERVER_IP}
        Login	${SERVER_NAME}	${SERVER_PWD}


