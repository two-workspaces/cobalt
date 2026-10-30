# Deploy and Host Cobalt on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/cobalt-server?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=cobalt-server)

[Cobalt](https://github.com/imputnet/cobalt) is an open-source media downloader: paste a link from YouTube, TikTok, Instagram, X, Reddit, SoundCloud, Vimeo, Bluesky and many more, and get the video or audio file back, with no ads and no tracking. This template runs your own Cobalt processing instance on a pinned release, locked with an access key that only you hold, plus a PO token server so YouTube downloads work from Railway.

## About Hosting Cobalt

The stack is two services: Cobalt and YouTube-Tokens.

- **Locked to you.** Every download request needs the `COBALT_API_KEY` generated at deploy time. Without it the instance refuses to work, so a stranger who finds the URL can't run downloads on your bandwidth bill.
- **YouTube ready.** YouTube blocks most requests from cloud servers that don't present a proof-of-origin (PO) token. The YouTube-Tokens service ([bgutil PO token provider](https://github.com/Brainicism/bgutil-ytdlp-pot-provider)) mints one, and Cobalt refreshes it every 5 minutes over the private network.
- **A pinned release.** Cobalt and the token server run fixed versions, so a redeploy never pulls in an untested upgrade.
- **Works with the cobalt.tools site.** Point the official web app at your instance and use it exactly as before, now processed by your own server.

## Common Use Cases

- A private downloader for your own videos, music and clips, with no ads, captchas or rate limits shared with strangers
- A media backend for scripts, bots and apps through Cobalt's JSON API
- Saving posts from social platforms in the original quality

## Dependencies for Cobalt Hosting

- YouTube-Tokens (included, private network only)

### Deployment Dependencies

- [Cobalt on GitHub](https://github.com/imputnet/cobalt)
- [Cobalt API reference](https://github.com/imputnet/cobalt/blob/main/docs/api.md)
- [Template source on GitHub](https://github.com/two-workspaces/cobalt)

### Implementation Details

**Use it from cobalt.tools.** Open [cobalt.tools](https://cobalt.tools), go to Settings → Instances, turn on the custom instance and enter your Cobalt service's Railway URL. Then turn on the API key option and paste `COBALT_API_KEY` from the Cobalt service's Variables tab. Downloads now go through your server.

**Use it from code.** POST to your instance URL with the key in the `Authorization` header:

```
curl -X POST https://<your-domain>/ \
  -H "Authorization: Api-Key <COBALT_API_KEY>" \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -d '{"url":"https://www.youtube.com/watch?v=jNQXAC9IVRw"}'
```

The response carries a `url` to download the file from.

**Change the key.** Set `COBALT_API_KEY` to any new UUID (for example from `uuidgen`) and redeploy. The old key stops working.

**Bandwidth.** Cobalt streams every file through your instance, so downloads count toward Railway egress. Long videos are capped at 3 hours by `DURATION_LIMIT`.

**Memory.** Around 200 MB at idle across both services. It fits the Free plan's 0.5 GB per service.

**Custom domain.** Add it in the Cobalt service's Settings → Networking, then set `API_URL` to `https://` plus your domain and a trailing slash. Cobalt uses it in download links.

## Why Deploy Cobalt on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Cobalt on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
