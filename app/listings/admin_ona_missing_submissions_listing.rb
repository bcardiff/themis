class AdminOnaMissingSubmissionsListing < Listings::Base
  include ApplicationHelper

  paginates_per :none

  model do
    @ona_api = Ona::Api.new(Settings.ona_api_token)

    ids = OnaSubmission.select(:data).map { |s| s.data['_id'] }

    all_data = @ona_api.get_json("data/#{Settings.ona_dataset_id}.json")
    all_data = all_data.reject! { |data| ids.include?(data['_id']) }
    all_data.sort_by! { |data| data[:today] }

    all_data
  end

  %w[_submission_time date course teacher _id].each do |data_field|
    column data_field do |data|
      data[data_field]
    end
  end

  column 'data' do |data|
    text_modal('ver', 'Raw Data', JSON.pretty_generate(data))
  end

  column '' do |data|
    render partial: 'shared/ona_missing_submission_actions', locals: { data: data, ona_api: @ona_api }
  end
end
