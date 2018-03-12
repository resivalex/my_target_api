# frozen_string_literal: true

# Content API methods for TM
module MyTargetApi
  # adapters for images and videos
  module ContentAdapter

    def static_content(presenter)
      presenter[:file] = File.new(presenter[:file], 'rb')
      # Passing empty grant_type here for params not to be
      # converted into JSON (@see #build method in request.rb)
      request(
        :post,
        '/content/static.json',
        presenter.merge(grant_type: '',
                        v: 2)
      )
    end

    def video_content(presenter)
      presenter[:file] = File.new(presenter[:file], 'rb')
      # Passing empty grant_type here for params not to be
      # converted into JSON (@see #build method in request.rb)
      request(
        :post,
        '/content/video.json',
        presenter.merge(grant_type: '',
                        v: 2)
      )
    end

  end
end
