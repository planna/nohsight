# frozen_string_literal: true

class ProgramsController < ApplicationController
   before_action :logged_in?

   def index
      @programs = Program.all
   end

   def show
      @program = Program.find(params[:id])
   end

   def new
      @program = Program.new
   end

   def edit
      @program = Program.find(params[:id])
   end

   def create
      @program = Program.new(program_params)
      if @program.save
         flash['success'] = '演目を登録しました'
         redirect_to(program_url(@program))
      else
         flash['danger'] = '入力情報に不備があります'
         render 'programs/new'
      end
   end

   def update
      @program = Program.find(params[:id])
      if @program.update_attributes(program_params)
         flash['success'] = '演目情報を更新しました'
         redirect_to(program_url(@program))
      else
         flash['danger'] = '入力情報に不備があります'
         render 'programs/edit'
      end
   end

   def destroy
      @program = Program.find(params[:id])
      if @program.destroy
         flash['info'] = '演目を削除しました'
      else
         flash['danger'] = '演目を削除できません'
      end
      redirect_to(programs_url)
   end

   private

   def program_params
      params.require(:program).permit(:title,
                                      :category,
                                      :shimai,
                                      :duration,
                                      :place_id)
   end
end