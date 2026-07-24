  $(bazel info output_base)/external/local_jdk/bin/java \
     -jar bazel-bin/gerrit.war daemon -d $GERRIT_SITE \
     --console-log
