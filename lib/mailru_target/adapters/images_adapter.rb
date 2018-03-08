# frozen_string_literal: true

module MailruTarget
  # adapters for images
  module ImagesAdapter

    def create_image(presenter)
      presenter[:image_file] = File.new(presenter[:image_file], 'rb')
      # Passing empty grant_type here for params not to be
      # converted into JSON (@see #build method in request.rb)
      request(:post, '/images.json', presenter.merge(grant_type: ''))
    end

  end
end
