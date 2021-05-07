# Challenge #1  Solution

## Docker-compose solution

1. Create `docker-compose-local.yaml`
2. Create `mssql-db` solution for creating db on load

## Command Line solution

1. Build `POI` container from the root of the repo

```bash
    docker build -f ./dockerfiles/Dockerfile_3 -t tripinsights/poi:1.0 ./src/poi
```

2. Setup MS SQL container

```bash
    docker network create openhack_bridge

    docker run --net openhack_bridge -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=admin@23"  -p 1433:1433 --name sql-db -h sql-db -d mcr.microsoft.com/mssql/server:2019-latest
```

3. Manually Create SQL DB

```bash
docker exec -it sql-db "bash"

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "admin@23"

CREATE database mydrivingDB
GO
```

4. Load the sample data

```bash
    docker run --network openhack_bridge -e SQLFQDN=sql-db -e SQLUSER=SA -e SQLPASS=admin@23 -e SQLDB=mydrivingDB openhack_bridge/data-load:v1
```

5. Run POI container

```bash
    docker run --network openhack_bridge --name poi -e SQLUSER=sa -e SQL_PASSWORD=admin@23 -e SQL_DBNAME=mydrivingDB -e SQL_SERVER=sql-db -e ASPNETCORE_ENVIRONMENT=Local tripinsights/poi:1.0
```

``bash
    docker-compose --env-file .env -f ".azdevops\docker-compose.yaml" up -d --build
    docker-compose --env-file .env -f ".azdevops\docker-compose.yaml" push
```


registryhns5747.azurecr.io
teamResources

## References

https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash
https://www.softwaredeveloper.blog/initialize-mssql-in-docker-container
https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose
https://docs.docker.com/config/containers/container-networking/