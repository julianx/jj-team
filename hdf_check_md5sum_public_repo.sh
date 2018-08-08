#!/bin/bash
HDF_VERSION=3.1.2.0
BASE_URL=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/${HDF_VERSION}
LOCAL_REPO=/Users/jgaragorry/Downloads/REPO/HDF/centos7/3.1.2.0-7
# With this command you will see the all packages for the version of HDP
# curl -s ${BASE_URL}/artifacts.txt


XML_GZ=$(curl -s ${BASE_URL}/repodata/repomd.xml | awk -F'[ |=|"]' '/primary.xml/ {print $6}')
#curl -s ${BASE_URL}/${XML_GZ} | zgrep "<name>" | wc -l

# Compare the number of packages with the number of packages in the managed repository.  If there is a mismatch, then try to download the package in the repository and create de new Metadata for the repository, remember, double-check the MD5 for that package. If there is no difference in the count of packages, then, double-check the MD5 for each package.
# You can modify the HDF_Component to one specific component or all of them
#HDF_Components="kafka nifi ranger registry storm streamline zookeeper"
HDF_Components="zookeeper"

for Component in ${HDF_Components}
do
   echo "[1m[31m[4mChecking for component: ${Component} in the PUBLIC repo -> ${BASE_URL}[0m"
   echo
   curl -s ${BASE_URL}/${XML_GZ}  | gunzip -c | grep -A 3 "<name>${Component}.*" | awk -F"[ |<|>]" '/<name>/ { print "[1m[4mPackage:[0m"" "$5} ; /<checksum/ { print "[1m[4mChecksum:[0m"$7,RS}'
   echo
   echo "[1m[31m[4mChecking for component: ${Component} in the LOCAL repo -> ${LOCAL_REPO}[0m"
   echo
   #Linux
   #find ${LOCAL_REPO} -name "*.rpm" | grep "${Component}" | xargs sha256sum
   # MacOS
   find ${LOCAL_REPO} -name "*.rpm" | grep "${Component}" | xargs shasum -a 256
done

echo
#Count the packages available in the Hortonworks public repo
echo "[1m[31m[4m[HDF ${HDF_VERSION}][0m|$(curl -s ${BASE_URL}/artifacts.txt | awk '/.rpm$/ { c+=1 } ; END {print "[1m[31m[4mTotal RPM Packages:[0m"" "c, RS}')"
echo
