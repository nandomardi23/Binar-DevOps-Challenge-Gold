# Deploy Express Js & React Js Dengan Gitlab CI/CD Pipeline pada Docker

Simple CRUD app built with ReactJS, ExpressJS, PostgreSQL. Dan Port Yang Akan Digunakan Sebagai Berikut:

```
Database    : postgresql(5432)
Backend     : localhost:8080
Frontend    : localhost:8081
```

## Link nya websitenya ada di sini

dev :https://dev-fernando.servercare.id/
prod :https://fernando.servercare.id/

# Setup yang perlukan

setup ini harus dilakukan secara berurut jika kamu menemukan erorr kamu harus menyelesaikannya sendiri.
resiko di tanggung pengguna...

## Membuat Dockerfile

Membuat `Dockerfile` di perlukan karena untuk menyiapkan aplikasi yang akan jalan di `container` dalam bentuk images.

### backend Dockerfile

1. cd backend/
1. touch Dockerfile
1. Copy Config Pada bawah ini
   ```
    FROM node:18-alpine
    WORKDIR /app/backend
    COPY backend/. .    # . .
    RUN npm install
    EXPOSE 8080
    CMD ["npm","start"]
   ```
1. docker build -t nando2302/backend-expressjs:1.0 .

### frontend Dockerfile

1. cd frontend/
1. touch Dockerfile
1. Copy Config Pada bawah ini

   ```
    FROM node:18-alpine

    WORKDIR /app/frontend
    COPY frontend/. .       # . .
    RUN npm install
    RUN npm run build
    EXPOSE 8081
    CMD ["npm","start"]
   ```

1. docker build -t nando2302/frontend-reactjs:1.0 .

## Docker Compose

docker compose merupakan service yang digunakan untuk menjalan multipel container atau menjalan/membuat container dalam jumlah yang banyak secara bersamaan.
docker compose terbagi menjadi 2 sebagai berikut

### Docker Compose Development

docker compose development digunakan untuk menjalankan container express,react dan postgres pada container, serta untuk menjaga data pada container postgress makan menggunakan docker volume seperti pada gambar di bawah ini.

```
    volumes:
      - dbdata:/var/lib/postgresql/data/
      - ./database/crud_db.sql:/docker-entrypoint-initdb.d/crud_db.sql
```

untuk yang lengkapnya bisa di lihat pada [docker-compose-development.yml](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/docker-compose-development.yml)
untuk menjalan docker compose maka menggunakan : `docker compose -f docker-compose-development.yml up -d`

### Docker Compose Production

docker compose production digunakan untuk menjalankan container express & react saja, dan postgres nya di letakan secara terpisah dengan aplikasi backend dan frontendnya

sehingga sebelum menjalan docker compose production kita harus menyiapkan database postgres sqlnya terlebih dahulu..

#### Setup Database postgresql

1. create cloudsql
1. samakan region dengan vm sehingga mengurangi latency antara vm & database
1. create user `people` & save password di cloudsql
1. create database `people`
1. create storage bucket
1. upload file [crud_db.sql](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/database/crud_db.sql) ke dalam bucket
1. import melalui cloudsql
1. pilih bucket yang berisi file [crud_db.sql](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/database/crud_db.sql)
1. pilih database `people` untuk memasukan data
1. lalu tekan `import`

1. ada cara lain selain yang tadi kok
1. dengan menggunkan raw [raw-crud_db.sql](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/raw/main/database/crud_db.sql)
1. masuk ke vm yang sudah anda buat dengan menggunakan ssh
1. install postgres-client
1. lalu gunakan command berikut

```
psql -p 5432 -h 34.xxx.xxx.xxx -U people -W people < crud_db.sql
```

dan jika sudah selesai makan tinggal menjalan [docker compose](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/docker-compose.yml) dengan command : `docker compose up -d `

## Reverse Proxy Nginx && SLL setup

Dalam Mendukung keamanan dan serta gampang dalam mengakses website yang sudah di deploy maka menggunakan domain serta https untuk keamanan

1. install nginx
1. terus buat file di /etc/nginx/conf.d
1. copy config di atas

```
server {
    listen  80;
    server_name dev-fernando.servercare.id;
    return  301 https://dev-fernando.servercare.id$request_uri;
}


server {
    listen                  443 ssl http2;
    server_name             dev-fernando.servercare.id;

    ssl_certificate         /etc/nginx/ssl/cert1.pem;
    ssl_certificate_key     /etc/nginx/ssl/privkey1.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    location /users {
        proxy_buffering     off;
        proxy_set_header    Host $Host;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-proton "https";
        proxy_pass          http://35.213.188.59:8080;

    }

    location / {
        proxy_buffering off;
        proxy_set_header    Host $Host;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-proton "https";

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 80000;
        proxy_pass http://35.213.188.59:8081;
    }
}
```

1. ini bagian [dev.conf](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/nginx/dev.conf)
1. ini bagian [prod.conf](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/nginx/prod.conf)
1. nah untuk mendapatkan certificate ssl sebenarnya bisa saja kita generate sendiri tetapi udah di sediakan maka langsung menggunakan yang di berikan oleh mas [syaifudin](https://gitlab.com/roboticpuppies/ssl-certificate)

1. tetapi jika kalau mager mau ngejalankan langkah-langkah yang barusan
1. kamu tinggal copy atau raw file bash script [dev](https://gitlab.com/roboticpuppies/ssl-certificate) & [prod](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/prod-nginx-ssl.sh) pada server yang sesuai ya
1. ssh ke salah satu server lalu buat folder webserver/ fyi disarankan dijalankan pada folder /home/user atau ~
1. copy juga nginx.conf tadi kedalam folder webserver [dev.conf](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/nginx/dev.conf) & [prod.conf](https://gitlab.com/fernandomardi1/binardevopsgoldchallange/-/blob/main/nginx/prod.conf)
1. pastikan anda tetap berada pada /home/user/ atau ~ dengan command `cd`
1. lalu jalankan bash `webserver/dev-nginx-ssl.sh atau webserver.prod-nginx-ssl.sh` dan tunggu hingga selesai
1. dan jangan lupa cek dengan menggunakan domain yang tadi yaa guys

# Drama Dulu gak sih....

me: Selesai Sekian dan terima kasih.... ha ?? apa cara panjang banget!??
hacker: ada cara pendek aja ga bang? pening pala ku ini
me: ada Dongg!!!
me: CuS ke selanjutnya Yaitu CI/CD
hacker : avaan tu bang CI/CD ? baru denger!
me: banyak tanya lu cil.. Mau tau kagak?
hacker: ohh iya iya mau mau bang...

# CI/CD Pipeline Menggunakan Gitlab

CI/CD merupakan metode yang Memudahkan kita dalam mendeploy aplikasi
pada tahap ini CI/CD di bagi menjadi 3 bagian yaitu

## Stage Docker build Images & Push ke Registry Dockerhub

Dalam tahap ini fokusnya hanya membuild images dan di push registry dockerhub dengan command dibawah ini

```
build-images:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"
  script:
    - echo "Build Docker Images For Backend App ..."
    - docker build --pull -t nando2302/backend-express:$CI_COMMIT_SHORT_SHA -f backend/Dockerfile .
    - docker push nando2302/backend-express:$CI_COMMIT_SHORT_SHA
    - echo "Build Docker Images for Frontend App ..."
    - docker build  -f frontend/Dockerfile -t nando2302/frontend-react:$CI_COMMIT_SHORT_SHA .
    - docker push nando2302/frontend-react:$CI_COMMIT_SHORT_SHA

```

## Stage Deploy Ke server Development

kali ini berfokus pada menjalan multipel container dengan docker compose dan menggunakan images yang sudah dibuild dan dipush di dockerhub dengan command dibawah ini

```
deploy-development:
  stage: deploy
  image: alpine
  services:
    - docker:dind
  before_script:
    - apk add openssh-client
    - eval $(ssh-agent -s)
    - echo "$DEV_SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_DEV "rm -rf  binar/ webserver/ ssl-certificate/"
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_DEV "mkdir  binar webserver"
    - scp -o StrictHostKeyChecking=no docker-compose-development.yml  $HOST_USER@$IP_ADDRESS_DEV:binar
    - scp -o StrictHostKeyChecking=no nginx/dev.conf dev-nginx-ssl.sh $HOST_USER@$IP_ADDRESS_DEV:webserver
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_DEV " cd ~/binar && mkdir database"
    - scp -o StrictHostKeyChecking=no database/crud_db.sql $HOST_USER@$IP_ADDRESS_DEV:binar/database/
    - echo "sukses"
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_DEV "cd ~/binar/ && IMAGE_TAG=$CI_COMMIT_SHORT_SHA
      docker compose -f docker-compose-development.yml up -d --force-recreate"
    - echo "success docker compose already up"
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_DEV "bash webserver/dev-nginx-ssl.sh"
    - echo "running bash script to install nginx and conf ssl success"
```

## Stage Deploy Ke Production

pada stage ini berfokus untuk menjalankan docker compose di server production dengan express dan react container dan databasenya berebeda
terdapat pada command dibawah ini

```
deploy-production:
  stage: deploy
  image: alpine
  services:
    - docker:dind
  before_script:
    - apk add openssh-client
    - apk add gettext
    - eval $(ssh-agent -s)
    - echo "$PROD_SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_PROD "rm -rf  binar/ webserver/ ssl-certificate/"
    - envsubst < .env.example > .env
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_PROD "mkdir  binar webserver"
    - scp -o StrictHostKeyChecking=no .env docker-compose.yml $HOST_USER@$IP_ADDRESS_PROD:binar
    - scp -o StrictHostKeyChecking=no prod-nginx-ssl.sh nginx/prod.conf $HOST_USER@$IP_ADDRESS_PROD:webserver
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_PROD "cd ~/binar &&
      IMAGE_TAG=$CI_COMMIT_SHORT_SHA
      docker compose up -d --force-recreate"
    - echo "success docker compose already up"
    - ssh -o StrictHostKeyChecking=no $HOST_USER@$IP_ADDRESS_PROD "bash webserver/prod-nginx-ssl.sh"
    - echo "running bash script to install nginx and conf ssl success"
  when: manual
```

# Credit

All credit goes to [M. Fikri](https://www.youtube.com/watch?v=es9_6RFR7wk&t=3336s) as creator of this app.

App used:

[Frontend](https://github.com/mfikricom/Frontend-React-MySQL)
[Backend](https://github.com/mfikricom/Backend-API-Express-MySQL)
