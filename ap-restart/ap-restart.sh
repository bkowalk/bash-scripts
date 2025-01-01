echo "restarting family room"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.100 "reboot"

echo "waiting 2 minutes"
sleep 120

echo "restarting garage"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.162 "reboot"

echo "restarting master"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.167 "reboot"

echo "restarting office"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.189 "reboot"

echo "restarting scottie"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.55 "reboot"

echo "restarting theater"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.84 "reboot"

echo "restarting utility"
ssh -i ~/.ssh/id_rsa bkowalk@192.168.1.251 "reboot"