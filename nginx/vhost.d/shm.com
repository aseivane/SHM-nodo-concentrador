location ^~ /api {
    rewrite ^/api(/.*)$ $1 break;
    proxy_read_timeout 1h;
    proxy_pass http://backend:3001/; #necesita el /
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_set_header        HOST $host;
    set $upstream_keepalive false;
}

location ^~ /files {
    proxy_pass http://filebrowser:80; #necesita el /
    proxy_set_header        Host shm.com;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    set $upstream_keepalive false;
}