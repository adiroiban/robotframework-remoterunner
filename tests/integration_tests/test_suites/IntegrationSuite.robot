*** Settings ***
Library           Process
Library           OperatingSystem

*** Test Cases ***
Basic
    [Setup]
    # Start the slave
    ${slave_handle}=    Start Process    python    -m    rfremoterunner.runslave
    Process Should Be Running    ${slave_handle}    Failed to launch the slave
    ${lsof_result}=    Run Process    lsof -i -P -n | grep LISTEN    shell=${True}
    Log    ${lsof_result.stdout}
    Log    ${lsof_result.stderr}
    # Now run the Executor
    ${executor_result}=    Run Process    python    -m    rfremoterunner.executerun    127.0.0.1    ${CURDIR}/../resources/    --outputdir    ${CURDIR}
    Should Be Equal As Integers    ${executor_result.rc}    ${0}    executerun failed with: ${executor_result.stderr}
    Log    ${executor_result.stdout}
    Log    ${executor_result.stderr}
    File Should Exist    ${CURDIR}/remote_output.xml
    File Should Exist    ${CURDIR}/remote_log.html
    File Should Exist    ${CURDIR}/remote_report.html
    [Teardown]    Basic Teardown

*** Keywords ***
Basic Teardown
    Terminate All Processes
    Remove Files    ${CURDIR}/remote_output.xml    ${CURDIR}/remote_log.html    ${CURDIR}/remote_report.html
