# frozen_string_literal: true

module CRUDEvent
   extend ActiveSupport::Concern

   def create_event
      begin
         params_valid?
         ActiveRecord::Base.transaction do
            event = initialize_event(false, 'create')
            update_event_programs(event)
            update_tickets(event)
            event.user_events.create!(user: current_user, organizer: true)
            return event
         end
      rescue ActiveRecord::RecordInvalid
         return false
      end
   end

   def update_event(event)
      begin
         params_valid?
         ActiveRecord::Base.transaction do
            event = initialize_event(event, 'update')
            update_event_programs(event)
            update_tickets(event)
         end
         return event
      rescue ActiveRecord::RecordInvalid
         return false
      end
   end

   def initialize_event(event, mode)
      if mode == 'create'
         begin
            original_ev = Event.find(@event_params[:id])
            @event_params[:id] = nil
            event = original_ev.editions.create!(@event_params)
         rescue ActiveRecord::RecordNotFound
            event = Event.create!(@event_params)
         end
      else
         event.update_attributes!(@event_params)
      end
      return event
   end

   def update_event_programs(event)
      @event_programs_params.values.each do |ev_program_params|
         ev_program = update_relative_data_attributes(ev_program_params, EventProgram, event)
         update_event_performers(ev_program, ev_program_params[:event_performers]) if ev_program
      end
   end

   def update_event_performers(ev_program, event_performers_params)
      event_performers_params.values.each do |ev_performer_params|
         ev_performer = update_relative_data_attributes(ev_performer_params, EventPerformer, ev_program)
      end
   end

   def update_tickets(event)
      @tickets_params.values.each do |ticket_params|
         ticket = update_relative_data_attributes(ticket_params, Ticket, event)
      end
   end

   def params_valid?
      @invalid_occured = false
      @error_msgs[:place] = {}
      @event_params.merge!(place_id: create_master_data(Place, 'title', @place_params, @error_msgs[:place]))
      binding.pry
      validated_event = Event.new(@event_params)
      @error_msgs[:event] = validated_event.errors.messages
      @invalid_occured = true  unless validated_event.valid?

      @error_msgs[:event_programs] = {}
      @event_programs_params.values.each.with_index do |ev_program_params, ev_program_idx|
         ev_program_error = {}
         ev_program_error[:event_performers] = {}
         init_params = ev_program_params.reject{|key, val| !EventProgram.column_names.include?(key.to_s)}
         ev_program_params.merge!({ program_id: create_master_data(Program, 'title', ev_program_params, ev_program_error) })
         init_params.merge!({ event_id: 0, program_id: ev_program_params[:program_id] })
         ev_program = EventProgram.new(init_params)

         ev_program_params[:event_performers].values.each.with_index do |ev_performer_params, ev_performer_idx|
            ev_performer_error = {}
            init_params = ev_performer_params.reject{|key, val| !EventPerformer.column_names.include?(key.to_s)}
            ev_performer_params.merge!({ performer_id: create_master_data(Performer, 'full_name', ev_performer_params, ev_performer_error) })
            init_params.merge!({ event_program_id: 0, performer_id: ev_performer_params[:performer_id] })
            ev_performer = EventPerformer.new(init_params)
            ev_program_error[:event_performers][:"#{ev_performer_idx}"] = ev_performer_error
         end
         unless ev_program.valid?
             @invalid_occured = true
             ev_program_error.merge!(ev_program.errors.messages)
         end
         @error_msgs[:event_programs][:"#{ev_program_idx}"] = ev_program_error
      end

      @error_msgs[:tickets] = {}
      @tickets_params.values.each.with_index do |ticket_params, ticket_idx|
         ticket_error = {}
         init_params = ticket_params.reject{|key, val| !Ticket.column_names.include?(key.to_s)}
         init_params[:event_id] = 0
         ticket = Ticket.new(init_params)
         @invalid_occured = true unless ticket.valid?
         @error_msgs[:tickets][:"#{ticket_idx}"] = ticket.errors.messages
      end
      raise ActiveRecord::RecordInvalid if @invalid_occured == true
   end

   private

   def create_master_data(model, key, params, model_error = nil)
      record = model.find_or_initialize_by("#{key}": params[:"#{key}"]) do |record|
         record.attributes = params.reject{|key, val| !model.column_names.include?(key.to_s)}
         record.id = nil
      end
      if record.valid?
         record.save
         return record.id
      else
         model_error = record.errors.messages
         @invalid_occured = true
         return nil
      end
   end

   def update_relative_data_attributes(params, model, parent)
      init_params = params.reject{|key, val| !model.column_names.include?(key.to_s)}
      if params[:mode] == 'create'
         init_params.merge!({id: nil, "#{parent.class.name.underscore}_id": parent.id})
         record = model.create!(init_params)
      else
         record = model.find(params[:id])
         if params[:mode] == 'update'
            record.update_attributes!(init_params)
         else
            record.destroy!
            return nil
         end
      end
   end
end
