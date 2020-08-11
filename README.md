# Bouchon NeoToken

## Test d'un token ok

``` shell
curl -i -XGET 'http://127.0.0.1:8081/token/check?uid=ok&token=ok'
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Tue, 11 Aug 2020 19:18:12 GMT
Server: Warp/3.3.13
Content-Type: application/json;charset=utf-8

{"uid":"uidok","authentification":true}
```

## Test d'un token ko

``` shell
curl -i -XGET 'http://127.0.0.1:8888/token/check?uid=ok&token=ko'
HTTP/1.1 401 Unauthorized
Transfer-Encoding: chunked
Date: Tue, 11 Aug 2020 20:03:31 GMT
Server: Warp/3.3.13

ko
```

## Build

``` shell
nix-build -A neotoken-v2-plug.components.exes
```

