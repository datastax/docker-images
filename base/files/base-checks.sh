#!/usr/bin/env bash
############################################
# Replace files listed in /overwritable-conf-files
# if their counterparts exist in /config folder
############################################

declare -A linkedExternalConf

function link_external_config {
    for conf_file in $(cat /overwritable-conf-files) ; do
        ext_conf_file="/config/$(basename "$conf_file")"
        embedded_conf_file="${1}/${conf_file}"
        if [ -f "$ext_conf_file" ]; then
            mkdir -p "$(dirname "$embedded_conf_file")"
            ln -sf "$ext_conf_file" "$embedded_conf_file"
            echo "INFO: Linked $embedded_conf_file to $ext_conf_file"
            linkedExternalConf["$embedded_conf_file"]="$ext_conf_file"
        fi
    done
}

function should_auto_configure {

    if [ ! -z "$DSE_AUTO_CONF_OFF" ]; then
        case "$DSE_AUTO_CONF_OFF" in
            all)
                echo "INFO: skipping auto configuration of $1 due to presence of DSE_AUTO_CONF_OFF env variable"
                false
                ;;
            *)
                found=0
                for f in $(echo "$DSE_AUTO_CONF_OFF" | tr "," "\n") ; do
                    if [ $(basename $1) == "$f" ]; then
                        echo "INFO: skipping auto configuration of $1 due to its presence in DSE_AUTO_CONF_OFF env variable"
                        found=1
                        break
                    fi
                done
                [ $found == 0 ]
                ;;
        esac
    else
        true
    fi
}

############################################
# Check for license acceptance
############################################
if [ "$DS_LICENSE" = "show" ]; then
  cat /LICENSE
  exit 1
elif [ "$DS_LICENSE" != "accept" ]; then
  echo -e "Set the environment variable DS_LICENSE=accept to indicate acceptance of the included license terms."
  exit 1
fi
