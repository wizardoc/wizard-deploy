source src/deploy/init.sh;
source src/deploy/logger.sh;
source src/deploy/notify.sh;
source src/deploy/task.sh;

function CREAD_VOLUME {
  docker volume create --name=$1;
}

function compose_up {
  docker-compose -f /root/wizard-project/wizard-deploy/dist/archie/docker-compose.yml up -d;
}

HUB_INIT "archie";

SUCCESS "dist directory init successful";
SUCCESS "pull start";

archie_notify "部署开始" "1";
add_archie_task;

# pull all code
cd dist/archie && git pull

# build
SUCCESS "start server build";
archie_notify "开始交叉编译" "1";

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./build/archie ./main.go;

SUCCESS "Begin docker build...\n";

archie_notify "导出二进制文件成功" "2";
archie_notify "开始构建Docker镜像" "1";

docker-compose -f /root/wizard-project/wizard-deploy/dist/archie/docker-compose.yml down;

docker build -t archie .

# deps
SUCCESS "create network and data place";

archie_notify "检测镜像和Docker网络配置" "3";

has_postgres_data=`docker volume ls | grep postgres_data`
has_redis_data=`docker volume ls | grep redis_data`

archie_notify "检测Redis数据" "3";

if [ ! "$has_redis_data" ]; then
  WARNING "cannot find redis_data";

  CREAD_VOLUME "redis_data";

  SUCCESS "redis_data is created";
fi

archie_notify "检测PostgreSQL数据" "3";

if [ ! "$has_postgres_data" ]; then
  WARNING "cannot find postgres_data"

  CREAD_VOLUME "postgres_data";

  SUCCESS "postgres_data is created";
fi

# create network
has_network=`docker network ls | grep archie_net`;

archie_notify "检测Docker网络" "3";

if [ ! "$has_network" ]; then
  WARNING "cannot find archie_net";

  docker network create archie_net;

  SUCCESS "archie_net is created";
fi

archie_notify "开始重新启动Dcoker容器" "1";

# run
compose_up;

sleep 5s;

# restart compose when archie container is start failure
is_archie_img_exist=`docker ps | grep archie_archie`;
if [ ! "$is_archie_img_exist" ]; then
  archie_notify "启动失败,正在重试" "0";

  compose_up;
fi

archie_notify "构建成功!" "2";
remove_archie_task;

SUCCESS "=========== restart successful! ============"