# coding: utf-8

class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate, :except => [:show, :highlighted]

  def index
    @sections = Section.order(:ordering).all
  end

  def show
    @page = params[:page]
    @highlighted_section = Section.find(params[:id]).posts.highlighted
    @section = Section.find(params[:id])
    @posts = @section.posts.unhighlighted.visible.order("published_at desc").page(params[:page]).per(4)
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)
    respond_to do |format|
      if @section.save
        format.html { redirect_to sections_path, notice: 'Seção criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @section }
      else
        format.html { render action: 'new' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to sections_path, notice: 'Seção atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_path, notice: 'Seção excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  def highlighted
    @page = params[:page]
    @posts = Post.where(highlighted: true).page(params[:page]).per(4)
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name, :color, :ordering)
  end

end
