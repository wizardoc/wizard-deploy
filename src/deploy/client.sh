source ./init.sh;
source ./logger.sh;

HUB_INIT "wizard";

SUCCESS "dist directory init successful";

SUCCESS "pull";
# pull all code
cd ../dist/wizard && git pull

SUCCESS "install deps start";
# install dependencies
yarn install

SUCCESS "build start";
# build app
cd ./client && yarn build
cd ..

# build image
docker build -t wizard-client .

WARNING "check container is running";
# stop current container
result=`docker ps | waizard-client`;

if [ "$result" ]; then
  docker stop wizard-client
  docker rm wizard-client
fi

# run container!
docker run --name wizard-client -p 80:80 wizard-client

SUCCESS "running ~"