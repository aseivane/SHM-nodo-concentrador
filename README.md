# SHM-nodo-concentrador
El presente repo contiene los archivos necesarios para que el nodo concentrador del sistema SHM funcione correctamente.

## Website
El nodo concentrador aloja una pagina web desarrollada en node.js para que el usuario pueda acceder a todas las funcionalidades de manera local

## Mosquitto server
Para comunicarse con los nodos acelerometros se utiliza el protocolo MQTT, por lo que el nodo concentrador alojará el servidor correspondiente con sus configuraciones

## Tic-Toc server
Para que las mediciones sean representativas, las mismas deben estar sinronizadas con un margen de error dada la distacion a la que se ubicarán los distintos nodos y el carácter no determinístico de el tiempo de transito de una trama IP.

## Scripts de control
Para realizar acciones sobre los nodos como obtener datos, borrar la memoria SD, etc, se utilizan scripts de bash. 
