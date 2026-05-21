Followed some of the steps located [here](https://oneuptime.com/blog/post/2026-02-08-how-to-install-docker-on-linux-mint/view).

1. `sudo apt-get update`
2. `sudo apt-get install -y ca-certificates curl gnupg`
3. `sudo install -m 0755 -d /etc/apt/keyrings`
4. `sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc`
5. `sudo chmod a+r /etc/apt/keyrings/docker.asc`
6. `UBUNTU_CODENAME=$(cat /etc/upstream-release/lsb-release | grep CODENAME | cut -d '=' -f 2)`
7. `echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`
8. `sudo apt-get update`
9. `sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`
10. `sudo systemctl start docker`
11. `sudo systemctl enable docker`
12. `sudo docker login`
13. `sudo docker run hello-world`
14. `sudo usermod -aG docker $USER`
15. `sudo nano /etc/docker/daemon.json` 
>`{`
>`  "features": {`
>`    "buildkit": true`
>`  },`
>`  "log-driver": "json-file",`
>`  "log-opts": {`
>`    "max-size": "10m",`
>`    "max-file": "3"`
>`  }`
>`}`