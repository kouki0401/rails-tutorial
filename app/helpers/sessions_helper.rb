module SessionsHelper
  
  def login(user)
    session[:user_id] = user.id
  end
  
  #ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #セッション消去
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #現在ログインしているユーザー
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end
  
  #渡されたユーザーがカレントユーザーか
  def current_user?(user)
    user && user == current_user
  end
  
  #ログインしていればtrueを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
    
  
end
