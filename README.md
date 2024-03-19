# Install Docker Engine on Ubuntu-20.04

* Docker Engine is open source and runs natively on Linux.
* All instructions are for Ubuntu-20.04 distribution.

## Windows Requirements

* For Windows install WSL2 Ubuntu-20.04 distro, helper scripts [here](https://github.com/parrotrueper/wsl2-install)

## Instructions

Open a terminal and run the installation script.

`install-docker.sh`

Test it by running the hello world docker container.

`docker run hello-world`

That's it.

## WSL2 Further instructions

One annoying thing is that the docker service may not run automatically on WSL2.

You can check if the service is running with the following command on the WSL2
terminal

`systemctl show --property ActiveState docker`

If it isn't running, you can fix this by changing your distro to boot with 
`systemd`. To enable this, edit the file `/etc/wsl.conf` and add the following:

```bash
[boot]
systemd=true
```

Then restart your WSL2 instance. 

Be aware of Microsoft's WSL2,
<span style="color:red">8 second rule for configuration changes</span>. You'll
need to wait until your Linux distro shuts down completely and then restarts for
changes to stick. Before restarting check that the previous instance of WSL2 has
actually shut down. On a PowerShell terminal type:

`wsl --list --running`

If the docker service still doesn't start automatically then you then you can
edit your `.profile` in your home directory and insert the following at the end
of it.


```bash
# check that docker is running                                
if service docker status 2>&1 | grep -q "is not running"; then
         wsl.exe -d "${WSL_DISTRO_NAME}" -u root -e /usr/sbin/service docker start >/dev/null 2>&1
fi
```

Test that docker works, by running the hello world docker container.

`docker run hello-world`

That's it.
