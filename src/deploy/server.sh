source src/deploy/init.sh;
source src/deploy/logger.sh;

function CREAD_VOLUME() {
  docker volume create --name=$1;
}

HUB_INIT "archie";

SUCCESS "dist directory init successful";

SUCCESS "pull start";
# pull all code
cd dist/archie && git pull

# build
SUCCESS "start server build";

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./build/archie ./main.go;

SUCCESS "Begin docker build...\n";

docker build -t archie .

# deps
SUCCESS "create network and data place";

has_postgres_data=`docker volume ls | grep postgres_data`
has_redis_data=`docker volume ls | grep redis_data`

if [ ! "$has_redis_data" ]; then
  WARNING "cannot find redis_data";

  CREAD_VOLUME "redis_data";

  SUCCESS "redis_data is created";
elif [ ! "$has_postgres_data" ]; then
  WARNING "cannot find postgres_data"

  CREAD_VOLUME "postgres_data";

  SUCCESS "postgres_data is created";
fi

# create network
has_network=`docker network ls | grep archie_net`;

if [ ! "$has_network" ]; then
  WARNING "cannot find archie_net";

  docker network create archie_net;

  SUCCESS "archie_net is created";
fi

# run
docker-compose down;
docker-compose up;

SUCCESS "=========== restart successful! ============"