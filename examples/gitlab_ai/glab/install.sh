#!/bin/ash

GITLAB_BOTUSERNAME=bot_agent
PROJ_DEMO=demo
PROJ_CICD=bot-cicd

ID_USER_GITLAB=$(glab api /users -X POST \
    -f name="Bot" \
    -f username="${GITLAB_BOTUSERNAME}" \
    -f email="${GITLAB_BOTUSERNAME}@uaiso.lan" \
    -f password="yourpassword" \
    -f skip_confirmation=true | jq ''.id'' -r
)
echo "ID_USER_GITLAB [${ID_USER_GITLAB}]"
EXPIRES_AT=$(date -d "@$(( $(date +%s) + 31449600 ))" +%Y-%m-%d)
echo "EXPIRES_AT: [${EXPIRES_AT}]"
TOKEN_BOT=$(glab api "/users/${ID_USER_GITLAB}/personal_access_tokens" -X POST \
    -f name="token-bot" \
    -F scopes='["api","read_api","read_user","create_runner","manage_runner","k8s_proxy","self_rotate","read_repository","write_repository","read_registry","write_registry","ai_features","sudo","admin_mode","read_service_ping"]' \
    -f expires_at="${EXPIRES_AT}" \
    | jq -r .token
)
echo "TOKEN_BOT: ${TOKEN_BOT}"

echo n | glab repo create "root/${PROJ_DEMO}" --public --readme
echo ""
echo ---------
glab api "projects/root%2F${PROJ_DEMO}/members" -X POST -F "user_id=${ID_USER_GITLAB}" -F access_level=40
echo ""
echo ---------
echo n | glab repo create "root/${PROJ_CICD}" --public
echo ""
echo ---------
TOKEN_BOT_PIPE=$(glab api "projects/root%2F${PROJ_CICD}/triggers" --method POST -f description="bot-cicd" | jq -r .token)
echo "TOKEN_BOT_PIPE: ${TOKEN_BOT_PIPE}"

PAYLOAD=$(jq -n \
  --arg branch "main" \
  --arg msg "add claudete_job.yaml" \
  --arg path "claudete_job.yaml" \
  --arg content "$(cat /tmp/claudete_job.yaml)" \
  '{
    branch: $branch,
    commit_message: $msg,
    actions: [
      {
        action: "create",
        file_path: $path,
        content: $content
      }
    ]
  }')
echo "$PAYLOAD" | glab api "projects/root%2F${PROJ_CICD}/repository/commits" --method POST --input -
echo ""
echo ---------
PAYLOAD=$(jq -n \
  --arg branch "main" \
  --arg msg "add .gitlab-ci.yml" \
  --arg path ".gitlab-ci.yml" \
  --arg content "$(cat tmp/claudete-ci.yaml)" \
  '{
    branch: $branch,
    commit_message: $msg,
    actions: [
      {
        action: "create",
        file_path: $path,
        content: $content
      }
    ]
  }')
echo "$PAYLOAD" | glab api "projects/root%2F${PROJ_CICD}/repository/commits" --method POST --input -
echo ""
echo ---------
PAYLOAD=$(jq -n \
  --arg url "http://gitlab.uaiso.lan/api/v4/projects/root%2F${PROJ_CICD}/ref/main/trigger/pipeline?token=${TOKEN_BOT_PIPE}" \
  '{
    url: $url,
    push_events: false,
    issues_events: true,
    note_events: true,
    enable_ssl_verification: false,
    name: "bot-cicd-webhook"
  }')
echo "$PAYLOAD" | glab api "projects/root%2F${PROJ_DEMO}/hooks" --method POST --input -
echo ---------

glab variable set KUBE_CONFIG -R "root/${PROJ_CICD}" -t file --raw < /tmp/kube_config

echo -n "${TOKEN_BOT}" > /tmp/token_bot.txt
#kubectl -n gitlab create secret generic bot-glab-token --from-literal="GITLAB_TOKEN=${TOKEN_BOT}"
#kubectl -n gitlab create secret generic bot-cicd-token --from-literal="GITLAB_TOKEN=${TOKEN_BOT_PIPE}"

#glab issue create --repo "root/${PROJ_DEMO}" --title "ai agent demo" --description "say hello!" --yes
