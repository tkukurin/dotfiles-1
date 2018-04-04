#!/usr/bin/sh
export $(gnome-keyring-daemon -s --components=gpg,pkcs11,secrets,ssh)
