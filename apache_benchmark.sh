# echo $(curl 'http://127.0.0.1:9292/test/sleep/3000') | json -o inspect &
# echo $(curl 'http://127.0.0.1:9292/test/sleep/5000') | json -o inspect &
# echo $(curl 'http://127.0.0.1:9292/test/sleep/10000') | json -o inspect &
# echo $(curl 'http://127.0.0.1:9292/test/sleep/2300') | json -o inspect &

# NOTE: The file descriptors permitted by the system are the bottleneck that
# ab and httperf have to honor. On OSX one may run `ulimit -a` to observe the
# limit on file descriptors which happened to be 256 on my machine. Change it
# to 256 by executing `limit -n 500`
# https://cs.uwaterloo.ca/~brecht/servers/openfiles.html

# NOTE: Somehow increasing ulimit -n may lead to
# `apr_socket_connect(): Operation already in progress (37)` which basically
# have to do with a bug in order versions of the Apache Benchmark (ab) tool.
# Follow instructions on http://superuser.com/questions/323840/apache-bench-test-error-on-os-x-apr-socket-recv-connection-reset-by-peer-54
# to install a more recent version of the apache toolset.

# NOTE: Provided that one runs into problems configuring a newer version of
# apache httpd, please study https://github.com/Homebrew/homebrew-apache/blob/master/README.md#troubleshooting

echo -e "\033[1;93m"
ulimit -a
ab -r -n ${NUM_OF_REQS} -c ${NUM_OF_CONCURRENT} ${HOST}${ENDPOINT}
echo -e "\033[0m"

NUM_OF_REQS=2000 #1000
NUM_OF_CONCURRENT=500 #200
HOST=http://127.0.0.1:9292
ENDPOINT=/test/sleep/3000

echo -e "\033[0;31mPress [enter] when the server is started\033[0m"
rackup &

read

echo -e "\033[1;93m"
ab -r -n ${NUM_OF_REQS} -c ${NUM_OF_CONCURRENT} ${HOST}${ENDPOINT}
echo -e "\033[0m"

echo -e "\033[0;31mPress [enter] once more to terminate the server\033[0m"
read

kill -9 $!
