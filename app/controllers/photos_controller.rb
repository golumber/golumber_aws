class PhotosController < ApplicationController
  
  # GET /imageable/1/photos
  # GET /imageable/1/photos.json
  def index
    @imageable = find_imageable 
    @photos = @imageable.photos

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /imageable/1/photos/1
  # GET /imageable/1/photos/1.json
  def show
    @imageable = find_imageable
    @photo = @imageable.photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /imageable/1/photos/new
  # GET /imageable/1/photos/new.json
  def new
    @imageable = find_imageable
    @photo = @imageable.photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /imageable/1/photos/1/edit
  def edit
    @imageable = find_imageable
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @imageable = find_imageable
    @photo = @imageable.photos.build(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to :id => nil, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end
end

private

def find_imageable
  params.each do |name, value|
    if name =~ /(.+)_id$/
      return $1.classify.constantize.find(value)
    end
  end
  nil
end
