# dns.tiernogalvan.es

Este proyecto crea un servidor DNS autoritativo para los alumnos. Es un fork de (sadreck/SnitchDNS)[https://github.com/sadreck/SnitchDNS] con pequeñas modificaciones.


Cada alumno puede tener su zona bajo `alumno.dns.tiernogalvan.es` con registros de todo tipo (A/AAAA/TXT/CNAME/...) como:

```
www.alumno.dns.tiernogalvan.es
ftp.alumno.dns.tiernogalvan.es
servidor.alumno.dns.tiernogalvan.es
...
```

## Instalación

1. Descargar el proyecto:
```
$ git clone https://github.com/tiernogalvan/dns.tiernogalvan.es.git
```

2. Personalizar la clave secreta en `dns.tiernogalvan.es/setup/docker-tierno/Dockerfile`:
```
ARG SNITCHDNS_SECRET_KEY=RosesAreRedVioletsAreBlueThisMustBeSecretAsWellAsLongToo
```

3. Levantar el proyecto:
```
$ cd dns.tiernogalvan.es/setup/docker-tierno
$ docker compose up -d
```

Es posible que la primera vez que docker compose hace el build del proyecto de un error de Python. Simplemente volviendo a ejecutar `docker compose up -d` una o dos veces más ya vuelve a funcionar (no entiendo el motivo).

## SnitchDNS

Puedes ver el (README.md original de OpenSnitch)[README-SnitchDNS.md].

## Seguridad

El servidor está pensado para trabajar por detrás de un reverse proxy y no debe estar accesible de forma directa a internet.

El servidor está configurado para escuchar a 0.0.0.0 en el puerto 8888 (ver `dns.tiernogalvan.es/setup/docker-tierno/entrypoint.sh`), por lo que dentro de la red LAN sí que queda accesible por HTTP.

