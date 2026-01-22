# Squid

Why squid? Not AI related, proxy used to simplify dns configuration to access the ingress routes.

- ip &lt;your-k3s-ipv4&gt;
- port: 3128 tcp

[argocd](examples/argocd/index.md) and [chatbot](examples/chatbot/index.md) examples use this proxy strategy to resolve
the *.uaiso.lan dns entries.

Squid proxy running on &lt;your-k3s-ipv4&gt; port 3128.

Use http proxy in your browser to resolve the *.uaiso.lan dns and access the ingress routes.

You can configure your browser to use a http proxy manually, or use an extension like FoxyProxy.

[FoxyProxy for Chrome](https://chromewebstore.google.com/search/foxyproxy)

[FoxyProxy for Firefox](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/)

---

deploy:

```bash
kubectl apply -f squid.yaml
```
