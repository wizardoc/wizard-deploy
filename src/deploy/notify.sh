function notify {
  curl -H "Content-Type:application/json" -X POST -d '{"text": "'$1'", "type": '$2', "logType": '$3'}' http://172.18.125.57:9090/notify/$4;
}

function archie_notify {
  notify $1 $2 "1" "archie";
}

function wizard_notify {
  notify $1 $2 "2" "wizard";
}