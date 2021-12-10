# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.latest

  end

  def create

    @url = Url.new(url_params)
    if @url.save
      flash[:notice] = 'The URL was created!'
      redirect_to root_path
    else
      @urls = Url.latest    
      render :index
    end

  end

  def show

    @url = Url.find_by(short_url: params[:url])
    if @url
      @daily_clicks = @url.daily_clicks
      @browsers_clicks = @url.brw_clicks
      @platform_clicks = @url.plat_clicks
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end

  end

  def visit

    @short_url = params[:short_url]
    @url = Url.find_by(short_url: @short_url)
    if(@url)
      # check browser & platform
      bro = chkbrw(bro)
      plat = chkplat(plat)
      # create click object and increment url.clicks_count
      Click.create_click(@url, bro,plat)

      redirect_to "#{@url.original_url}"
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end

  end

  private

  def url_params
    params.require(:url).permit(:original_url, :short_url)
  end

    def chkbrw(bro)
    if browser.firefox?
      bro ='firefox'
    else
      if browser.chrome?
        bro='chrome'
      else
        bro='other'
      end
    end
    return bro
  end

  def chkplat(plat)
      if browser.platform.windows?
      plat ='windows'
    else
      if browser.platform.linux?
        plat='linux'
      else
        plat='other'
      end
    end
  end

end
