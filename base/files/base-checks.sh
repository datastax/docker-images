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
            echo "Linking $embedded_conf_file to $ext_conf_file"
            mkdir -p "$(dirname "$embedded_conf_file")"
            ln -sf "$ext_conf_file" "$embedded_conf_file"
            linkedExternalConf["$embedded_conf_file"]="$ext_conf_file"
        fi
    done
}

function is_external_file {

    MP="$(df --output=target "$1" | tail -n +2)"
    if [ "$MP" != "/" ] && grep -q "^Users $MP" /proc/mounts ; then
        echo "$1 mount point is $MP"
        true
    else
        false
    fi
}

function should_auto_configure {

    if [ ! -z "$DSE_AUTO_CONF_OFF" ]; then
        false
    else
        if is_external_file "$1" ; then
            false
        else
            true
        fi
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
