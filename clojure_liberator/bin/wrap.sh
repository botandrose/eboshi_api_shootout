#!/bin/bash
$*
code=$?
echo "code: $code"

if [ "143" == "$code" ]; then
    exit 0;
fi
exit $code
