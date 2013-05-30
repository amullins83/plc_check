#!/bin/bash

if [[ ! -s /tmp/newlist ]]
then
	ls -l $1 > /tmp/oldlist
else
	cat /tmp/newlist > /tmp/oldlist
fi

ls -l $1 > /tmp/newlist

if [[ -n `diff /tmp/oldlist /tmp/newlist` ]]
	then
	$2
fi