[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# lsiocommunity/shout-irc
[![Docker Pulls](https://img.shields.io/docker/pulls/lsiocommunity/shout-irc.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/lsiocommunity/shout-irc.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/Community/lsiocommunity-shout-irc)](http://jenkins.linuxserver.io:8080/job/Dockers/job/Community/job/lsiocommunity-shout-irc/)
[hub]: https://hub.docker.com/r/lsiocommunity/shout-irc/

shoutIRC is a web IRC client that you host on your own server.

__What features does it have?__  
- Multiple user support
- Stays connected even when you close the browser
- Connect from multiple devices at once
- Responsive layout — works well on your smartphone
- _.. and more!_

[![shoutirc](https://raw.githubusercontent.com/linuxserver/community-templates/master/lsiocommunity/img/shout-icon.png)][shouturl]
[shouturl]: http://shout-irc.com/

## Usage

```
docker create \
  --name=shout \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -e TZ=<timezone> \
  -p 9000:9000 \
  lsiocommunity/shout-irc
```

**Parameters**

* `-p 9000` - the port(s)
* `-v /config` -
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it shout /bin/bash`.

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

* Shell access whilst the container is running: `docker exec -it shout /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f shout`

## Versions
+ **31.08.16:** Rebase to alpine linux, move to lsiocommunity
