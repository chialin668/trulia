class StarResult < ActiveRecord::Base

  ############################################
  def self.mean_school_values(test_id, grade, school_code)
    
    sql=%Q( 
       /* mean_school_values */
       select distinct year, mean_scaled_score
       from star_results 
       where test_id = #{test_id}
         and grade = #{grade}
         and school_code = '#{school_code}'
       order by year
    ) 
    school_records=StarResult.find_by_sql(sql)
    school_hash={}
    for record in school_records
      school_hash[record.year]=record.mean_scaled_score
    end
    school_hash
  end

  def self.mean_district_values(test_id, grade, district_code, county_code)

    sql=%Q( 
        /* mean_district_values */
        select distinct year, mean_scaled_score
        from star_results 
        where school_code=0
            and grade=#{grade} 
            and test_id=#{test_id}
            and county_code = '#{county_code}'
            and district_code = '#{district_code}'
     ) 
    district_records=StarResult.find_by_sql(sql) 
    district_hash={}
    for record in district_records
      district_hash[record.year]=record.mean_scaled_score
    end
    district_hash
  end

  def self.mean_county_values(test_id, grade, county_code)

    sql=%Q( 
        /* mean_county_values */
        select distinct year, mean_scaled_score
        from star_results 
        where school_code=0
            and district_code=0
            and grade=#{grade} 
            and test_id=#{test_id}
            and county_code = '#{county_code}'
     ) 
    county_records=StarResult.find_by_sql(sql) 
    county_hash={}
    for record in county_records
      county_hash[record.year]=record.mean_scaled_score
    end
    county_hash
  end

  def self.mean_state_values(test_id, grade)

    sql=%Q( 
        /* mean_state_values */ 
        select distinct year, mean_scaled_score
        from star_results 
        where school_code=0
            and district_code=0
            and county_code=0
            and grade=#{grade} 
            and test_id=#{test_id}
     ) 
    state_records=StarResult.find_by_sql(sql) 
    state_hash={}
    for record in state_records
      state_hash[record.year]=record.mean_scaled_score
    end
    state_hash
  end

  ############################################
  # used by SchoolControler
  def self.pac_values(test_id, grade, school_code, district_code, county_code)
    sql=%Q( 
       select distinct year, pac75, pac50, pac25
       from star_results 
         where test_id = #{test_id}
         and grade = #{grade}
         and school_code = #{school_code}
         and district_code = #{district_code}
         and county_code = #{county_code}
         and (pac75>0 and pac50>0 and pac25>0)
       order by year
    ) 
    StarResult.find_by_sql(sql)
  end

  # used by SchoolControler
  def self.pct_values(test_id, grade, school_code, district_code, county_code)
    sql=%Q( 
      /* pct_values */
       select distinct year, cst_pct_advanced, cst_pct_proficient, 
             cst_pct_basic, cst_pct_below_basic, cst_pct_far_below_basic
       from star_results 
       where test_id = #{test_id}
         and grade = #{grade}
         and school_code = #{school_code}
         and district_code = #{district_code}
         and county_code = #{county_code}
         and cst_pct_advanced+cst_pct_proficient+cst_pct_basic>0
       order by year 
     ) 
     
    StarResult.find_by_sql(sql)
  end

  # used by SchoolControler
  def self.distribution_values(grade, year, school_code, district_code, county_code)
    sql=%Q(
        select distinct r.year, test_name, mean_scaled_score
            from star_results r, star_tests t 
            where r.test_id = t.test_id
            and grade = #{grade}
            and school_code = #{school_code}
            and district_code = #{district_code}
            and county_code = #{county_code}
            and r.year = #{year}
            and mean_scaled_score > 0
            and test_name like 'CST%'
    )
  StarResult.find_by_sql(sql)
  end

  def self.get_rank_mean(grade, year, school_code, test_id)
    sql=%Q(
        select state_rank_mean 
        from star_results 
        where school_code=#{school_code}
        and grade=#{grade}
        and test_id=#{test_id}
        and year=#{year}
    )
    StarResult.find_by_sql(sql)
  end

  def self.get_rank_pac75(grade, year, school_code, test_id)
    sql=%Q(
        select state_rank_pac75 
        from star_results 
        where school_code=#{school_code}
        and grade=#{grade}
        and test_id=#{test_id}
        and year=#{year}
    )
    StarResult.find_by_sql(sql)
  end

  def self.get_rank_pct(grade, year, school_code, test_id)
    sql=%Q(
        select state_rank_pct 
        from star_results 
        where school_code=#{school_code}
        and grade=#{grade}
        and test_id=#{test_id}
        and year=#{year}
    )
    StarResult.find_by_sql(sql)
  end


end





