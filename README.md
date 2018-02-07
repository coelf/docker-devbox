# Aim 

have a light vm linux that can be used on docker for windows with rdp.

xrdp is provided to be compatible with the remote desktop of windows

# How to use

### clone the repo
```
git clone 
```

### first  container launch
systemd need some privilege and mounts to be launched

```
docker run -d --name devbox --security-opt seccomp=unconfined --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -t -p 20000:3389 -p 2222:22 devbox
```

### other container launch

```
docker start devbox
```

### Remote Desktop
use RDP application and enter `localhost:20000` as computer 

login: devuser
password: devuser

choose xvnc on the dialog in the rdp session.

same login & password as previous.

