#!/bin/bash
HDP_VERSION=2.6.3.16-1
BASE_URL=http://private-repo-1.hortonworks.com/HDP/centos7/2.x/updates/${HDP_VERSION}
# With this command you will see the all packages for the version of HDP
# curl -s ${BASE_URL}/artifacts.txt

#Count the packages available in the Hortonworks public repo
echo "$(curl -s ${BASE_URL}/artifacts.txt | awk '/.rpm$/ { c+=1 } ; END {print "Total RPM Packages: "c}') For HDP ${HDP_VERSION}"

XML_GZ=$(curl -s ${BASE_URL}/repodata/repomd.xml | awk -F'[ |=|"]' '/primary.xml/ {print $6}')
#curl -s ${BASE_URL}/${XML_GZ} | zgrep "<name>" | wc -l

# Compare the number of packages with the number of packages in the managed repository.  If there is a mismatch, then try to download the package in the repository and create de new Metadata for the repository, remember, double-check the MD5 for that package. If there is no difference in the count of packages, then, double-check the MD5 for each package.

#for package in $(curl -s ${BASE_URL}/artifacts.txt | awk -F"/" '/.rpm$/ {print $NF}')
for package in $(curl -s ${BASE_URL}/${XML_GZ}  | gunzip -c | awk -F"[ |<|>]" '/<name>.*/ {print $5}' | sed 's|_|-|g')
do
   echo -n "Checking ${package}: "
   curl -s ${BASE_URL}/${XML_GZ}  | gunzip -c | grep -A 3 "<name>${package}.*" | awk -F"[ |<|>]" '/<name>/ { print $5} ; /<checksum/ { print $7}'
done
