class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :content

  def self.check_and_save_provider_all
    User.find_each do |user|
      check_and_save_provider user
    end
  end

  def self.check_and_save_provider(user)
    # TODO: DBアクセス１回にして取得後に振り分けしたほうがよさそう
    media_auths = Auth.where_medias user.id
    strage_auth = Auth.find_strage user.id
    save_media_infos = []

    media_auths.each do |media_auth|
      save_media_infos += method("check_#{media_auth.provider}").call(user, media_auth).reverse
    end

    method("save_#{strage_auth.provider}").call(strage_auth, save_media_infos) if strage_auth.present?
  end

  def self.check_twitter(user, auth)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = auth.token
      config.access_token_secret = auth.secret_token
    end

    save_media_infos = []
    save_contents = []
    latest_id = nil
    since_id = { since_id: auth.since_id } if auth.since_id.present?
    favorite_source_ids = user.favorite_contents.map(&:source_id)

    favorites = client.favorites(since_id)

    if auth.since_id.nil?
      # 初回起動時は最新IDを記録して次回から保存
      auth.update(since_id: favorites[0].id)
      return save_media_infos
    end

    favorites.each do |favorite|
      latest_id ||= favorite.id
      next if favorite.media.blank?
      break if favorite_source_ids.include?(favorite.id)

      length = favorite.media.length

      favorite.media.each_with_index do |media, idx|
        media_index = ''

        case media.type
        when 'photo'
          media_url = media.media_url.to_s
          content_type = media_url.split('.').pop

          media_index = "_#{idx}" if length > 1
        when 'video'
          if media.video_info.variants.length == 4

            # m3u8,mp4(bitrate=>256000),mp4(bitrate=>832000),mp4(bitrate=>2176000)
            # の順で入っている。m3u8の扱いはわからない、ひとまず中間のビットレートを取得しておく
            media_url = media.video_info.variants[2].url.to_s
            content_type = media.video_info.variants[2].content_type.split('/').pop

          else
            logger.error("unknown variants length url:#{media.url} info:#{media.video_info}")
          end
        when 'animated_gif'
          if media.video_info.variants.length == 1
            media_url = media.video_info.variants[0].url.to_s
            content_type = media.video_info.variants[0].content_type.split('/').pop
          else
            logger.error("unknown variants length url:#{media.url} info:#{media.video_info}")
          end
        else
          logger.error("unknown media type:#{media.type} url:#{media.url}")
        end

        title = favorite.url.to_s
                        .gsub(%r{https://|/|\.},
                              'https://' => '', '.' => '-', '/' => '_') <<
                "#{media_index}.#{content_type}"
        save_media_infos << { title: title,
                              content_type: content_type,
                              url: media_url }
      end

      save_contents << { id: favorite.id,
                         url: favorite.url.to_s,
                         oembed:   client.oembed(favorite).html }
    end

    save_contents.reverse.each do |save_content|
      content = Content.find_or_create_by(provider: 'twitter',
                                          source_id: save_content[:id],
                                          url: save_content[:url],
                                          oembed: save_content[:oembed])
      Favorite.create(user_id: auth.user_id, content_id: content.id)
    end

    auth.update(since_id: latest_id) if latest_id.present?

    save_media_infos
  end

  def self.save_google(auth, save_media_infos)
    return if save_media_infos.blank?
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        'https://www.googleapis.com/auth/drive',
        'https://www.googleapis.com/auth/userinfo.profile'
      ],
      additional_parameters: { 'access_type' => 'offline' }
    )

    credentials.refresh_token = auth.secret_token

    begin
      credentials.fetch_access_token!
      session = GoogleDrive::Session.from_credentials(credentials)

      folder_path = auth.save_path
      # TODO: 対象のフォルダを探す為一階層ごとにリクエストすることになるので
      #       フォルダ作成時にフォルダのURLをDBに保持したほうがいい
      #       保存先変更時にはURLを消す
      folder = find_or_create_folder_google(session.root_folder,
                                            folder_path.split('/'))
      save_media_infos.each do |info|
        folder.upload_from_io(open(info[:url]), info[:title])
      end
    rescue Signet::AuthorizationError
      logger.error("AuthorizationError user=#{auth.user_id} provider=#{auth.provider}")
    end

    auth.update(save_at: Time.now)
  end

  def self.find_or_create_folder_google(collection, folder_names)
    folder_name = folder_names.shift
    return collection if folder_name.blank?

    subcollections = collection.files(q: "name='#{folder_name}' and trashed = false")
    if subcollections.blank?

      subcollection = collection.create_subcollection(folder_name)
      folder_names.present? ? create_folder_google(subcollection, folder_names) : subcollection
    else

      folder_names.present? ? find_or_create_folder_google(subcollections[0], folder_names) : subcollections[0]
    end
  end

  def self.create_folder_google(collection, folder_names)
    folder_name = folder_names.shift
    return collection if folder_name.blank?

    subcollection = collection.create_subcollection(folder_name)
    folder_names.present? ? create_folder_google(subcollection, folder_names) : subcollection
  end
end
