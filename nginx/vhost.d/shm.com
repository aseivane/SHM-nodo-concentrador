location ^~ /api {
    rewrite ^/api(/.*)$ $1 break;
    proxy_pass http://backend:3001/; #necesita el /
    proxy_set_header Host shm.com;
    proxy_set_header X-RealIP $remote_addr;
    set $upstream_keepalive false;
}
