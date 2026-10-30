# Deploy and Host Cobalt on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/cobalt-server?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=cobalt-server)

[Cobalt](https://github.com/imputnet/cobalt) is an open-source media downloader: paste a link to a post or video and get the file back, with no ads and no tracking. This template runs your own Cobalt processing instance on a pinned release, locked with an access key that only you hold.

## About Hosting Cobalt

The stack is one service: the Cobalt API.

- **Locked to you.** Every download request needs the `COBALT_API_KEY` generated at deploy time. Without it the instance refuses to work, so a stranger who finds the URL can't run downloads on your bandwidth bill.
- **A pinned release.** Cobalt runs a fixed version, so a redeploy never pulls in an untested upgrade.
- **Works with the cobalt.tools site.** Point the official web app at your instance and use it as before, now processed by your own server.
- **Small.** About 170 MB of memory, so it fits the Free plan.

## Common Use Cases

- A private downloader for clips and posts from TikTok, X, Instagram, Facebook, Pinterest, Tumblr, Twitch, Dailymotion and more
- A media backend for scripts, bots and apps through Cobalt's JSON API
- Saving posts from social platforms in the original quality

## Dependencies for Cobalt Hosting

- None. Cobalt is a single service with no database.

### Deployment Dependencies

- [Cobalt on GitHub](https://github.com/imputnet/cobalt)
- [Cobalt API reference](https://github.com/imputnet/cobalt/blob/main/docs/api.md)
- [Template source on GitHub](https://github.com/two-workspaces/cobalt)

### Implementation Details

**Use it from cobalt.tools.** Open [cobalt.tools](https://cobalt.tools), go to Settings → Instances, turn on the custom instance and enter your Cobalt service's Railway URL. Then turn on the API key option and paste `COBALT_API_KEY` from the Cobalt service's Variables tab.

**Use it from code.** POST to your instance URL with the key in the `Authorization` header:

```
curl -X POST https://<your-domain>/ \
  -H "Authorization: Api-Key <COBALT_API_KEY>" \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -d '{"url":"https://www.tiktok.com/@scout2015/video/6718335390845095173"}'
```

The response carries a `url` to download the file from.

**YouTube, Reddit, SoundCloud and Snapchat.** These sites block requests from cloud servers, Railway included, so Cobalt gets a "sign in to confirm you're not a bot" or empty answer for them. Tested on this template: TikTok, X, Instagram, Facebook, Pinterest, Tumblr, Twitch clips, Dailymotion, Loom, Streamable, VK and Rutube work. To use the blocked sites, route Cobalt through a residential proxy: add `HTTPS_PROXY` (for example `http://user:password@proxy.example:8080`) to the Cobalt service's variables. This is Cobalt's own [proxy setting](https://github.com/imputnet/cobalt/blob/main/docs/api-env-variables.md#http_proxy-https_proxy-no_proxy).

**Change the key.** Set `COBALT_API_KEY` to any new UUID (for example from `uuidgen`) and redeploy. The old key stops working.

**Bandwidth.** Cobalt streams many files through your instance, so downloads count toward Railway egress. Long videos are capped at 3 hours by `DURATION_LIMIT`.

**Custom domain.** Add it in the Cobalt service's Settings → Networking, then set `API_URL` to `https://` plus your domain and a trailing slash. Cobalt uses it in download links.

## Why Deploy Cobalt on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Cobalt on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
