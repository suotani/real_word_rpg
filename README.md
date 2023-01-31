# デプロイ手順

* サーバに接続
ssh -i "~/aws/real-world-rpg.pem" ec2-user@ec2-13-112-227-83.ap-northeast-1.compute.amazonaws.com
* git pull
* bundle install --without test development
* RAILS_ENV=production rails db:migration
* RAILS_ENV=production rails assets:precompile
* 再起動
ps -ef | grep unicorn | grep -v grep でプロセスを確認
masterをkillする

bundle exec unicorn_rails -c /home/ec2-user/real_word_rpg/config/unicorn.rb -D -E production 

ps -ef | grep unicorn | grep -v grep でプロセスを確認

* RAILS_ENV=production rails c

* sudo service nginx start(or restart)
