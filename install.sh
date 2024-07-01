#!/bin/bash

source "${PWD}/config/dev-scripts/_colours.sh"
source "${PWD}/config/dev-scripts/_functions.sh"

BINARY_LOCATION="${HOME}/.local/bin/"

USAGE="Install dev scripts

This expects that the following binaries are available in the ${CODE}\$PATH${ENDCOLOR}:
- ${CODE}docker${ENDCOLOR}
- ${CODE}kitty${ENDCOLOR}
- ${CODE}nohup${ENDCOLOR}
- ${CODE}phpstorm${ENDCOLOR}
- ${CODE}zenity${ENDCOLOR}

${BOLD}Usage${ENDCOLOR}:
${CODE}install.sh [options]${ENDCOLOR}

${BOLD}Help Options${ENDCOLOR}:
 ${CODE}-h${ENDCOLOR}   Show this ${GREEN}h${ENDCOLOR}elp and exit

${BOLD}Running Options${ENDCOLOR}:
 ${CODE}-b${ENDCOLOR}   Set a ${GREEN}b${ENDCOLOR}inary directory (default: ${CODE}${BINARY_LOCATION}${ENDCOLOR})
 ${CODE}-d${ENDCOLOR}   Check ${GREEN}d${ENDCOLOR}ependencies only, then exit
 ${CODE}-F${ENDCOLOR}   ${GREEN}F${ENDCOLOR}orce re-install, or uninstall from non-default binary directories
 ${CODE}-U${ENDCOLOR}   ${GREEN}U${ENDCOLOR}n-install dev scripts
"

DRY_RUN=0
FORCE=0
UNINSTALL=0

while getopts 'db:FhU' OPTION
do
    case "${OPTION}" in
        b) BINARY_LOCATION="${OPTARG}" ;;
        d) DRY_RUN=1 ;;
        F) FORCE=1 ;;
        h) show_help ;;
        U) UNINSTALL=1 ;;
        ?)
            echo "Invalid option"
            exit 0
            ;;
    esac
done

# Check for dependencies
missing_binary "docker"
missing_binary "kitty"
missing_binary "nohup"
missing_binary "phpstorm"
missing_binary "zenity"

# Ensure that directories are accessible
missing_directory "${HOME}/.config"
missing_directory "${HOME}/.config/kitty"
missing_directory "${BINARY_LOCATION}"

SCRIPTS=(dev dev-running dev-sail dev-selector dev-stop)

# Ensure that all the files are where we expect them to be
missing_file "${PWD}/config/dev-scripts/_colours.sh"
missing_file "${PWD}/config/dev-scripts/_functions.sh"
missing_file "${PWD}/config/kitty/sail.conf"
for SCRIPT in "${SCRIPTS[@]}"; do
    missing_file "${PWD}/scripts/${SCRIPT}"
done

if [[ $DRY_RUN -eq 1 ]]; then
    echo -e "${GREEN}Dependencies are met${ENDCOLOR}"
    exit 0
fi

if [[ $FORCE -eq 1 ]] || [[ $UNINSTALL -eq 1 ]]; then
    rm -rf "${HOME}/.config/dev-scripts"
    rm -f "${HOME}/.config/kitty/sail.conf"

    for SCRIPT in "${SCRIPTS[@]}"; do
      EXPECTED="${BINARY_LOCATION}/${SCRIPT}"
      REAL=$(which "${SCRIPT}")
      if [[ -f "${EXPECTED}" ]]; then
        rm "${EXPECTED}"
      elif [[ $UNINSTALL -eq 1 ]] && [[ $FORCE -eq 1 ]] && [[ ! -z "${REAL}" ]]; then
        rm -f "${REAL}"
      fi
    done
fi

if [ $UNINSTALL -eq 1 ]; then
  echo -e "${GREEN}Uninstalled dev scripts${ENDCOLOR}"
  exit 0
fi

cp -r "${PWD}/config/dev-scripts" "${HOME}/.config/"
if [ ! -f "${HOME}/.config/kitty/sail.conf" ]; then
  cp "${PWD}/config/kitty/sail.conf" "${HOME}/.config/kitty/"
fi
for SCRIPT in "${SCRIPTS[@]}"; do
  TARGET="${BINARY_LOCATION}/${SCRIPT}"
  if [ ! -f "${TARGET}" ]; then
    cp "${PWD}/scripts/${SCRIPT}" "${TARGET}"
  fi
  if [ ! -x "${TARGET}" ]; then
    chmod +x "${TARGET}"
  fi

  # Ensure that the script is available in the $PATH
  missing_binary "${TARGET}"
done
