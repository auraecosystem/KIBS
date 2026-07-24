git clone --recurse-submodules https://gerrit.googlesource.com/gerrit
cd gerrit && (
    cd .git/hooks
    ln -s ../../resources/com/google/gerrit/server/tools/root/hooks/commit-msg
  )
