class AdvertisementsController < ApplicationController
  before_filter :validate_owner, :only => [:edit, :update]
  before_filter :validate_advertiser, :only => [:new, :create, :current_user_ads]
  before_filter :validate_logged_in, :only => [:my_rated_ads]

  # GET /advertisements
  # GET /advertisements.json
  def index
    if (current_user && !current_user.advertiser?)
      @advertisements = Advertisement.find_recommendations_for(current_user)
      
      @advertisements += Advertisement.for_homepage(current_user).excluding_ids(@advertisements.collect(&:id))
    else
      @advertisements = Advertisement.for_homepage(current_user)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advertisements }
    end
  end

  def fb_shared
    @advertisement = Advertisement.find(params[:id])

    @advertisement.shares += 1
    @advertisement.save

    render json: { }
  end

  def current_user_ads
    @advertisements = Advertisement.my_ads(current_user)

    @is_my_rated_ads = true

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @advertisements }
    end
  end

  def my_rated_ads
    @advertisements = Advertisement.my_rated_ads(current_user)

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @advertisements }
    end
  end 

  def most_popular
    @advertisements = Advertisement.most_popular

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @advertisements }
    end
  end 

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
    redirect_to root_path and return

    @advertisement = Advertisement.find(params[:id])

    if current_user
      @user_rating = @advertisement.user_rating(current_user.id).try(:value)
      @user_rated =  @user_rating.present?
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advertisement }
    end
  end

  # GET /advertisements/new
  # GET /advertisements/new.json
  def new
    @advertisement = Advertisement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advertisement }
    end
  end

  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    advertisement = params[:advertisement]
    advertisement["ad_type"] = "video"
    advertisement["user_id"] = current_user.id

    if advertisement["content_link"].start_with? "http", "www"
      advertisement["content_link"].match /[?|&]v=([^&]*)/
      advertisement["content_link"] = $1
    end

    @advertisement = Advertisement.new(advertisement)

    respond_to do |format|
      if @advertisement.save
        format.html { redirect_to my_advertisements_path, notice: 'Advertisement was successfully created.' }
        format.json { render json: @advertisement, status: :created, location: @advertisement }
      else
        format.html { render action: "new" }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /advertisements/1
  # PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update_attributes(params[:advertisement])
        format.html { redirect_to my_advertisements_path, notice: 'Advertisement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def validate_owner
    @advertisement = Advertisement.find(params[:id])
    redirect_to root_path unless current_user.try(:id) == @advertisement.user_id
  end
  
  def validate_advertiser
    redirect_to root_path unless current_user.try(:advertiser?)
  end

  def validate_logged_in
    redirect_to root_path unless current_user
  end
end
