# Savoriter

![default](https://user-images.githubusercontent.com/36940346/45250497-2a773f80-b36f-11e8-80b3-1b3c83fe1a31.png)

## 概要
いいねしたメディア付きツイートの閲覧や、メディアのGoogleDriveへの自動保存が行えるサービス

## 開発経緯
https://speakerdeck.com/horisakis/savoriter

## 環境
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
   - bundle exec rspec

* Services (job queues, cache servers, search engines, etc.)
   - ローカル環境(Mac)
     - redis-server
     - bundle exec sidekiq -C config/sidekiq.yml


* Deployment instructions
   - git push heroku master
   - heroku ps:scale worker=1
