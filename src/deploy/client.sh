source src/deploy/init.sh;
source src/deploy/logger.sh;
source src/deploy/notify.sh;
source src/deploy/task.sh;

HUB_INIT "wizard";

# send msg to deploy platform
wizard_notify "部署开始" "1";
add_wizard_task;

SUCCESS "dist directory init successful";
SUCCESS "pull start";

# pull all code
cd dist/wizard && git pull

wizard_notify "拉取最新代码完成" "2";

SUCCESS "install deps start";
# install dependencies
yarn install

wizard_notify "安装依赖完成" "2";
wizard_notify "构建中..." "1";

SUCCESS "build start";
# build app
cd ./client && yarn build
cd ..

wizard_notify "构建完成" "2";
wizard_notify "开始构建Docker镜像" "1";

# build image
docker build -t wizard-client .;

wizard_notify "检查重启Docker镜像" "3";

WARNING "check container is running";
# stop current container
result=`docker ps | grep wizard-client`;

if [ "$result" ]; then
  WARNING "stop and remove current container";
  docker stop wizard-client
  docker rm wizard-client
fi

# run container!
docker run --name wizard-client -p 80:80 wizard-client;

wizard_notify "部署完成!" "2";
remove_wizard_task;

SUCCESS "========= client running ~ =========="