#!/bin/bash

KRB_SRV_PACKAGES="krb5-server krb5-libs krb5-workstation"
KRB_CLIENT_PACKAGES="krb5-libs krb5-workstation"
KRB_KDC_PATH="/var/kerberos/krb5kdc"
KRB_KDC_SERVICES="krb5kdc kadmin"
KRB_CONF_FILE="/etc/krb5.conf"
# Customize your environment
REALM="HWX.LOCAL"
DOMAIN="hwx.local"
DEFAULT_PASSWORD="Abcd1234."
# MIT KDC Server
HOSTNAME=$(hostname)

echo "Installing Kerberos Packages"
yum install -y ${KRB_SRV_PACKAGES}

# Create krb5.conf file
echo "Creating krb5.conf file, KDC host is ${HOSTNAME} and realm is ${REALM}"
cat > ${KRB_CONF_FILE} <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = ${REALM}
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 # [Recommended] this needs to be set to 1 to force traffic to use TCP
 udp_preference_limit = 1
 # systems which need to continue to use the weaker ciphers can be configured with "allow_weak_crypto = yes"
 # allow_weak_crypto = true
 # Not recommended on the client unless required by backward compatibility settings. If used KDC server needs have this encryption type as one of the supported subsets
 # default_tgs_enctypes =
 # Not recommended on the client unless required by backward compatibility settings.  If used KDC server needs have this encryption type as one of the supported subsets
 # default_tkt_enctypes =

[realms]
 # Note: if port is not specified default port 88 will be used.
 ${REALM} = {
 kdc = ${HOSTNAME}
 admin_server = ${HOSTNAME}
 default_domain = ${DOMAIN}
}

[domain_realm]
 .${DOMAIN} = ${REALM}
 ${DOMAIN} = ${REALM}
EOF

# Create kdam5.aclfile
# acl_file - control list file which defaults to  /var/kerberos/krb5kdc/kadm5.acl. This is where you set admin or other permission for principals to access KDC.  For example for Ambari to be able to kerberize the cluster the principal provided to Ambari needs to have admin permission specified in this file (/var/kerberos/krb5kdc/kadm5.acl).

echo "Creating kadm5.acl file, realm is ${REALM}"
cat >${KRB_KDC_PATH}/kadm5.acl <<EOF
*/admin@${REALM}    *
EOF

# Create KDC database
echo "Created KDC database, this could take some time"
kdb5_util create -s -P ${DEFAULT_PASSWORD}

# Create admistrative user
echo "Creating administriative account:"
echo "  principal:  root/admin"
echo "  password:   ${DEFAULT_PASSWORD}"
kadmin.local -q "addprinc -pw ${DEFAULT_PASSWORD} root/admin"
echo

echo "Existing Principals on ${HOSTNAME}"
kadmin.local -q "listprincs"
echo

# Starting services
echo "Starting services"
for Services in ${KRB_KDC_SERVICES}
do
   chkconfig ${Services} on
   service ${Services} start
done

echo "[1m[31mTo kerberize an Ambari Cluster you will need:[0m"
echo "1.- Copy ${KRB_CONF_FILE} to the Ambari Server"
echo "2.- All the hosts must be able to resolve ${HOSTNAME} using DNS (/etc/resolv.conf) or (/etc/hosts)"
echo "3.- All the hosts must be able to ping ${HOSTNAME}"
echo "4.- Be sure the following packages ${KRB_CLIENT_PACKAGES} are installed on the Ambari Server"
