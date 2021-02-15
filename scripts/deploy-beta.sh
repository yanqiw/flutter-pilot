#!/usr/bin/env bash

# var
ANDROID="apk"
IOS="ios"

# functions
function build()
{
    if [ $1 == $IOS ] || [ $1 == $ANDROID ]
    then
        echo "Start build $1"
        flutter build $1     
    fi

    return 0
}

function deploy()
{
    if [ $1 == $IOS ] 
    then
        echo "Start deploy ios"
        cd ios
        fastlane beta
        cd ..
    fi

    if [ $1 == $ANDROID ]
    then
        echo "Start deploy android"
        cd android
        fastlane beta
        cd ..
    fi
    return 0
}

if [ "$1" == "" ] || ([ $1 != $IOS ] && [ $1 != $ANDROID ])
then
    echo "ERROR: Please define platform[$IOS | $ANDROID]. etc. sh ./deply-beta.sh ios"
    exit
fi
build $1
deploy $1

echo "DONE"