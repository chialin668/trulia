class SearchController < ApplicationController
  
#  before_filter :authorize, :except=>:index

  include GetParameter

  def initialize
    @app_base=app_base
    @app_name='SEARCH'
    @title='Search'
    @tagline='iFanSee Search Engine'
    @theme='aqualicious'
    @mysql_row_limit=10
    @year=current_year
  end
  
  def index
    
  end


  def search

    @query = "#{params[:query]}"

    @total, @records=ApiGrowth.full_text_search(
                                    "year:#{current_year} AND (#{@query})", # search on current year only
                                    {:page => (params[:page]||1),
                                     :sort=>['year DESC', 'county_name', 'district_name', 'county_name']})
    @pages = pages_for(@total)
    
  end
  
end
