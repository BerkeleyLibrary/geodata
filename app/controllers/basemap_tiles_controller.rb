# Proxies CARTO basemap tile requests so the API key stays server-side and
# is never exposed to the browser.
class BasemapTilesController < ApplicationController
  skip_before_action :allow_geoblacklight_params

  def carto
    y_param = params[:y].to_s.delete_suffix('.png')
    retina = y_param.end_with?('@2x') ? '@2x' : ''
    y = y_param.delete_suffix('@2x')

    response = Faraday.get(
      "https://basemaps.cartocdn.com/light_all/#{params[:z]}/#{params[:x]}/#{y}#{retina}.png",
      key: ENV.fetch('CARTO_API_KEY')
    )

    send_data response.body, type: 'image/png', disposition: 'inline'
  end
end
