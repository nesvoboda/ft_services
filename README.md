![Screenshot of ft_services](https://imgur.com/uWSHp3M.png "Screenshot")

A student project at [42.fr](https://42.fr).


A script to launch a small Kubernetes cluster with Nginx, Wordpress, PHPMyAdmin, InfluxDB and Grafana in separate Docker containers


### Features
  * NGINX Ingress Controller that exposes a Nginx container
  * Wordpress and PHPMyAdmin connected to a MariaDB container
  * Each container has Telegraf sending metrics to InfluxDB (and a Grafana container to check out the metrics)
  * Passwords for (almost) all services are automatically generated at cluster launch
  * A gorgeous index.html with all instructions (thanks Bootstrap!)
  
### How to install?

1. Clone the repo.
2. Launch setup.sh.
3. Done!

![Screenshot of ft_services](https://imgur.com/9glgac0.png "Screenshot")

### Disclaimer

Of course, this is just a student project. You shouldn't use it in anything resembling a production environment.
I've been following pretty strict project guidlines, so there are many things that aren't implemented using best practices.
