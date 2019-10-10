source src/deploy/logger.sh;

function HUB_INIT() {
  # judge dist is exist
  distPath="dist"

  if [ ! -d $distPath ]; then
    WARNING "dist is not exist";
    mkdir $distPath;
    SUCCESS "dist is created";
  fi

  # judge the repository is exist
  # the first argument is name of repository
  repoPath="$distPath/$1"

  if [ ! -d $repoPath ]; then    
    WARNING "The repo is not exist"

    # clone the repo here
    git clone "https://github.com/wizaaard/$1.git" $repoPath;
    SUCCESS "The repo is created"
  fi
}