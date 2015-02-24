#!/bin/sh

hg qpop -va
cd .hg/gecko-patches
git pull
for i in `cat series`
do
  echo -n $i:
  if [ -f ../patches/$i ]
  then
    if diff $i ../patches/$i >/dev/null
    then
      echo "Up to date ----------"
    else
      echo 'Should be updated! *********'
      cp -f $i ../patches/$i
    fi
    (cd ../.. && hg qpush $i) || break
  else
    echo "New patch +++++++"
    (cd ../.. && hg qimport .hg/gecko-patches/$i && hg qpush $i)||break
  fi
done
