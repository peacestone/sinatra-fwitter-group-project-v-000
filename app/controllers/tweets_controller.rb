class TweetsController < ApplicationController
  get "/tweets/logout" do
    session.clear
    redirect "/"
  end

  get "/tweets/new" do
    if logged_in?
      erb :"tweets/create_tweet"
    else
      redirect "/login"
    end
  end

  post "/tweets" do
    if !params[:content].empty?
      @tweet = Tweet.create(content: params[:content], user_id: current_user.id)
      redirect "/tweets"
    else
      redirect "/tweets/new"
    end
  end

  get "/tweets" do
    @tweets = Tweet.all
    if logged_in?
      erb :"tweets/tweets"
    else
      redirect "/login"
    end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    @tweets = @user.tweets
    erb :"users/tweets"
  end

  get "/tweets/:id" do
    @tweet = Tweet.find_by(id: params[:id])

    if logged_in? && @tweet
      erb :"tweets/show_tweet"
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    @tweet = Tweet.find_by(id: params[:id])
    if logged_in? && @tweet && current_user.id == session[:id]
      erb :"tweets/edit_tweet"
    else
      redirect "/login"
    end
  end

  patch "/tweets/:id" do
    @tweet = Tweet.find(params[:id])
    if !params[:content].empty?
      @tweet.update(content: params[:content] )
      redirect "/tweets"
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete "/tweets/:id/delete" do
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet && tweet.destroy
      redirect "/tweets"
    else
      tweet = Tweet.find_by(id: params[:id])
      redirect "/tweets/#{tweet.id}"
    end

  end

end
