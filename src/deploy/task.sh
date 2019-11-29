function add_task {
  curl -H "Content-Type:application/json" -X POST -d '{"name": "'$1'", "time": "'$2'"}' http://172.18.125.57:9090/task/$3;
}

function remove_task {
  curl -H "Content-Type:application/json" -X DELETE -d '{"name": "'$1'", "time": "'$2'"}' http://172.18.125.57:9090/task/$3;
}

function remove_archie_task {
  remove_task "archie-deploy" "1575020482082" "archie";
}

function remove_wizard_task {
  remove_task "wizard-deploy" "1575020482082" "wizard";
}

function add_archie_task {
  add_task "archie-deploy" "1575020482082" "archie";
}

function add_wizard_task {
  add_task "wizard-deploy" "1575020482082" "wizard";
}