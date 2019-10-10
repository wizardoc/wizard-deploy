source src/deploy/logger.sh;

function HUB_INIT() {
  # judge dist is exist
  distPath="dist"

  WRANING "dist is not exist";
  if [ ! -d $distPath ]; then
    SUCCESS "dist is created";
    mkdir $distPath;
  fi

  # judge the repository is exist
  # the first argument is name of repository
  repoPath="$distPath/$1"

  WRANING "The repo is not exist"
  if [ ! -d $repoPath ]; then    
    SUCCESS "The repo is created"
    # clone the repo here
    git clone "https://github.com/wizaaard/$1.git" $repoPath;
  fi
}