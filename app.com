server {
    listen 80;
    server_name app.com;
    root /home/vagrant/php/app/project_web/public;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
	
	location ^~/mobile/ {
		alias /home/vagrant/php/app/h5/src/;
		  #   /home/vagrant/php/app/h5/src		
	}

	location = /mobile/index.html {
        	
		alias /home/vagrant/php/app/h5/src/index.html;
		add_header Cache-Control no-cache,no-store;
    	}
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/app.com-error.log error;
    error_page 404 /index.php;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}

