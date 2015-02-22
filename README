Owncloud 8 in Docker
====================

Features:
- Setups Docker behind a nginx server
- Generates 8k heavy SSL certificate
- Keeps config and data in a persistent volume

Get me started
1. Set your hostname in the Dockerfile
2. Build from Repo `docker build -t owncloud .`
3. Start via `docker run -d -p 443:443 -v ./data:/var/www/owncloud/data -v ./config:/var/www/ownlcoud/config owncloud` (`./data` and `./config` point at the directories of the cloned git repository)
4. [Trust the SSL certificate](http://stackoverflow.com/a/15076602/359326)
