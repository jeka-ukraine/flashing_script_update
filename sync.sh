#ls -l /var/lib/ | grep sshd
#drwx------    2 root     root          4096 Aug 24  1991 sshd
#if User and Group differ execute this:
#chown root:root  /var/lib/sshd -R

sync

$SSHD_ROOT_NUMBER=$(ls -l /var/lib/ | grep sshd | grep -c sshd)
if ! [ "$SSHD_ROOT_NUMBER" = "2" ]; then
	chown root:root  /var/lib/sshd -R
fi

# f=5 
# if ! [ "$f" = "7" ]; then
# 	echo "not equal"
# fi