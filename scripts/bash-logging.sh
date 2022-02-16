#!/usr/bin/env bash

RED="\e[31m"
BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

success() {
    echo -e "$GREEN$1$ENDCOLOR"
}
error() {
    echo -e "$RED$1$ENDCOLOR" >&2
}
warn() {
    echo -e "$YELLOW$1$ENDCOLOR" >&2
}
info() {
    echo -e "$BLUE$1$ENDCOLOR"
}