# clean 

/!\ - Important: check if the containers of the project are NOT running

# Delete a specific volume where all mariadb is located

docker volume rm <volume_name>
docker volume rm <"directory-name-location-docker-compose"+"volume-name-declared">
docker volume rm 05-01-mariadb-added_mariadb_data

By deleting the volume, we are deleting all the files and directories created during 
the instalalation and used during the execution.

Please use this technique to get a mariadb container totally fresh and with users and tables
needed for this project.