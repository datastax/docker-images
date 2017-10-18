############################################
# Replace files listed in /overwritable-conf-files
# if their counterparts exist in /config folder
############################################

function link_external_config {
    for conf_file in $(cat /overwritable-conf-files) ; do
        ext_conf_file="/config/$(basename "$conf_file")"
        embedded_conf_file="${1}/${conf_file}"
        if [ -f "$ext_conf_file" ]; then
            echo "Linking $embedded_conf_file to $ext_conf_file"
            mkdir -p "$(dirname "$embedded_conf_file")"
            ln -sf "$ext_conf_file" "$embedded_conf_file"
        fi
    done
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
