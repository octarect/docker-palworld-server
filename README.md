# docker-palworld-server

[![Releases](https://img.shields.io/github/release/octarect/docker-palworld-server/all.svg)](https://github.com/octarect/docker-palworld-server/releases)
[![GitHub](https://img.shields.io/github/license/octarect/docker-palworld-server)](https://github.com/octarect/docker-palworld-server/blob/master/LICENSE)

This docker image provides a PalWorld server and some features to operate it easily.
You can run and host the PalWorld server on a container.

The docker image is built as multi architecture image and will work on the following:

- [x] linux/arm64
- [x] linux/amd64

## Getting started

Execute the following command on your host machine.

```bash
docker container run --rm -d \
    -v $(pwd)/palworld:/palworld \
    -p 8211:8211/udp \
    ghcr.io/octarect/docker-palworld-server:latest
```

## Configuration

You can change the settings by use the following environment variables:

### General

| Variable                | Type | Default | Description                          |
|:------------------------|:----:|:--------|:-------------------------------------|
| UPDATE_ON_START         | bool | `false` | Update a server on startup           |
| ENABLE_MULTITHREAD      | bool | `true`  | Use multi threads to run a server    |
| ENABLE_COMMUNITY_SERVER | bool | `false` | Setup as a community server (public)<br>You may also want to set `PUBLIC_IP` if you host it in LAN. |

### PalWorldSettings.ini

For details of each variable, see also official document: https://tech.palworldgame.com/settings-and-operation/configuration

| Variable                                  | Type   | Default                                          |
|:------------------------------------------|:------:|:-------------------------------------------------|
| ACTIVE_UNKO                               | bool   | `False`                                          |
| ADMIN_PASSWORD                            | string | `""`                                             |
| ALLOW_CONNECT_PLATFORM                    | string | `"Steam"`                                        |
| AUTO_RESET_GUILD_NO_ONLINE_PLAYERS        | bool   | `False`                                          |
| AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS   | float  | `72.000000`                                      |
| AUTO_SAVE_SPAN                            | float  | `30.000000`                                      |
| BAN_LIST_URL                              | string | `"https://api.palworldgame.com/api/banlist.txt"` |
| BASE_CAMP_MAX_NUM_IN_GUILD                | int    | `4`                                              |
| BASE_CAMP_MAX_NUM                         | int    | `128`                                            |
| BASE_CAMP_WORKER_MAX_NUM                  | int    | `15`                                             |
| BUILD_OBJECT_DAMAGE_RATE                  | float  | `1.000000`                                       |
| BUILD_OBJECT_DETERIORATION_DAMAGE_RATE    | float  | `1.000000`                                       |
| CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP | bool   | `False`                                          |
| COLLECTION_DROP_RATE                      | float  | `1.000000`                                       |
| COLLECTION_OBJECT_HP_RATE                 | float  | `1.000000`                                       |
| COLLECTION_OBJECT_RESPAWN_SPEED_RATE      | float  | `1.000000`                                       |
| COOP_PLAYER_MAX_NUM                       | int    | `4`                                              |
| DAY_TIME_SPEED_RATE                       | float  | `1.000000`                                       |
| DEATH_PENALTY                             | string | `"All"`                                          |
| DIFFICULTY                                | string | `"None"`                                         |
| DROP_ITEM_ALIVE_MAX_HOURS                 | float  | `1.000000`                                       |
| DROP_ITEM_MAX_NUM                         | int    | `3000`                                           |
| DROP_ITEM_MAX_NUM_UNKO                    | int    | `100`                                            |
| ENABLE_AIM_ASSIST_KEYBOARD                | bool   | `False`                                          |
| ENABLE_AIM_ASSIST_PAD                     | bool   | `True`                                           |
| ENABLE_DEFENSE_OTHER_GUILD_PLAYER         | bool   | `False`                                          |
| ENABLE_FAST_TRAVEL                        | bool   | `True`                                           |
| ENABLE_FRIENDLY_FIRE                      | bool   | `False`                                          |
| ENABLE_INVADER_ENEMY                      | bool   | `True`                                           |
| ENABLE_NON_LOGIN_PENALTY                  | bool   | `True`                                           |
| ENABLE_PLAYER_TO_PLAYER_DAMAGE            | bool   | `False`                                          |
| ENEMY_DROP_ITEM_RATE                      | float  | `1.000000`                                       |
| EXIST_PLAYER_AFTER_LOGOUT                 | bool   | `False`                                          |
| EXP_RATE                                  | float  | `1.000000`                                       |
| GUILD_PLAYER_MAX_NUM                      | int    | `20`                                             |
| INVISIBLE_OTHER_GUILD_BASE_CAMP_AREA_FX   | bool   | `False`                                          |
| IS_MULTIPLAY                              | bool   | `False`                                          |
| IS_PVP                                    | bool   | `False`                                          |
| IS_START_LOCATION_SELECT_BY_MAP           | bool   | `True`                                           |
| IS_USE_BACKUP_SAVE_DATA                   | bool   | `True`                                           |
| LOG_FORMAT_TYPE                           | string | `"Text"`                                         |
| NIGHT_TIME_SPEED_RATE                     | float  | `1.000000`                                       |
| PAL_AUTO_HP_REGENE_RATE                   | float  | `1.000000`                                       |
| PAL_AUTO_HP_REGENE_RATE_IN_SLEEP          | float  | `1.000000`                                       |
| PAL_CAPTURE_RATE                          | float  | `1.000000`                                       |
| PAL_DAMAGE_RATE_ATTACK                    | float  | `1.000000`                                       |
| PAL_DAMAGE_RATE_DEFENSE                   | float  | `1.000000`                                       |
| PAL_EGG_DEFAULT_HATCHING_TIME             | float  | `72.000000`                                      |
| PAL_SPAWN_NUM_RATE                        | float  | `1.000000`                                       |
| PAL_STAMINA_DECREACE_RATE                 | float  | `1.000000`                                       |
| PAL_STOMACH_DECREACE_RATE                 | float  | `1.000000`                                       |
| PLAYER_AUTO_HP_REGENE_RATE                | float  | `1.000000`                                       |
| PLAYER_AUTO_HP_REGENE_RATE_IN_SLEEP       | float  | `1.000000`                                       |
| PLAYER_DAMAGE_RATE_ATTACK                 | float  | `1.000000`                                       |
| PLAYER_DAMAGE_RATE_DEFENSE                | float  | `1.000000`                                       |
| PLAYER_STAMINA_DECREACE_RATE              | float  | `1.000000`                                       |
| PLAYER_STOMACH_DECREACE_RATE              | float  | `1.000000`                                       |
| PUBLIC_IP                                 | string | `""`                                             |
| PUBLIC_PORT                               | int    | `8211`                                           |
| RCON_ENABLED                              | bool   | `False`                                          |
| RCON_PORT                                 | int    | `25575`                                          |
| REGION                                    | string | `""`                                             |
| RESTAPI_ENABLED                           | bool   | `False`                                          |
| RESTAPI_PORT                              | int    | `8212`                                           |
| SERVER_DESCRIPTION                        | string | `""`                                             |
| SERVER_NAME                               | string | `"Default Palworld Server"`                      |
| SERVER_PASSWORD                           | string | `""`                                             |
| SERVER_PLAYER_MAX_NUM                     | int    | `32`                                             |
| SHOW_PLAYER_LIST                          | bool   | `False`                                          |
| USE_AUTH                                  | bool   | `True`                                           |
| WORKSPEED_RATE                            | float  | `1.000000`                                       |

### Engine.ini

> See also: [Optimizing PalWorld Dedicated Server: Engine.ini Settings to Reduce Lag and Rubberbanding - Reddit](https://www.reddit.com/r/Palworld/comments/19f6i19/optimizing_palworld_dedicated_server_engineini/)

| Variable                   | Type | Default | Description                     |
|:---------------------------|:----:|:--------|:--------------------------------|
| ENABLE_ENGINE_OPTIMIZATION | bool | `false` | Generate an optimized Engine.ini |

If you set `ENABLE_ENGINE_OPTIMIZATION=true`, you can customize each value in Engine.ini.
(Of course, you can also use the generated file as-is.)

| Variable                      | Type  | Default      |
|:------------------------------|:-----:|:-------------|
| LAN_SERVER_MAX_TICK_RATE      | int   | `120`        |
| NET_SERVER_MAX_TICK_RATE      | int   | `120`        |
| CONFIGURED_INTERNET_SPEED     | int   | `104857600`  |
| CONFIGURED_LAN_SPEED          | int   | `104857600`  |
| MAX_CLIENT_RATE               | int   | `104857600`  |
| MAX_INTERNET_CLIENT_RATE      | int   | `104857600`  |
| SMOOTH_FRAME_RATE             | bool  | `true`       |
| USE_FIXED_FRAME_RATE          | bool  | `false`      |
| SMOOTH_FRAME_RATE_LOWER_LIMIT | float | `30.000000`  |
| SMOOTH_FRAME_RATE_UPPER_LIMIT | float | `120.000000` |
| MIN_DESIRED_FRAME_RATE        | float | `60.000000`  |
| FIXED_FRAME_RATE              | float | `120.000000` |
| NET_CLIENT_TICKS_PER_SECOND   | int   | `120`        |

## License

[MIT license](./LICENSE)
