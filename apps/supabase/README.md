# Supabase

Why Supabase? Nice Backend as a Service (BaaS) with MCP tools.

[https://github.com/supabase/supabase](https://github.com/supabase/supabase)

ingress: [http://supabase.uaiso.lan](http://supabase.uaiso.lan)

user: supabase
password: this_password_is_insecure_and_should_be_updated

```bash
helm repo add supabase https://supabase-community.github.io/supabase-kubernetes
helm repo update
helm install supabase supabase/supabase -n supabase --create-namespace --version 0.3.3 --values values.yaml
```
