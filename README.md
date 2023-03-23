## Quick Start

[AllTube Download](https://github.com/Rudloff/alltube) is a Web GUI for [youtube-dl](https://github.com/ytdl-org/youtube-dl), you can use it to download videos from a lot of websites online, even if they don't want you to do this.

*AllTube* provide an [official site](http://alltubedownload.net/) to use *youtube-dl* online, or you can create one under your own domain. Unfortunately, the deployment of *AllTube* is a bit cumbersome, and a good docker can make your deployment faster.

First of all, you must have a docker environment, if not you should [install docker](https://docs.docker.com/engine/install/) first. After completion, use the following command to start *AllTube*.

```bash
docker run -d --restart always --name alltube -p 24488:80 dnomd343/alltube
```

After the command is run, *Alltube* will work on `tcp/24488`, of course, this port can be arbitrary. We can also specify the working options of *Alltube* through environment variables, the following are built-in options.

+ `TITLE=...` ：Specify the website title.

+ `REMUX=ON` ：Merge best audio and best video.

+ `STREAM=ON` ：Allow stream videos through server.

+ `CONVERT=ON` ：Enabled audio conversion.

Here is an example:

```bash
docker run -d --restart always --name alltube \
  --env TITLE="My Alltube Site" \
  --env CONVERT=ON \
  --env STREAM=ON \
  --env REMUX=ON \
  -p 24488:80 dnomd343/alltube
```

Next, configure your web server reverse proxy to `localhost:24488`, let's take *Nginx* as an example here.

```nginx
server {
    listen 80;
    server_name video.343.re;  # your domain
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name video.343.re;  # your domain
    ssl_certificate /etc/ssl/certs/343.re/fullchain.pem;  # TLS certificate of your domain
    ssl_certificate_key /etc/ssl/certs/343.re/privkey.pem;  # TLS private key of your domain
    location / {
        proxy_pass http://127.0.0.1:24488;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Finally, use the `nginx -s reload` command to take effect, visit your domain name and enjoy it!

### Advanced

If necessary, you can use the following command to build the image yourself.

```bash
docker build -t alltube https://github.com/dnomd343/alltube-docker.git
```

Due to the stagnation of the [youtube-dl](https://github.com/ytdl-org/youtube-dl) update, currently we use the [yt-dlp](https://github.com/yt-dlp/yt-dlp) project, you can manually change `YTDLP` in the Dockerfile to specify the latest version.

If you don't need the conversion function, you can remove the installation of `ffmpeg`, which will reduce the image size to a certain extent.

In addition, the project supports multi-stage builds, using the `buildx` command will speed up the build process.

### License

MIT ©2023 [@dnomd343](https://github.com/dnomd343)
