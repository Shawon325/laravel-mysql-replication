# Master-Slave Replication with Laravel

```bash
    sudo docker-compose up -d 
```

### Inside Master Database Container

```bash
    sudo docker exec -it replica-master-database bash
```

### Inside Slave Database Container

```bash
    sudo docker exec -it replica-slave-database bash
```

### Goto Master Container  Then
```sql
    CREATE USER 'replication'@'%' IDENTIFIED WITH mysql_native_password BY '@@@2083@@@';
    GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
    FLUSH PRIVILEGES;
    show grants for replication@'%';
```

```sql
    SHOW MASTER STATUS\G;
```
### It will show
````sql
*************************** 1. row ***************************
             File: 1.000004
             Position: 1224
             Binlog_Do_DB: 
             Binlog_Ignore_DB: 
             Executed_Gtid_Set:
````
### Goto Slave Container  Then
```sql
CHANGE MASTER TO
MASTER_HOST='master_database',
MASTER_USER='replication',
MASTER_PASSWORD='@@@2083@@@',
MASTER_LOG_FILE='COPY_FROM_MASTER_STATUS',
MASTER_LOG_POS='COPY_FROM_MASTER_STATUS';
```

### Start Slave
```sql
    START SLAVE;
    SHOW SLAVE STATUS\G;
```
