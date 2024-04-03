# Testing dlt-daemon on QNX

Unit tests normally are executes on the same machine the project was built on. This obviously doesn't work when cross-compiling for QNX. The gist is to build, then copy the whole dlt-daemon source tree on a target. This will include all the relevant files and directory structure which dlt-daemon expects when running its test suite.

# Running the Test Suite
Compile the dlt-daemon source for the desired architecture, e.g.

    CPULIST=x86_64 make -C qnx/build JLEVEL=4

Then build your QNX image using mkqnximage and the following options:

    # <repo_path> is where the code was checked out e.g. /home/user/projects/dlt-daemon
    mkdir test_image
    cd test_image
    mkqnximage --extra-dirs=<repo_path>/qnx/test/mkqnximage --clean --run --force --test-dltdaemon=<repo_path>

Once the target has booted, the dlt-daemon source tree will be located in /data/dlt-daemon:

    # cd /data/dlt-daemon/qnx/test
    # ./qnxtest.sh
