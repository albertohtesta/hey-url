# frozen_string_literal: true

class Url < ApplicationRecord

  has_many :clicks
  scope :latest, -> { limit(10).order('created_at DESC') }
  validates :original_url, url: true
  before_create :generate_short_url

  def generate_short_url
    chars = ('A'..'Z').to_a
    self.short_url = 5.times.map{ chars.sample }.join
  end

  def daily_clicks
    clicks = self.clicks.where('created_at >=? AND created_at <= ?', 
    DateTime.now.beginning_of_month-1, DateTime.now.end_of_month+1)
    array_of_clicks = clicks.group_by_day(:created_at).count.to_a
    array_of_clicks.each { |b| b[0] = b[0].day }
    return array_of_clicks
  end

  def brw_clicks
    firefox = self.clicks.where(browser: 'firefox').size
    chrome = self.clicks.where(browser: 'chrome').size
    other = self.clicks.where(browser: 'other').size
    array_of_browsers = [['firefox',firefox], ['chrome', chrome], ['other', other]]
    return array_of_browsers
  end

  def plat_clicks
    windows = self.clicks.where(platform: 'windows').size
    linux = self.clicks.where(platform: 'linux').size
    other = self.clicks.where(platform: 'other').size
    array_of_platforms = [['windows',windows], ['linux', linux], ['other', other]]
    return array_of_platforms
  end


end
