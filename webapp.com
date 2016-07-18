server {
        listen       80;
        server_name  localhost;

        charset utf-8;

        access_log  /var/log/nginx/webapp.access.log;
	    error_log   /var/log/nginx/webapp.error.log;

        location / {
            proxy_pass http://localhost:8080;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }


        location /auth/ {
                  proxy_pass http://qsq.com/auth/;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /getcaptcha/ {
                proxy_pass http://qsq.com/getcaptcha/;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /api3/ {
            proxy_pass http://qsq.com/api3/;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          # add_header 'Access-Control-Allow-Origin' '*';
    	  # add_header 'Access-Control-Allow-Credentials' 'true';
       	  # add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PUT, PATCH';
    	  # add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,X-User-Token,X-User-Phone';
    	  # if ($request_method = 'OPTIONS') {
          # 	add_header 'Access-Control-Max-Age' 1728000;
          # 	add_header 'Content-Type' 'text/plain charset=UTF-8';
          #	    add_header 'Content-Length' 0;
          #	    return 204;
    	  #  }
        }	

        location ~ /\.(ht|svn|git) {
            deny  all;
        }
}

