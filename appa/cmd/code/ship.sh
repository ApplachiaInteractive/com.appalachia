#!/bin/bash
# shellcheck source=./../../functions/cmd_start.sh
source "${APPA_FUNCTIONS_HOME}/cmd_start.sh"

if  [ $# -ne 1 ] ; then 
    argserror $'[PARAMS] [commit message]'
    exit 2
fi

attempt 'Attempting to ship...'

if [ "${REPO_HOME}" == "${HOME}/com.appalachia" ] ; then
    error 'Check your directory...'
    exit 1
fi

git add .
result=$?

if [ ${result} -ne 0 ] ; then
    echo ${result}
    exit ${result}
fi

git commit -m "$1"
result=$?

if [ ${result} -gt 1 ] ; then
    echo ${result}
    exit ${result}
fi

git push
result=$?

if [ ${result} -ne 0 ] ; then
    echo ${result}
    exit ${result}
fi

source appa.sh code publish

if [ ${result} -ne 0 ] ; then
    echo ${result}
    exit ${result}
fi

success 'Shipped!'