# Centralized Shell Aliases
# Single source of truth for all shell aliases across all modules
{ }:

{
  # === NAVIGATION ===
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # === DOCKER ===
  dps = "docker ps";
  dpa = "docker ps -a";
  di = "docker images";
  dex = "docker exec -it";
  dlog = "docker logs -f";

  # === KUBERNETES ===
  k = "kubectl";
  kgp = "kubectl get pods";
  kgs = "kubectl get services";
  kgd = "kubectl get deployments";
  klog = "kubectl logs -f";
  kex = "kubectl exec -it";

  # === API TESTING ===
  curl-json = "curl -H 'Content-Type: application/json'";
  curl-post = "curl -X POST -H 'Content-Type: application/json'";

  # === NETWORKING ===
  ports = "netstat -tulpn";

  # === DATA SCIENCE ===
  jlab = "jupyter lab";
  jnb = "jupyter notebook";
  psql-local = "psql -U tim -h localhost";
  mysql-local = "mysql -u tim -h localhost";
  mongo-local = "mongosh";
  redis-cli-local = "redis-cli";
  duck = "duckdb";
  jsonpp = "python -m json.tool";

  # === AI TOOLS ===
  chat = "ollama run llama3.2";
  "ollama-start" = "systemctl --user start ollama";
  "ollama-stop" = "systemctl --user stop ollama";
  "ollama-status" = "systemctl --user status ollama";
}
