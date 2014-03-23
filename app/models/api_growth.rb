require 'rubygems'
#require_gem 'acts_as_ferret'

class ApiGrowth < ActiveRecord::Base

  #acts_as_ferret :remote => true, :fields => [ :school_type, :school_name, :district_name, :county_name, :year ]
  
  ##################################################
  def self.get_api_score(school_code)
    sql=%Q(
      select year, school_name, api_score
      from api_growths
      where school_code = #{school_code}
      order by year
    ) 
    ApiGrowth.find_by_sql(sql)
  end

  def self.find_api_scores(school_codes)
    sql=%Q(
      select year, api_score
      from api_growths
      where school_code in (#{school_codes})
      order by year
    ) 
    ApiGrowth.find_by_sql(sql)
  end
  
  def self.find_school_ranks(school_code)
    sql=%Q(
      select year, school_name, district_name, county_name, state_rank, district_rank, county_rank
      from api_growths g
      where school_code =#{school_code}
    ) 
    ApiGrowth.find_by_sql(sql)
  end

  def self.find_school_counts(school_type)
    sql=%Q(
      select school_type, year, count(*) count
      from api_growths 
      where school_type="#{school_type}" 
      and api_score> 0 
      group by school_type, year;
    ) 
    ApiGrowth.find_by_sql(sql)
  end
  
  def self.find_county_school_counts(school_type, county_code)
    sql=%Q(
      select school_type, year, count(*) count
      from api_growths 
      where school_type="#{school_type}" 
      and county_code=#{county_code}
      and api_score> 0 
      group by school_type, year;
    ) 
    ApiGrowth.find_by_sql(sql)
  end
  
  def self.find_district_school_counts(school_type, district_code)
    sql=%Q(
      select school_type, year, count(*) count
      from api_growths 
      where school_type="#{school_type}" 
      and district_code=#{district_code}
      and api_score> 0 
      group by school_type, year;
    ) 
    ApiGrowth.find_by_sql(sql)
  end

  ##################################################
  def self.api_rank(year, school_type, rows_per_page)
    #    @records=ApiGrowth.find(:all,
    #                            :conditions => %Q(school_type='#{@school_type}' and year='#{@year}'),
    #                            :order =>"api_score desc, school_name",
    #                            :limit => "0,#{@mysql_row_limit}")                            

    sql=%Q(
      select * 
      from api_growths
      where school_type="#{school_type}" 
      and year='#{year}'
      order by api_score desc, school_name
    ) #'
    paginate_by_sql ApiGrowth, sql, rows_per_page
    
  end
    
  
  def self.get_counties(school_type='H', year='07')
    counties=[["<Please Choose>", ""]]
    sql = %Q(
     select distinct county_name
     from api_growths
     where school_type="#{school_type}"
     and county_name != ""
     and year='#{year}'
     order by county_name;
    ) #'
    records=ApiGrowth.find_by_sql(sql)
    for record in records
      counties << record.county_name
    end
    counties
  end
  
  def self.get_district_by_county_name(school_type='H', county_name='Alameda', year='07')
    districts=[["<Please Choose>", ""]]
    sql1 = %Q(
      select distinct district_name 
      from api_growths
      where school_type='#{school_type}'
      and county_name = '#{county_name}'
      and year='#{year}'
      order by district_name;
    ) #'
    records=ApiGrowth.find_by_sql(sql1)
    for record in records
      arr=[record.district_name, record.district_name]
      districts << arr
    end
    districts
  end
  
  def self.get_school_by_county_district(school_type='H', county_name='Alameda', district_name='Alameda City Unified', year='07')
    schools=[["<Please Choose>", ""]]
    sql = %Q(
      select distinct school_name
      from api_growths
      where school_type='#{school_type}'
      and county_name = '#{county_name}'
      and district_name = '#{district_name}'
      and year='#{year}'
      order by school_name;
    ) #'
    records=ApiGrowth.find_by_sql(sql)
    for record in records
      arr=[record.school_name, record.school_name]
      schools << arr
    end
    schools
  end


=begin
select school_name, year, state_rank, county_rank, district_rank, api_score
from api_growths
where school_name like 'Lynbrook%'
order by year desc;

select sname, cname, PCST_M28, VCST_M28, CW_CSTM
from api07g_results
where sname != ''
and stype='H'
and sname in ('Oxford High', 'Whitney (Gretchen) High', 'Muir Charter',
'California Academy of Mathematics and Sc', 
'American Indian Public High', 'Lowell High',
'Portola Junior/Senior High')
order by PCST_M28+0 desc
limit 0,50;

=end      
      
end
