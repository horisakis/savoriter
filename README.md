# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  - 2.4.0

* System dependencies
  - ローカル環境(Mac)
    - brew install redis
  - heroku
    - heroku create
    - heroku addons:create sendgrid:starter
    - heroku addons:create heroku-redis:hobby-dev


* Configuration
  - ローカル環境(Mac)
    - .envを作成し以下を記述
      - TWITTER_KEY="XXXXXXXXXXXX"
      - TWITTER_SECRET="XXXXXXXXXXXXXXX"
      - GOOGLE_CLIENT_ID="XXXXXXXXXXXXXXXXXXXXXXX"
      - GOOGLE_CLIENT_SECRET="XXXXXXXXXXXXX"
      - REDIS_URL="redis://localhost:6379"
    - config/environments/production.rbを編集
config.action_mailer.default_url_options をherokuアプリのURLへ変更する
  - heroku
    - heroku config:set TWITTER_KEY="XXXXXXXXXXXX"
    - heroku config:set TWITTER_SECRET="XXXXXXXXXXXXXXX"
    - heroku config:set GOOGLE_CLIENT_ID="XXXXXXXXXXXXXXXXXXXXXXX"
    - heroku config:set GOOGLE_CLIENT_SECRET="XXXXXXXXXXXXX"

* Database creation
   - ローカル環境(Mac)
     - bundle exec rails db:create


* Database initialization
   - ローカル環境(Mac)
     - bundle exec rails db:migrate
   - heroku
     - heroku run rails db:migrate


* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
   - ローカル環境(Mac)
     - redis-server
     - bundle exec sidekiq -C config/sidekiq.yml


* Deployment instructions
   - git push heroku master
   - heroku ps:scale worker=1


* ...
