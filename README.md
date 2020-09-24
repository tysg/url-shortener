# Short URL

## Application Source
All application codes should be inside `src/` folder.

## Setup
### Run Services
```
docker-compose up -d
```

### Create Database Schema
```
./db/create-schema.sh
```

### Run unit test cases:
```
./unit-test/run.sh
```

### Run acceptance test cases:
```
./acceptance-test/run.sh
```

### Run stress tests
```
./stress-test/run.sh
```
##### Check Docker containers resource usage
```
docker stats
```
##### Check processes and their CPU time inside Docker containers
```
docker-compose top
```

## Troubleshoot
### Check if services are running
```
docker-compose ps
```
If no issue, it should look like:
```
           Name                          Command               State                  Ports
---------------------------------------------------------------------------------------------------------
short-url_acceptance-test_1   echo done                        Exit 0
short-url_mysql_1             docker-entrypoint.sh mysqld      Up       0.0.0.0:3306->3306/tcp, 33060/tcp
short-url_nginx_1             /docker-entrypoint.sh ngin ...   Up       0.0.0.0:8080->80/tcp
short-url_redis_1             docker-entrypoint.sh redis ...   Up       0.0.0.0:6379->6379/tcp
short-url_short-url_1         gunicorn --error-logfile . ...   Up
short-url_stress-test_1       k6 version                       Exit 0
```

### Check logs inside containers
```
docker-compose logs --tail="100"
```

### Check services logs
```
tail -n 100 log/*
```

### Port is already allocated
If `docker-compose up -d` returns this error:
```
Bind for 0.0.0.0:XXXX failed: port is already allocated
```
Means another service is using that port in your machine.  
Edit `docker-compose.yaml` and change the mapped port to something else.

### Services crashed
Fix the issue and restart containers.
```
docker-compose restart
```

### `docker-compose.yaml` changed
Recreate docker containers.
```
docker-compose up -d
```

### Anything inside dockerfiles changed
Rebuild containers.
```
docker-compose up -d --build
```

### Get https://registry-1.docker.io/v2/: Service Unavailable
If you have errors like `ERROR: Service 'mysql' failed to build: Get https://registry-1.docker.io/v2/: Service Unavailable`:
1. Check you internet connection.
2. Retry.