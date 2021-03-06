require 'text/text_util'

class NotesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :correct_user,   only: :destroy

  respond_to :html, :json
  

	def create
    if current_user.notes.last.content.empty?
      flash[:alert] = "You already have an empty note."
    else 
      @note = current_user.notes.build(params[:note])
      @note.save
      @note.move_to_top
    end
    redirect_to root_url
	end

  def edit
    @note = current_user.notes.find(params[:id])
  end

  def update
    @note = current_user.notes.find(params[:id])
    @note.update_attributes(params[:note])
    respond_with_bip @note
  end
	
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to root_url}
      format.js
    end
	end

  def index
  end

  def show
    @note = Note.find(params[:id])
  end
  
  def duplicate
    @duplicate_note = current_user.notes.find(params[:id]).dup
    @duplicate_note.content += " (copy)"
    @duplicate_note.save
    @duplicate_note.move_lower
    respond_to do |format|
      format.html { redirect_to root_url}
      format.js
    end
  end

  def sort
    params[:note].each_with_index do |id, index|
      Note.update_all({position: index+1}, {id: id})
    end
    render nothing: true    
  end

  def sort_by
    @notes = current_user.notes.order(params[:criteria])
    cookies[:sort_criteria] =  params[:criteria]
    respond_to do |format| 
      format.js { render action: "custom_sort"}
    end
  end

  def load_tags
    @note = current_user.notes.find(params[:id])
    respond_to { |format| format.js }
  end

  def update_tags
    @note = current_user.notes.find(params[:id])
    if @note.update_attributes(params[:note])
      @tags = current_user.tags.each do |tag|
        if tag.notes.empty?
          tag.delete
          current_user.tags.delete(tag)
        end
      end
      respond_to { |format| format.js }
    end
  end

  def filter_by_tags
    @notes = Note.tagged_with(params[:tag]) 
    respond_to do |format| 
      format.js { render action: "custom_sort"}
    end
  end

  def note_search
    @notes = current_user.notes.text_search(params[:query])
    respond_to { |format| format.js }
  end

	private
    def correct_user
      @note = current_user.notes.find_by_id(params[:id])
      redirect_to root_url if @note.nil?
    end
end
