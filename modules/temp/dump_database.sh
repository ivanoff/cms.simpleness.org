echo -n "mysql password > "
read -s mpass
echo 

mysqldump -usirenko --password=$mpass sirenko --add-drop-table --no-create-db >current_all.sql
rm -f ../../old.sql
mv current_all.sql ../../old.sql

