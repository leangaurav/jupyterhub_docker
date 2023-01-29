# Easy JupyterHub with Docker

Complete detailed setup guide is available [here](https://leangaurav.medium.com/quick-jupyterhub-setup-docker-nginx-https-letsencrypt-aws-cloud-57d1afa5c253)  

Or follow these steps.

**Step-1:**  
Have the following ready:
- A server instance with public IP and some open ports. 80 and 443 open if you wish to have https (recommended) + one other port like 8000
- Github Account since we are going to use Github OAuth
- Install docker on the server

**Step-2:**  
SSH into the server and clone this repo over there.

**Step-4:**  
Open .env and update the following
```
JUPYTERHUB_PORT
JUPYTERHUB_DATA
JUPYTERHUB_USERS_HOME
ADMIN_USERS
OAUTH_CALLBACK_URL
OAUTH_CLIENT_ID
OAUTH_CLIENT_SECRET
```
For CLIENT ID and SECRET, first create an OAuth App on Github (use this [guide](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)) using the OAUTH_CALLBACK_URL set in `.env`. Use the generated ID and SECRET.  

**Step-5:**  
Run below command and after it completes, head over to the browser and hit your `<IP>:<port>`
`docker compose up — build -d`
This should take you to your Jupyterhub server.

**If you wish to setup HTTPS continue further**  
**Step-6:**  
Go to [this repo](https://github.com/leangaurav/nginx_https_docker/) and follow the steps mentioned there.

**Step-7:**  
Go to config/nginx.conf in the nginx repo and 
paste this on top (update the port used in .env of jupyterhub repo)
```
upstream jupyterhub_service {
    server  127.0.0.1:8000;
}
```

past this within the second server block below the ssl certs path
```
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security max-age=15768000;
    
    location / {
        proxy_pass http://jupyterhub_service;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;

        # websocket headers
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Scheme $scheme;
        
        proxy_buffering off;
}
``` 
Save and close this file.

**Step-8:**  
Open jupyterhub repo's `.env` and update the OAuth callback URL with your domain name. Remove the IP and Port.  
Also update the new callback URL in the Github OAuth App.

**Step-9:**  
Now restart both docker services. (Commands need to be run in respective repo folders)
```
docker-compose up --build -d jupyterhub
docker-compose up --build -d nginx 
```

**Step-10:**  
Enjoy if it worked in the first shot. Otherwise happy learning !!
