#!/bin/bash

#crea el directorio /usr/local/bin si no existe.
sudo mkdir -p /usr/local/bin



#crea el archivo para actualizar el sistema
sudo tee /usr/local/bin/update_system.sh > /dev/null << 'EOF'
#!/bin/bash

#actualiza el sistema 
sudo apt update && sudo apt upgrade -y

#crea y avisa en update_system.log caundo se actualizo el sistema
echo "sistema actualizado a las $(date)" >> /usr/local/bin/update_system.log
EOF



#crea el archivo para limpiar la memoria cache
sudo tee /usr/local/bin/clear_cache.sh > /dev/null << 'EOF'
#!/bin/bash

#limpia la memoria cache
sudo sync
sudo sysctl -w vm.drop_caches=3

#crea y avisa en clear_cache.log cuando se limpio la memoria cache
echo "memoria liberada a las $(date)" >> /usr/local/bin/clear_cache.log
EOF



#dar permiso para ejecutar los scripts
sudo chmod +x /usr/local/bin/update_system.sh
sudo chmod +x /usr/local/bin/clear_cache.sh



#configurar cron jobs para root
(sudo crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/clear_cache.sh") | sudo crontab -
(sudo crontab -l 2>/dev/null; echo "0 0,12* * * /usr/local/bin/update_system.sh") | sudo crontab -
