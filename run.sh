
# run infrastructure
if [ "$1" == "infrastructure" ]; then

	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra up

elif [ "$1" == "services" ]; then

	docker-compose -f services/docker-compose.yml --project-name nimbleservices up

elif [ "$1" == "start" ]; then

	# start infrastructure
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra up -d

	# wait for gateway proxy (last service started before)
	echo "Stalling for Gateway Proxy"
	wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries inf localhost:8080

	# start services
	docker-compose -f services/docker-compose.yml --project-name nimbleservices up


elif [ "$1" == "stop" ]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices down
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra down

else
    echo Usage: $0 COMMAND
    echo Commands:
    echo -e "\tinfrastructure\n\tservices\n\tstart\n\stop"
    exit 2
fi