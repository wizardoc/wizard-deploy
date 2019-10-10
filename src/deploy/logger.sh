function SUCCESS() {
  echo -e "\033[42m $1 \033[0m"
}

function ERROR() {
　echo -e "\033[41m $1 \033[0m" 
}

function WRANING() {
  echo -e "\033[43m $1 \033[0m"
}

function INFO() {
  echo -e "\033[32m $1 \033[0m"
}
