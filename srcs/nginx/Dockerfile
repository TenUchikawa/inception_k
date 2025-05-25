# ベースイメージを指定
FROM debian:bullseye

# 必要なパッケージをインストール（NGINXとSSL用のopenssl）
RUN apt-get update && apt-get install -y nginx openssl

# デフォルトのNGINX設定をカスタム設定に置き換える
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# SSL証明書を作成する（自己署名証明書を生成）
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=Inception/CN=localhost"

# NGINXをフォアグラウンドで実行（バックグラウンドで動かさない）
CMD ["nginx", "-g", "daemon off;"]
