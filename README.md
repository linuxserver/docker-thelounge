[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/thelounge
[![](https://images.microbadger.com/badges/image/linuxserver/thelounge.svg)](http://microbadger.com/images/linuxserver/thelounge "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/thelounge.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/thelounge.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-thelounge)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-thelounge/)
[hub]: https://hub.docker.com/r/linuxserver/thelounge/

TheLounge (a fork of shoutIRC) is a web IRC client that you host on your own server.

__What features does it have?__  
- Multiple user support
- Stays connected even when you close the browser
- Connect from multiple devices at once
- Responsive layout — works well on your smartphone
- _.. and more!_

[![theloungeirc](https://raw.githubusercontent.com/linuxserver/community-templates/master/lsiocommunity/img/shout-icon.png)][theloungeurl]
[theloungeurl]: https://thelounge.github.io/

## Usage

```
docker create \
  --name=thelounge \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -e TZ=<timezone> \
  -p 9000:9000 \
  linuxserver/thelounge
```

**Parameters**

* `-p 9000` - the port(s)
* `-v /config` -
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it thelounge /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

To log in to the application, browse to https://<hostip>:9000.

## Info

* Shell access whilst the container is running: `docker exec -it thelounge /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f thelounge`

## Versions

+ **11.09.16:** Add layer badges to README.
+ **31.08.16:** Initial Release.
