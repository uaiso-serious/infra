#!/bin/bash
helm repo add gitlab https://charts.gitlab.io/
helm repo update
kubectl create ns gitlab
kubectl -n gitlab create secret generic postgresql --from-literal=password=mysecurepassword
kubectl -n gitlab create secret generic gitlab-object-storage --from-file=connection=tmp/silo-config.yaml
kubectl -n gitlab create secret generic registry-storage --from-file=config=tmp/registry-storage.yaml
kubectl -n gitlab create secret generic s3cmd-config --from-file=s3cfg=tmp/s3cfg
kubectl -n gitlab create secret generic gitlab-initial-root-passwd --from-literal=password=yourpassword
kubectl -n gitlab apply -f base/pgsql18.yaml
kubectl -n gitlab apply -f base/valkey.yaml
kubectl -n gitlab apply -f base/silo.yaml
kubectl -n gitlab apply -f base/claudete_cm.yaml
kubectl -n gitlab rollout status statefulset/silo
kubectl -n gitlab exec pod/silo-0 -- bash -c 'mc alias set local http://localhost:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"'
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-artifacts-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-lfs-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-packages-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-backup-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-tmp-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-uploads-storage
kubectl -n gitlab exec pod/silo-0 -- mc mb local/gitlab-registry-storage
kubectl -n gitlab rollout status deployment/valkey
kubectl -n gitlab rollout status statefulset/postgres
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab --create-namespace \
  --values values.yaml \
  --version 10.4.2
kubectl -n gitlab rollout status deployment/gitlab-toolbox
kubectl -n gitlab rollout status deployment/gitlab-webservice-default
TOKEN_ROOT=$(kubectl -n gitlab exec $(kubectl -n gitlab get pod -l app=toolbox -o jsonpath='{.items[0].metadata.name}') -- \
gitlab-rails runner '
  user = User.find_by_username("root")

  if user.nil?
    puts "Erro: Usuário root não encontrado."
    exit 1
  end

  token = PersonalAccessToken.new(
    user: user,
    name: "root-api-token",
    scopes: ["api","read_api","read_user","create_runner",
    "manage_runner","k8s_proxy","self_rotate","read_repository",
    "write_repository","read_registry","write_registry",
    "ai_features","sudo","admin_mode","read_service_ping"],
    expires_at: 365.days.from_now.to_date
  )

  if token.save
    puts "#{token.token}"
  else
    erros = token.errors.full_messages.join(", ")
    puts "Erro ao criar token: #{erros}"
    exit 1
  end
')
kubectl -n gitlab create secret generic root-glab-token --from-literal="GITLAB_TOKEN=${TOKEN_ROOT}"

kubectl -n gitlab \
  run glab-runner --image=gitlab/glab:v1.123.0 \
  --restart=Never \
  --env="GITLAB_HOST=http://gitlab-webservice-default.gitlab.svc.cluster.local:8181" \
  --env="GITLAB_TOKEN=${TOKEN_ROOT}" \
  --command -- sh -c "glab config set api_protocol http --host gitlab-webservice-default.gitlab.svc.cluster.local:8181; sleep infinity"
until kubectl -n gitlab get pod glab-runner &> /dev/null; do
  sleep 1
done
kubectl -n gitlab wait --for=condition=Ready pod/glab-runner --timeout=120s

kubectl -n gitlab cp glab/install.sh glab-runner:/tmp
kubectl -n gitlab cp glab/claudete-ci.yaml glab-runner:/tmp
kubectl -n gitlab cp glab/claudete_job.yaml glab-runner:/tmp
kubectl -n gitlab cp "$HOME/.kube/config_ip" glab-runner:/tmp/kube_config
kubectl -n gitlab exec glab-runner -- ash -c '
/tmp/install.sh > /tmp/log.txt
'
TOKEN_BOT=$(kubectl -n gitlab exec glab-runner -- ash -c '
cat /tmp/token_bot.txt
')
echo "${TOKEN_BOT}"
kubectl -n gitlab create secret generic bot-git-token --from-literal="GIT_TOKEN=${TOKEN_BOT}"

#kubectl -n gitlab create secret generic bot-cicd-token --from-literal="GITLAB_TOKEN=${TOKEN_BOT_PIPE}"
#kubectl -n gitlab delete pod glab-runner

