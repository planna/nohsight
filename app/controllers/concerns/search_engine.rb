# frozen_string_literal: true

module SearchEngine
   extend ActiveSupport::Concern

   # 疑似検索エンジン
   def search_results
      results = public_events(Event.all.order(start_date: :desc))
      # 日付フィルター
      # 範囲(from)
      results = date_query('from', search_params, results)
      # 範囲(to)
      results = date_query('to', search_params, results)
      # 開催地フィルター
      results = location_query(search_params, results)
      # キーワードフィルター
      results = keywd_query(search_params, results)
      return results
   end

   private

   def search_params
      return { start_date:  params[:search][:start_date],
               end_date:    params[:search][:end_date],
               keywd:       params[:search][:keywd],
               locations:   params[:search][:locations] }
   end

   def add_iterated_datas(datas, field, result)
      query = ''
      datas.each do |data|
         query += "#{field} LIKE '%#{data}%' OR "
      end
      return result.where(query[0..(query.length - 5)])
   end

   def add_iterated_query(datas, field, target)
      query = ''
      datas.each do |data|
         query += "#{target} = #{data[field]} OR "
      end
      return query
   end

   def date_query(term, search_params, results)
      if term == 'from' && search_params[:start_date] != ''
         term_query = "start_date >= '#{search_params[:start_date]}'"
      elsif term == 'to' && search_params[:end_date] != ''
         term_query = "start_date <= '#{search_params[:end_date]}'"
      end
      return results.where(term_query)
   end

   def location_query(search_params, results)
      return results if search_params[:locations].nil?
      locations = search_params[:locations].split(',')
      relative_places = add_iterated_datas(locations, 'address', Place)
      query = add_iterated_query(relative_places, 'id', 'place_id')
      return results.where(query[0..(query.length - 5)])
   end

   def where_to_array(model, keywds, field)
      array = []
      keywds.each do |keywd|
         array << model.where("#{field} LIKE '%#{keywd}%'")
      end
      array = array.flatten.compact
      return '' if array.count <= 0
      return array.uniq
   end

   def find_to_array(model, datas, field, property)
      array = []
      datas.each do |data|
         array << model.find_by("#{field}": data[property])
      end
      array = array.compact
      return '' if array.count <= 0
      return array.uniq
   end

   def performer_query_in_keywd(keywds)
      performers = where_to_array(Performer, keywds, 'full_name')
      return '' if performers == ''

      ev_pers = find_to_array(EventPerformer, performers, 'performer_id', 'id')
      return '' if ev_pers == ''
      ev_pros = find_to_array(EventProgram, ev_pers, 'id', 'event_program_id')
      return '' if ev_pros == ''
      return add_iterated_query(ev_pros, 'event_id', 'id')
   end

   def program_query_in_keywd(keywds)
      programs = where_to_array(Program, keywds, 'title')
      return '' if programs == ''
      ev_pros = find_to_array(EventProgram, programs, 'program_id', 'id')
      return '' if ev_pros == ''
      return add_iterated_query(ev_pros, 'event_id', 'id')
   end

   def ev_query_in_keywd(keywds)
      events_query = ''
      keywds.each do |keywd|
         events_query += "title LIKE '%#{keywd}%' OR "
      end
      return events_query
   end

   def keywd_query(search_params, results)
      if search_params[:keywd] != ''
         keywds = search_params[:keywd].split(/\s/)
         keywd_query = ''
         # 出演者
         keywd_query += performer_query_in_keywd(keywds)
         # 演目
         keywd_query += program_query_in_keywd(keywds)
         # 公演名
         keywd_query += ev_query_in_keywd(keywds)
         results = results.where(keywd_query[0..(keywd_query.length - 5)])
      end
      return results
   end
end
