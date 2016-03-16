def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit('/sign_in')
  fill_in('Email', :with => user.email)
  fill_in('Password', :with => user.password)
  click_button "Sign In"
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def set_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin).id)
end

def sign_out
  visit sign_out_path
end