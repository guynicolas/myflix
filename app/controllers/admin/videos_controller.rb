 class Admin::VideosController < AdminController 

  before_filter :require_user
  before_filter :require_admin 

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
     if @video.save
      flash[:success] = "You have successfully added the video: #{@video.title}."
      redirect_to new_admin_video_path
    else 
      flash[:danger] = "Your video was not added. Please correct the errors."
      render :new
    end 
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
end  