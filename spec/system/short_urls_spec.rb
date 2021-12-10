# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do

  before do
    driven_by :selenium, using: :firefox

  end

  describe 'index' do
    it 'shows a list of short urls' do
      url = Url.create(original_url: "https://www.google.com/")
      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(page).to have_selector("#aUrl")
      expect(page).to have_selector("tr>td", text: "https://www.google.com")
    end
  end

  describe 'create' do

    context 'when url is valid' do

      it 'creates the short url' do

        visit '/'
        fill_in "url[original_url]", with: "https://www.google.com/"
        click_on("Shorten URL")
        s_url = Url.first.short_url
        expect(page).to have_selector("tr>th", text: "#{s_url}")

      end

      it 'redirects to the home page' do
        visit '/'
        fill_in "url[original_url]", with: "https://www.google.com/"
        click_on("Shorten URL")
        expect(page).to have_text('HeyURL!')
      end

    end

    context 'when url is invalid' do

      it 'does not create the short url and shows a error message' do
        visit '/'
        fill_in "url[original_url]", with: "wwwgoogle"
        click_on("Shorten URL")
        expect(page).not_to have_selector("#aUrl")
        expect(page).to have_text("Original url is not a valid URL")
      end

      it 'redirects to the home page' do
        visit '/'
        fill_in "url[original_url]", with: "wwwgoogle"
        click_on("Shorten URL")
        expect(page).to have_text('HeyURL!')
      end

    end

  end

  describe 'visit' do
    it 'redirects the user to the original url' do

      url = Url.create(original_url: "https://www.google.com/")
      short_url = url.short_url
      visit visit_path("#{short_url}")
      expect(page).to have_current_path("https://www.google.com/")

    end

      it 'shows a 404 page' do
        url = Url.create(original_url: "https://www.google.com/")
        visit visit_path('NOTFOUND')
        expect(page).to have_selector(".rails-default-error-page")
      end

      it 'dislay the number of clicks of the Url' do
        visit "/"
        fill_in "url[original_url]", with: "https://www.google.com/"
        click_on("Shorten URL")
        s_url = Url.first.short_url
        click_on("#{s_url}")
        visit "/"
        expect(page).to have_selector("tr>td", text: "1")
      end

  end


  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url = Url.create(original_url: "https://www.google.com/")
      short_url = url.short_url
      visit url_path("#{short_url}")
      expect(page).to have_text("#{short_url}")
    end

    it 'shows a 404 page' do
      url = Url.create(original_url: "https://www.google.com/")
      visit url_path('NOTFOUND')
      expect(page).to have_selector(".rails-default-error-page")
    end
  end

end
