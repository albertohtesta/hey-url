# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do

    it 'validates url_id is valid' do
      url = Url.create(original_url: "https://www.google.com/")
      click = Click.create_click(url, "chrome","linux")
      expect(click.url_id).to eq(url.id)
    end
    it 'validates the click is associated to an url' do
      url = Url.create(original_url: "https://www.google.com/")
      click = Click.create_click(url, "chrome","linux")
      expect(click.url).to eq(url)
    end
    it 'validates browser is not null' do
      url = Url.create(original_url: "https://www.google.com/")
      click = Click.create_click(url, "chrome","linux")
      expect(click.browser).not_to eq(nil)
    end
    it 'validates platform is not null' do
      url = Url.create(original_url: "https://www.google.com/")
      click = Click.create_click(url, "chrome","linux")
      expect(click.platform).not_to eq(nil)
    end

  end
end
