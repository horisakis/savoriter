class ContentsController < ApplicationController
  def index
    @contents = Content.joins(:favorites).select('provider', 'source_id', 'url')
                       .order('favorites.id desc').limit(100)

    # TODO: URLが重複している場合に除去する

  end
end
