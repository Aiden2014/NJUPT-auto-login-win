# NJUPT-auto-login-win

## About The Project

It is a batch script to auto login njupt network when connecting the njupt wifi.

## Feature

- Windows friendly
- Multiple accounts, multiple wifi network
- No software installation required
- Take up very little storage space
- Easy to use

## How to use

### Clone the repository

```
git clone https://github.com/Aiden2014/NJUPT-auto-login-win.git
```

### Set the username and password in `config.ini`

```ini
[NJUPT]
users[] = B20000000 12345678A@
users[] = B20000001 12345678B@
[NJUPT-CMCC]
users[] = B20000002 12345678C@
[NJUPT-CHINANET]
users[] = B20000003 12345678D@
users[] = B20000004 12345678E@
users[] = B20000005 12345678F@
```

### Click  `set_task.bat`

Now it works when change the network and restart the computer.