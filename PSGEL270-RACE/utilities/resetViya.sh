echo "Cleaning up the environment before setting up and importing content"
export SAS_CLI_PROFILE=${current_namespace}
export SSL_CERT_FILE=~/.certs/${current_namespace}_trustedcerts.pem
export REQUESTS_CA_BUNDLE=${SSL_CERT_FILE}
/opt/pyviyatools/loginviauthinfo.py

# all of /gelcorp
/opt/pyviyatools/deletecontent.py -f /gelcorp -i -q

# the egprojects that were imported
/opt/pyviyatools/deletecontent.py -f /Public/exported -i -q

# delete /gelcontent comes from
/opt/pyviyatools/deletecontent.py -f /gelcontent -i -q

# Empty the recycle all namespaces
/opt/pyviyatools/deletecontent.py -f "/Users/geladm/Recycle Bin" -q

