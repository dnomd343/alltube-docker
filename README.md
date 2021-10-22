## Quick Start

[AllTube Download](https://github.com/Rudloff/alltube) is a Web GUI for [youtube-dl](https://github.com/ytdl-org/youtube-dl), you can use it to download videos from a lot of websites online, even if they don't want you to do this.

AllTube provide an [official site](http://alltubedownload.net/) to use youtube-dl online, or you can create one under your own domain. Unfortunately, the deployment of AllTube is a bit cumbersome, and a good docker can make your deployment faster.

First of all, you must have a docker environment, if not you should [install docker](https://docs.docker.com/engine/install/) first. After completion, use the following command to start AllTube.

```
shell> docker run -dit -p 24488:80 --name alltube dnomd343/alltube
```

If necessary, you can use the following command to build the image yourself.

```
shell> docker build -t alltube https://github.com/dnomd343/alltube_docker.git
```

Next, configure your web server reverse proxy to `localhost:24488`, let's take *Nginx* as an example here.

```
server {
    listen 80;
    server_name video.343.re;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name video.343.re;
    ssl_certificate /etc/ssl/certs/343.re/fullchain.pem;
    ssl_certificate_key /etc/ssl/certs/343.re/privkey.pem;
    location / {
        proxy_set_header Host $http_host;
        proxy_pass http://127.0.0.1:24488;
    }
}
```

Finally, use the `nginx -s reload` command to take effect, visit your domain name and enjoy it !
