export ZONE=us-central1-a



gcloud sql instances create wordpress --tier=db-n1-standard-1 --activation-policy=ALWAYS --gce-zone $ZONE


gcloud sql users set-password --host % root --instance wordpress --password Password1*


export ADDRESS=<external IP of blog vm/32>


gcloud sql instances patch wordpress --authorized-networks $ADDRESS --quiet


gcloud compute ssh blog --zone=us-central1-a


MYSQLIP=$(gcloud sql instances describe wordpress --format="value(ipAddresses.ipAddress)")


mysql --host=[INSTANCE_IP_ADDR] \
    --user=root --password
  

CREATE DATABASE wordpress;
CREATE USER 'blogadmin'@'%' IDENTIFIED BY 'Password1*';
GRANT ALL PRIVILEGES ON wordpress.* TO 'blogadmin'@'%';
FLUSH PRIVILEGES;



sudo mysqldump -u root -pPassword1* wordpress > wordpress_backup.sql



mysql --host=$MYSQLIP --user=root -pPassword1* --verbose wordpress < wordpress_backup.sql



sudo service apache2 restart


cd /var/www/html/wordpress



sudo nano wp-config.php 
