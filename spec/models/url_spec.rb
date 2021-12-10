# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do

    it 'validates original URL is a valid URL' do
      is_expected.to validate_url_of(:original_url) 
    end
    it 'validates short URL is present' do
      url = Url.create(original_url: "https://www.google.com/")
      expect(url.short_url).not_to be_empty
    end
    it 'validates clicks_count is incremented by one' do
      url = Url.create(original_url: "https://www.google.com/")
      click = Click.create_click(url, "chrome","linux")
      expect(url.clicks_count).to eq(1)
    end 

  end
end
