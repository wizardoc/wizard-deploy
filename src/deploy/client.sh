# stop current container
docker rm wizard-client

echo "==============pull start================"
# pull all code
cd ../dist/wizard && git pull


echo "==============install deps start=================="
# install dependencies
yarn install

echo "==============build start=================="
# build app
cd ./client && yarn build
cd ..

# build image
docker build -t wizard-client .

# run container!
docker run --name wizard-client -p 80:80 wizard-client

echo "==============running!=================="