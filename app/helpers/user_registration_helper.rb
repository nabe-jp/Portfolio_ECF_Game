module UserRegistrationHelper
  def set_edit_form_type(params)
    if params[:profile]
      @profile_edit = true
    elsif params[:password]
      @password_edit = true
    end
  end
end