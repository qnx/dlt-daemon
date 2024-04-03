#! /bin/sh

# For testing, copy the whole dlt-daemon compiled source tree to the target in
# a specific location e.g. /data/dlt-daemon and then execute this script from
# the source tree

DLTDAEMON_DIR=/data/dlt-daemon/qnx/build/${DLTDAEMON_TEST_PREFIX}/build

# Set LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DLTDAEMON_DIR/src/lib:$DLTDAEMON_DIR/src/daemon:$DLTDAEMON_DIR/lib
export PATH=$PATH:$DLTDAEMON_DIR/src/daemon
export DLT_UT_DAEMON_PATH=:$DLTDAEMON_DIR/src/daemon/dlt-daemon

# Change directory to the test directory
cd $DLTDAEMON_DIR/tests;

echo --------------------------------
echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH
echo PATH=$PATH
echo CURRENT DIR:$DLTDAEMON_DIR/tests
echo --------------------------------

print_test_result () {
    if [ $? -eq 0 ]; 
    then 
        echo -e "\t\t[PASSED]" 
    else 
        echo -e "\t\t[FAILED]" 
    fi
}

echo -n "Execute gtest_dlt_common"
./gtest_dlt_common > test_report_gtest_dlt_common.txt 2>&1
print_test_result;

echo -n "Execute gtest_dlt_user"
./gtest_dlt_user > test_report_gtest_dlt_user.txt 2>&1
print_test_result;

echo -n "Execute gtest_dlt_daemon_common"
./gtest_dlt_daemon_common > test_report_gtest_dlt_daemon_common.txt 2>&1
print_test_result;

echo -n "Execute dlt_env_ll_unit_test"
./dlt_env_ll_unit_test > test_report_dlt_env_ll_unit_test.txt 2>&1
print_test_result;

echo -n "Execute gtest_dlt_daemon_gateway"
./gtest_dlt_daemon_gateway.sh > /dev/null 2>&1
./gtest_dlt_daemon_gateway > test_report_gtest_dlt_daemon_gateway.txt 2>&1
print_test_result;
sleep 0.5
slay -fQ dlt-daemon

echo -n "Execute gtest_dlt_daemon_offline_log"
./gtest_dlt_daemon_offline_log.sh > /dev/null 2>&1
./gtest_dlt_daemon_offline_log > test_report_gtest_dlt_daemon_offline_log.txt 2>&1
print_test_result;
sleep 0.5
slay -fQ dlt-daemon

echo -n "Execute gtest_dlt_daemon_event_handler"
./gtest_dlt_daemon_event_handler > test_report_gtest_dlt_daemon_event_handler.txt 2>&1
print_test_result;

echo -n "Execute gtest_dlt_daemon_multiple_files_logging"
./gtest_dlt_daemon_multiple_files_logging > test_report_gtest_dlt_daemon_multiple_files_logging.txt 2>&1
print_test_result;

echo -e "\nTest reports are stored in: $DLTDAEMON_DIR/tests"
