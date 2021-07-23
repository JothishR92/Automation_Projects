*** Settings ***
Library	OperatingSystem
Library	Collections
Library	String
Library	SSHLibrary
Variables	${CURDIR}/../../../db.yaml

Suite Setup	Open Connection And Log In
Suite Teardown	Close All Connections

*** Test Cases ***

01_Install client package
        [Documentation]	Client Package Installation
        ${pack}=	Packages
        ${client}=	Execute Command	apt -y install ${pack["nfs_cli_package"]}	sudo=true	sudo_password=root
        Log	${client}

02_Mounting Directory
        [Documentation]	Mounting Directory to server Directory
        OperatingSystem.Run	robot --timestampoutputs --log mount_log.html --report NONE ${CURDIR}/../../common/mounts.robot
	

*** Keywords ***

Packages
        ${json}=	OperatingSystem.Get File	${CURDIR}/../../config/config.json
        ${obj}=	Evaluate	json.loads('''${json}''')	json
        [return]	${obj}

Open Connection And Log In
        #${ip}=	Get Environment Variable	CLIENT_IP
        #${name}=	Get Environment Variable	CLIENT_NAME
        #${pwd}=	Get Environment Variable	CLIENT_PWD
        Open Connection	${SERVER_IP}
        Login	${SERVER_NAME}	${SERVER_PWD}

