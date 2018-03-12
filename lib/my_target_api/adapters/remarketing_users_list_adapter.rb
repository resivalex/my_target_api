# frozen_string_literal: true

module MyTargetApi
  # adapters for users lists
  module RemarketingUsersListsAdapter

    def upload_remarketing_users_list(data)
      data[:file] = File.new(data[:file], 'rb')
      # Passing empty grant_type here for params not to be
      # converted into JSON (@see #build method in request.rb)
      request(:post, '/remarketing/users_lists.json', data.merge(grant_type: '', v: 2))
    end

    def delete_remarketing_users_list(users_list_id)
      request(:delete, "/remarketing/users_lists/#{users_list_id}.json", v: 2)
    end

    def read_remarketing_users_lists(data)
      request(:get, '/remarketing/users_lists.json', data.merge(v: 2))
    end

  end
end
