#!/bin/bash

missing_binary() {
    EXPECTED="${1}"
    ACTUAL=$(which "${1}")

    if [[ -z "${ACTUAL}" ]] || [[ ! -x "${ACTUAL}" ]]; then
      echo -e "${RED}ERROR${ENDCOLOR}: Binary \`${CODE}${EXPECTED}${ENDCOLOR}\` is not installed, or not available in ${CODE}\$PATH${ENDCOLOR}."
      exit 1
    fi
}

missing_file() {
    FILE="${1}"
    if [[ ! -f "${FILE}" ]] || [[ ! -r "${FILE}" ]]; then
        echo -e "${RED}ERROR${ENDCOLOR}: File \`${CODE}${FILE}${ENDCOLOR}\` is missing, or not readable"
        exit 1
    fi
}

missing_directory() {
    DIR="${1}"
    if [[ ! -d "${DIR}" ]] || [[ ! -w "${DIR}" ]]; then
        echo -e "${RED}ERROR${ENDCOLOR}: Directory \`${CODE}${DIR}${ENDCOLOR}\` is missing, or not writable"
        exit 1
    fi
}

show_help() {
    EXIT_CODE="${1:-0}"
    echo -e "$USAGE"
    exit $EXIT_CODE
}