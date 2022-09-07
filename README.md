# デプロイ手順

* サーバに接続
ssh -i "~/aws/real-world-rpg.pem" url
* git pull
* bundle install --without test development
* migration
* assets precompile
* 再起動
