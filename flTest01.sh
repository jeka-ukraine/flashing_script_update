set -e

regex1='\w+-\S+\.(\w+)-(\S+)_Images\.tar'
regex2='\w+-\S+\_Images\.tar'
archive="rel-DAG.MFA2.C5.B2.Daily-5.1.1374_Images.tar"
vip_output='/media/sf_VM_Share/'




echo "$(basename "$archive") =~ $regex1"
echo "$(basename "$archive") =~ $regex2"


echo "Flashing $reltype version $version"
