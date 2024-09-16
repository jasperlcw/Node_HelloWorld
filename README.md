# Node_HelloWorld
A docker container wrapping a NodeJS instance to serve a basic Hello World web page.
### Instructions to deploy container
Before running the container, make sure that the Docker Engine is installed on the system. To run the container, simply pull the repository and run `sudo docker compose up -d`. This will build and spin up a NodeJS container that serves a Hello World webpage on port 8080, which can be used to test for network configurations and whether things are routed correctly or not.
## Using NginX as a Reverse Proxy
To use NginX as a reverse proxy (to forward port 80 to the server at port 8080), run `sudo nano /etc/nginx/sites-available/{your_domain}`, making sure to replace `{your_domain}` with a registered top level domain name (for example through CloudFlare). For example, if you want to forward requests for `example.com`, then in your terminal you can run `sudo nano /etc/nginx/sites-available/example.com`.
This will open a new configuration file for NginX, where you can enter the following:
```
server {
    listen 80;
    listen [::]:80;

    server_name {optional_sub_domain.your_domain};
        
    location / {
        proxy_pass http://127.0.0.1:8080/;
        include proxy_params;
    }
}
```
The `server_name` field lets NginX know to forward requests made to `{optional_sub_domain.your_domain}`. For example, if you want to forward all requests made to `example.com` then you can replace the entry in the `server_name` field with that domain name. If you want to only forward specific requests made to a sub-domain, for example perhaps to `helloworld.example.com` then you can replace it with that domain name instead.

The `proxy_pass` field tells NginX to forward all requests to a target server address, where in this case will be to `http://127.0.0.1:8080/`, which is the containerized NodeJS instance.

The following config file shows an entry that forwards `helloworld.example.com` and `helloworld2.example.com` to the NodeJS instance:
```
server {
    listen 80;
    listen [::]:80;

    server_name helloworld.example.com helloworld2.example.com;
        
    location / {
        proxy_pass http://127.0.0.1:8080/;
        include proxy_params;
    }
}
```
Save and exit the config file, then run `sudo ln -s /etc/nginx/sites-available/{your_domain} /etc/nginx/sites-enabled/`, making sure to replace `{your_domain}` with your own domain.

You can now test the configuration file for any syntax errors. If the test fails with `No such file or directory` as part of its contents, then double check the `/etc/nginx/sites-enabled/` directory to remove any broken symlinks.

When the NginX test passes successfully, run `sudo systemctl restart nginx` to restart the `systemd` service for it.
## Setting up a CI/CD pipeline
A pipeline for this project is set up through GitHub Actions to deploy to Amazon ECS. On a push to the main branch, a trigger is sent to the Runner to rebuild and redeploy the Hello World conatainer.
## AWS EC2 configuration
An Amazon EC2 t2.micro instance running the Ubuntu base image was used to host a Hello World container. Although UFW was not set up, the Security Group policy is set to only allow inbound and outbound on ports 443, 80, and 22 to the public. Port 8080 was open for a brief time to test the NodeJS instance.
